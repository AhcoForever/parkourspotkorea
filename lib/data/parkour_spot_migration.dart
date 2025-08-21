import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

/// 파쿠르 스팟 JSON → Firestore 마이그레이션 서비스
class ParkourSpotMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'spot'; // 컬렉션명: spot

  /// 🚀 parkourSpot250711.json 파일을 Firestore로 마이그레이션
  Future<MigrationResult> migrateParkourSpots() async {
    try {
      print('📁 JSON 파일 선택 중...');

      // 1. 파일 선택
      final jsonContent = await _selectJsonFile();
      if (jsonContent == null) {
        return MigrationResult.error('파일이 선택되지 않았습니다.');
      }

      // 2. JSON 파싱
      final data = json.decode(jsonContent) as Map<String, dynamic>;
      print('📄 JSON 파일 파싱 완료');

      // 3. 파쿠르 스팟 추출 및 변환
      final spots = _extractParkourSpots(data);
      if (spots.isEmpty) {
        return MigrationResult.error('변환 가능한 파쿠르 스팟이 없습니다.');
      }

      // 4. Firestore에 배치 업로드
      final result = await _uploadToFirestore(spots);

      print('🎉 마이그레이션 완료!');
      return result;

    } catch (e) {
      print('❌ 마이그레이션 실패: $e');
      return MigrationResult.error('마이그레이션 실패: $e');
    }
  }

  /// 파일 선택 및 읽기
  Future<String?> _selectJsonFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;

      // 웹과 모바일 대응
      if (file.bytes != null) {
        return utf8.decode(file.bytes!);
      } else if (file.path != null) {
        return await File(file.path!).readAsString();
      }

      return null;
    } catch (e) {
      print('❌ 파일 읽기 실패: $e');
      return null;
    }
  }

  /// JSON에서 파쿠르 스팟 추출 및 변환
  List<Map<String, dynamic>> _extractParkourSpots(Map<String, dynamic> data) {
    try {
      final bookmarkList = data['bookmarkList'] as List<dynamic>? ?? [];
      List<Map<String, dynamic>> spots = [];

      print('📍 ${bookmarkList.length}개 북마크 발견');

      for (int i = 0; i < bookmarkList.length; i++) {
        final bookmark = bookmarkList[i] as Map<String, dynamic>;

        try {
          final spot = _convertToSpot(bookmark);
          if (spot != null) {
            spots.add(spot);
            print('✅ 변환 완료: ${spot['name']}');
          }
        } catch (e) {
          print('❌ 변환 실패: ${bookmark['name']} - $e');
        }
      }

      print('🔄 총 ${spots.length}개 스팟으로 변환 완료');
      return spots;

    } catch (e) {
      print('❌ 데이터 추출 실패: $e');
      return [];
    }
  }

  /// 개별 북마크를 파쿠르 스팟으로 변환 (필수 속성만)
  Map<String, dynamic>? _convertToSpot(Map<String, dynamic> bookmark) {
    try {
      // 필수 필드 검증
      final String? name = bookmark['name']?.toString().trim();
      if (name == null || name.isEmpty) return null;

      // 좌표 추출 (px = longitude, py = latitude)
      final double? longitude = _parseDouble(bookmark['px']);
      final double? latitude = _parseDouble(bookmark['py']);

      if (latitude == null || longitude == null) {
        print('⚠️ 좌표 없음: $name');
        return null;
      }

      // 한국 좌표 범위 검증
      if (latitude < 32.0 || latitude > 39.0 || longitude < 124.0 || longitude > 132.0) {
        print('⚠️ 좌표 범위 확인 필요: $name ($latitude, $longitude)');
      }

      // 🎯 지도 마커에 필요한 핵심 정보만 추출
      return {
        // === 기본 정보 (필수) ===
        'documentId': '', // 업로드 시 실제 문서 ID로 설정됨
        'name': name,
        'address': _cleanAddress(bookmark['address']?.toString() ?? ''),

        // === 위치 정보 (필수) ===
        'location': GeoPoint(latitude, longitude),
        'latitude': latitude,   // 추가적인 위도 필드 (쿼리 편의용)
        'longitude': longitude, // 추가적인 경도 필드 (쿼리 편의용)

        // === 카테고리 정보 ===
        'type': bookmark['type']?.toString() ?? 'place', // place, address
        'category': 'parkour', // 파쿠르 카테고리로 고정
        'subcategory': _getSubcategory(name, bookmark['address']?.toString() ?? ''),

        // === 네이버 지도 정보 (참조용) ===
        'bookmarkId': bookmark['bookmarkId']?.toString() ?? '',
        'sid': bookmark['sid']?.toString() ?? '', // 네이버 장소 ID

        // === 시간 정보 ===
        'createdAt': _convertTimestamp(bookmark['creationTime']),
        'updatedAt': _convertTimestamp(bookmark['lastUpdateTime']),

        // === 상태 정보 ===
        'isActive': true,
        'isIndoor': bookmark['isIndoor'] ?? false,
        'available': bookmark['available'] ?? true,

        // === 파쿠르 관련 태그 ===
        'tags': _generateTags(name, bookmark['address']?.toString() ?? ''),

        // === 메타데이터 ===
        'source': 'naver_parkour_spots',
        'uploadedAt': FieldValue.serverTimestamp(),
      };

    } catch (e) {
      print('❌ 스팟 변환 실패: ${bookmark['name']} - $e');
      return null;
    }
  }

  /// Firestore에 배치 업로드
  Future<MigrationResult> _uploadToFirestore(List<Map<String, dynamic>> spots) async {
    try {
      print('🔥 Firestore 업로드 시작...');

      int successCount = 0;
      int updateCount = 0;
      int errorCount = 0;
      List<String> errors = [];

      WriteBatch batch = _firestore.batch();
      int batchCount = 0;
      const int batchSize = 500;

      for (int i = 0; i < spots.length; i++) {
        final spot = spots[i];

        try {
          // 중복 확인 (bookmarkId 기준)
          final existingQuery = await _firestore
              .collection(_collection)
              .where('bookmarkId', isEqualTo: spot['bookmarkId'])
              .limit(1)
              .get();

          if (existingQuery.docs.isNotEmpty) {
            // 기존 문서 업데이트
            final docRef = existingQuery.docs.first.reference;
            final updatedSpot = Map<String, dynamic>.from(spot);
            updatedSpot['documentId'] = docRef.id;
            updatedSpot['updatedAt'] = FieldValue.serverTimestamp();

            batch.update(docRef, updatedSpot);
            updateCount++;
            print('🔄 업데이트: ${spot['name']}');
          } else {
            // 새 문서 생성 (자동 ID)
            final docRef = _firestore.collection(_collection).doc();
            final newSpot = Map<String, dynamic>.from(spot);
            newSpot['documentId'] = docRef.id; // 📝 문서 ID를 필드에 저장

            batch.set(docRef, newSpot);
            successCount++;
            print('✅ 신규 추가: ${spot['name']}');
          }

          batchCount++;

          // 배치 크기 제한
          if (batchCount >= batchSize) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
            print('📦 배치 업로드: ${i + 1}/${spots.length}');
          }

        } catch (e) {
          errorCount++;
          errors.add('${spot['name']}: $e');
          print('❌ 업로드 실패: ${spot['name']} - $e');
        }
      }

      // 남은 배치 커밋
      if (batchCount > 0) {
        await batch.commit();
      }

      return MigrationResult.success(
        totalCount: spots.length,
        successCount: successCount,
        updateCount: updateCount,
        errorCount: errorCount,
        errors: errors,
      );

    } catch (e) {
      print('❌ 배치 업로드 실패: $e');
      return MigrationResult.error('배치 업로드 실패: $e');
    }
  }

  // === 헬퍼 함수들 ===

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  DateTime? _convertTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  String _cleanAddress(String address) {
    return address
        .replaceAll('서울특별시', '서울')
        .replaceAll('부산광역시', '부산')
        .replaceAll('경기도', '경기')
        .replaceAll('  ', ' ')
        .trim();
  }

  String _getSubcategory(String name, String address) {
    final nameUpper = name.toUpperCase();
    final addressUpper = address.toUpperCase();

    if (nameUpper.contains('공원') || addressUpper.contains('공원')) return 'park';
    if (nameUpper.contains('학교') || addressUpper.contains('학교')) return 'school';
    if (nameUpper.contains('파쿠르') || nameUpper.contains('PARKOUR')) return 'parkour_gym';
    if (nameUpper.contains('체육관') || nameUpper.contains('GYM')) return 'gym';
    if (nameUpper.contains('광장') || nameUpper.contains('플라자')) return 'plaza';
    if (nameUpper.contains('다리') || nameUpper.contains('교')) return 'bridge';
    if (nameUpper.contains('계단')) return 'stairs';

    return 'general';
  }

  List<String> _generateTags(String name, String address) {
    List<String> tags = ['parkour', '파쿠르'];

    final nameUpper = name.toUpperCase();
    final addressUpper = address.toUpperCase();

    // 장소 유형별 태그
    if (nameUpper.contains('공원') || addressUpper.contains('공원')) {
      tags.addAll(['park', '공원', 'outdoor']);
    }
    if (nameUpper.contains('파쿠르') || nameUpper.contains('PARKOUR')) {
      tags.addAll(['training', '훈련', 'gym']);
    }
    if (nameUpper.contains('어린이')) {
      tags.addAll(['kids', '어린이', 'beginner']);
    }

    // 지역별 태그
    if (addressUpper.contains('서울')) tags.add('seoul');
    if (addressUpper.contains('부산')) tags.add('busan');
    if (addressUpper.contains('경기')) tags.add('gyeonggi');
    if (addressUpper.contains('강남')) tags.add('gangnam');
    if (addressUpper.contains('송파')) tags.add('songpa');

    return tags.toSet().toList(); // 중복 제거
  }

  /// 업로드된 스팟 조회
  Stream<QuerySnapshot> getUploadedSpots() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }

  /// 특정 스팟 조회
  Future<DocumentSnapshot?> getSpotById(String documentId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(documentId).get();
      return doc.exists ? doc : null;
    } catch (e) {
      print('❌ 스팟 조회 실패: $e');
      return null;
    }
  }

  /// 모든 데이터 삭제 (초기화)
  Future<void> clearAllSpots() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      WriteBatch batch = _firestore.batch();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('🗑️ 모든 스팟 삭제 완료');
    } catch (e) {
      print('❌ 데이터 삭제 실패: $e');
      rethrow;
    }
  }
}

/// 마이그레이션 결과 클래스
class MigrationResult {
  final bool success;
  final int totalCount;
  final int successCount;
  final int updateCount;
  final int errorCount;
  final List<String> errors;
  final String? errorMessage;

  MigrationResult.success({
    required this.totalCount,
    required this.successCount,
    required this.updateCount,
    required this.errorCount,
    required this.errors,
  }) : success = true, errorMessage = null;

  MigrationResult.error(this.errorMessage)
      : success = false,
        totalCount = 0,
        successCount = 0,
        updateCount = 0,
        errorCount = 0,
        errors = [];

  String get summary {
    if (!success) return '❌ $errorMessage';

    String result = '✅ 파쿠르 스팟 마이그레이션 완료!\n';
    result += '📊 총 $totalCount개 처리\n';
    result += '✅ 신규 추가: $successCount개\n';
    result += '🔄 기존 업데이트: $updateCount개\n';

    if (errorCount > 0) {
      result += '❌ 실패: $errorCount개\n';
    }

    return result;
  }
}