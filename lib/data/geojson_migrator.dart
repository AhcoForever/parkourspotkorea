import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../model/geofeature.dart';

class GeoJsonMigrator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> migrateGeoJsonToFirestore({
    required String geoJsonFilePath,
    required String collectionName,
  }) async {
    try {
      print('🚀 마이그레이션 시작: $geoJsonFilePath -> $collectionName');

      // 1. GeoJSON 파일 읽기
      String geoJsonString = await _readGeoJsonFile(geoJsonFilePath);

      // 2. JSON 파싱
      Map<String, dynamic> geoJsonData = json.decode(geoJsonString);

      // 3. Features 추출
      List<dynamic> features = geoJsonData['features'] ?? [];

      print('📊 총 ${features.length}개의 Feature를 마이그레이션합니다.');

      // 4. 각 Feature를 Geofeature 객체로 변환하고 Firestore에 저장
      for (int i = 0; i < features.length; i++) {
        await _saveGeofeatureToFirestore(features[i], collectionName);

        // 진행률 출력 (10개마다)
        if ((i + 1) % 10 == 0 || i == features.length - 1) {
          print('📈 Progress: ${i + 1}/${features.length} (${((i + 1) / features.length * 100).toStringAsFixed(1)}%)');
        }
      }

      print('✅ 마이그레이션이 완료되었습니다!');

    } catch (e) {
      print('❌ 마이그레이션 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// GeoJSON 파일 읽기
  Future<String> _readGeoJsonFile(String filePath) async {
    try {
      // assets에서 읽기
      if (filePath.startsWith('assets/')) {
        return await rootBundle.loadString(filePath);
      }
      // 로컬 파일에서 읽기
      else {
        File file = File(filePath);
        return await file.readAsString();
      }
    } catch (e) {
      throw Exception('GeoJSON 파일을 읽을 수 없습니다: $e');
    }
  }

  /// 개별 Feature를 Geofeature 객체로 변환하고 Firestore에 저장
  Future<void> _saveGeofeatureToFirestore(
      Map<String, dynamic> feature,
      String collectionName
      ) async {
    try {
      // GeoJSON Feature를 Geofeature 객체로 변환
      Geofeature geofeature = Geofeature.fromGeoJson(feature);

      // Firestore에 저장할 데이터로 변환
      Map<String, dynamic> firestoreData = geofeature.toMap();

      // Firestore에 문서 추가 (ID 자동 생성)
      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(firestoreData);

      // 생성된 문서 ID를 필드에도 추가
      await docRef.update({
        'document_id': docRef.id,
      });

      print('💾 저장 완료 - ID: ${docRef.id}, 지역: ${geofeature.adm_nm}');

    } catch (e) {
      print('❌ Feature 저장 중 오류: $e');
      rethrow;
    }
  }

  /// 마이그레이션 상태 확인
  Future<void> checkMigrationStatus(String collectionName) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      print('📊 컬렉션 "$collectionName"에 ${snapshot.docs.length}개의 문서가 있습니다.');

      // 첫 번째 문서 샘플 출력
      if (snapshot.docs.isNotEmpty) {
        print('📄 샘플 문서:');
        Map<String, dynamic> sampleData = snapshot.docs.first.data() as Map<String, dynamic>;

        // Geofeature 객체로 변환해서 출력
        Geofeature sampleGeofeature = Geofeature.fromMap(sampleData, docId: snapshot.docs.first.id);
        print('   - ID: ${sampleGeofeature.id}');
        print('   - 지역명: ${sampleGeofeature.adm_nm}');
        print('   - 시도: ${sampleGeofeature.sidonm}');
        print('   - 시군구: ${sampleGeofeature.sggnm}');
        print('   - 좌표 길이: ${sampleGeofeature.coordinate.length} characters');
      }
    } catch (e) {
      print('❌ 상태 확인 중 오류: $e');
    }
  }

  /// 지역별 Geofeature 조회
  Future<List<Geofeature>> getGeofeaturesByRegion({
    required String collectionName,
    required String sidonm,
    String? sggnm,
  }) async {
    try {
      Query query = _firestore
          .collection(collectionName)
          .where('sidonm', isEqualTo: sidonm);

      if (sggnm != null) {
        query = query.where('sggnm', isEqualTo: sggnm);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Geofeature.fromMap(data, docId: doc.id);
      }).toList();

    } catch (e) {
      print('❌ 조회 중 오류: $e');
      return [];
    }
  }

  /// 특정 행정구역 코드로 조회
  Future<Geofeature?> getGeofeatureByAdmCd({
    required String collectionName,
    required int admCd2,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('adm_cd2', isEqualTo: admCd2)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        return Geofeature.fromMap(data, docId: snapshot.docs.first.id);
      }

      return null;
    } catch (e) {
      print('❌ 조회 중 오류: $e');
      return null;
    }
  }

  /// 좌표 문자열을 다시 List로 변환하는 유틸리티
  List<dynamic> parseCoordinates(String coordinateString) {
    try {
      return json.decode(coordinateString) as List<dynamic>;
    } catch (e) {
      print('❌ 좌표 파싱 오류: $e');
      return [];
    }
  }
}
