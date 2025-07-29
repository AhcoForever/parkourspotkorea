import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

///파일 -> 객체 -> Firestore
class GeoJsonMigrator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GeoJSON 파일을 Firestore로 마이그레이션하는 메인 함수
  Future<void> migrateGeoJsonToFirestore({
    required String geoJsonFilePath,
    required String collectionName,
  }) async {
    try {
      // 1. GeoJSON 파일 읽기
      String geoJsonString = await _readGeoJsonFile(geoJsonFilePath);

      // 2. JSON 파싱
      Map<String, dynamic> geoJsonData = json.decode(geoJsonString);

      // 3. Features 추출
      List<dynamic> features = geoJsonData['features'] ?? [];

      print('총 ${features.length}개의 Feature를 마이그레이션합니다.');

      // 4. 각 Feature를 Firestore에 저장
      for (int i = 0; i < features.length; i++) {
        await _saveFeatureToFirestore(features[i], collectionName);
        print('Progress: ${i + 1}/${features.length}');
      }

      print('마이그레이션이 완료되었습니다!');
    } catch (e) {
      print('마이그레이션 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  // GeoJSON 파일 읽기 (assets 또는 로컬 파일)
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

  // 개별 Feature를 Firestore에 저장
  Future<void> _saveFeatureToFirestore(
    Map<String, dynamic> feature,
    String collectionName,
  ) async {
    try {
      // properties와 geometry 추출
      Map<String, dynamic> properties = feature['properties'] ?? {};
      Map<String, dynamic> geometry = feature['geometry'] ?? {};

      // coordinates를 String으로 변환
      String coordinatesString = '';
      if (geometry['coordinates'] != null) {
        coordinatesString = json.encode(geometry['coordinates']);
      }

      // Firestore에 저장할 데이터 구성
      Map<String, dynamic> firestoreData = {
        // Feature 기본 정보
        'type': feature['type'] ?? 'Feature',

        // Properties 정보
        'adm_nm': properties['adm_nm'] ?? '',
        'adm_cd2': properties['adm_cd2'] ?? '',
        'sgg': properties['sgg'] ?? '',
        'sido': properties['sido'] ?? '',
        'sidonm': properties['sidonm'] ?? '',
        'sggnm': properties['sggnm'] ?? '',
        'adm_cd': properties['adm_cd'] ?? '',

        // Geometry 정보
        'geometry_type': geometry['type'] ?? '',
        'coordinates': coordinatesString, // String으로 저장

      };

      // Firestore에 문서 추가 (ID 자동 생성)
      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(firestoreData);

      // 생성된 문서 ID를 필드에도 추가
      await docRef.update({'document_id': docRef.id});

      print('저장 완료 - ID: ${docRef.id}, 지역: ${properties['adm_nm']}');
    } catch (e) {
      print('Feature 저장 중 오류: $e');
      rethrow;
    }
  }

  // 마이그레이션 상태 확인
  Future<void> checkMigrationStatus(String collectionName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .get();
      print('컬렉션 "$collectionName"에 ${snapshot.docs.length}개의 문서가 있습니다.');

      // 첫 번째 문서 샘플 출력
      if (snapshot.docs.isNotEmpty) {
        print('샘플 문서:');
        print(snapshot.docs.first.data());
      }
    } catch (e) {
      print('상태 확인 중 오류: $e');
    }
  }

  // 특정 조건으로 데이터 조회
  Future<List<Map<String, dynamic>>> queryByRegion({
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

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print('조회 중 오류: $e');
      return [];
    }
  }
}

// 사용 예제
class MigrationExample {
  final GeoJsonMigrator migrator = GeoJsonMigrator();

  // 마이그레이션 실행
  Future<void> runMigration() async {
    try {
      await migrator.migrateGeoJsonToFirestore(
        geoJsonFilePath: 'assets/GeoJSON/test_dong.geojson', // assets 파일 경로
        collectionName: 'dong_boundaries',
      );
    } catch (e) {
      print('마이그레이션 실패: $e');
    }
  }
}
