import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

class AdmCd2Updater {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateAdmCd2() async {
    try {
      print('🚀 adm_cd2 필드 업데이트 시작...\n');

      // 1. GeoJSON 파일 읽기
      print('📁 GeoJSON 파일을 읽는 중...');
      final geoJsonFile = File(
        'assets/GeoJSON/HangJeongDong_ver20250401.geojson',
      );

      if (!await geoJsonFile.exists()) {
        throw Exception('GeoJSON 파일을 찾을 수 없습니다: ${geoJsonFile.path}');
      }

      final geoJsonString = await geoJsonFile.readAsString();
      final geoJsonData = jsonDecode(geoJsonString);
      final List<dynamic> features = geoJsonData['features'] ?? [];

      print('✅ 총 ${features.length}개의 지역 데이터를 찾았습니다.\n');

      // 2. GeoJSON 데이터를 adm_cd 기준으로 매핑 (adm_cd -> adm_cd2)
      print('🗺️  데이터 매핑 중... (adm_cd 기준)');
      final Map<int, int> admCodeToCd2 = {}; // key: adm_cd(정수), value: adm_cd2(정수)
      int validDataCount = 0;

      for (final feature in features) {
        final properties = feature['properties'] as Map<String, dynamic>?;
        if (properties == null) continue;

        final String? admCdStr = properties['adm_cd'] as String?;   // 예: "11010570"
        final String? admCd2Str = properties['adm_cd2'] as String?; // 예: "1111057000"
        final int? admCd = int.tryParse(admCdStr ?? '');
        final int? admCd2 = int.tryParse(admCd2Str ?? '');
        if (admCd != null && admCd2 != null) {
          admCodeToCd2[admCd] = admCd2; // 둘 다 정수로 저장
          validDataCount++;
        }
      }

      print('✅ $validDataCount개의 유효한 매핑 데이터를 생성했습니다. (adm_cd→adm_cd2)\n');

      // 3. Firestore 컬렉션에서 모든 문서 페이지네이션 조회 + 배치 업데이트
      print('🔍 Firestore에서 dong_features 컬렉션 조회(페이지네이션) 시작...');
      const int PAGE_SIZE = 1000;   // 읽기 페이지 크기
      const int BATCH_LIMIT = 450;  // 쓰기 배치 한도(500 대비 여유)

      Query query = _firestore
          .collection('dong_features')
          .orderBy(FieldPath.documentId)
          .limit(PAGE_SIZE);

      DocumentSnapshot? lastDoc;
      WriteBatch batch = _firestore.batch();
      int pending = 0;

      int updateCount = 0;
      int notFoundCount = 0;
      int scanned = 0;

      Future<void> commitIfNeeded({bool force = false}) async {
        if (force || pending >= BATCH_LIMIT) {
          print('💾 배치 커밋: ${pending}건');
          await batch.commit();
          batch = _firestore.batch();
          pending = 0;
        }
      }

      while (true) {
        final Query curr = (lastDoc == null)
            ? query
            : query.startAfterDocument(lastDoc!);
        final QuerySnapshot page = await curr.get();
        if (page.docs.isEmpty) break;

        for (final doc in page.docs) {
          scanned++;
          final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

          // Firestore의 adm_cd는 정수 또는 문자열일 수 있으므로 안전 파싱
          final int? admCd = (docData['adm_cd'] is int)
              ? docData['adm_cd'] as int
              : int.tryParse('${docData['adm_cd']}');

          if (admCd != null && admCodeToCd2.containsKey(admCd)) {
            final int admCd2Value = admCodeToCd2[admCd]!; // 정수로 저장
            batch.update(doc.reference, {'adm_cd2': admCd2Value});
            updateCount++;
            pending++;
            await commitIfNeeded();
          } else {
            notFoundCount++;
          }
        }

        lastDoc = page.docs.last;
        print('📃 스캔 진행: $scanned 문서 처리됨, 업데이트 예정: $updateCount, 미매칭 누적: $notFoundCount');
      }

      await commitIfNeeded(force: true);
      print('✅ 배치 업데이트 완료. 업데이트된 문서: $updateCount개, 매칭 실패: $notFoundCount개\n');

      // 6. 결과 요약
      print('📊 === 업데이트 결과 ===');
      print('✅ 성공적으로 업데이트된 문서: $updateCount개');
      print('⚠️  매칭되지 않은 문서: $notFoundCount개');
      print('🗺️  GeoJSON 데이터: $validDataCount개\n');

      if (notFoundCount > 0) {
        print('💡 매칭되지 않은 문서가 있습니다.');
        print('   adm_cd 값이 GeoJSON의 adm_cd와 일치하는지 확인해보세요.');
      }
    } catch (error) {
      print('\n❌ 오류 발생: $error');
      rethrow;
    }
  }
}

// Firebase 초기화 및 실행
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase 초기화 완료\n');

    // 업데이트 실행
    final updater = AdmCd2Updater();
    await updater.updateAdmCd2();

    print('🎉 프로세스 완료');
    exit(0);
  } catch (error) {
    print('💥 프로세스 실패: $error');
    exit(1);
  }
}
