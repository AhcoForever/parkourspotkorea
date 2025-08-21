// lib/services/firebase/firebase_parkour_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../interfaces/parkour_spot_interface.dart';


class FirebaseParkourService implements IParkourSpotService {
  static const String _collection = 'parkour_spots';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> fetchSpotsBySido(int sido) async {
    try {
      print('🔍 Firestore에서 파쿠르 장소 조회 시작 (sido: $sido)');

      // sido에 해당하는 위도/경도 범위 계산
      final bounds = _getSidoBounds(sido);

      final query = _firestore
          .collection(_collection)
          .where('latitude', isGreaterThanOrEqualTo: bounds['south'])
          .where('latitude', isLessThanOrEqualTo: bounds['north'])
          .where('longitude', isGreaterThanOrEqualTo: bounds['west'])
          .where('longitude', isLessThanOrEqualTo: bounds['east']);

      final snapshot = await query.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ Firestore 파쿠르 장소 조회 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ Firestore 파쿠르 장소 조회 실패: $e');
      throw Exception('Firestore 파쿠르 장소 조회 실패: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSpotsInBounds(
      LatLng southwest, LatLng northeast) async {
    try {
      print('🔍 영역 내 파쿠르 장소 조회: ${southwest.latitude},${southwest.longitude} ~ ${northeast.latitude},${northeast.longitude}');

      final query = _firestore
          .collection(_collection)
          .where('latitude', isGreaterThanOrEqualTo: southwest.latitude)
          .where('latitude', isLessThanOrEqualTo: northeast.latitude)
          .where('longitude', isGreaterThanOrEqualTo: southwest.longitude)
          .where('longitude', isLessThanOrEqualTo: northeast.longitude);

      final snapshot = await query.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ 영역 내 파쿠르 장소 조회 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ 영역 내 파쿠르 장소 조회 실패: $e');
      throw Exception('영역 내 파쿠르 장소 조회 실패: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchSpotById(String id) async {
    try {
      print('🔍 파쿠르 장소 상세 조회: $id');

      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        print('⚠️ 파쿠르 장소를 찾을 수 없음: $id');
        return null;
      }

      final data = doc.data()!;
      return {
        'id': doc.id,
        ...data,
      };
    } catch (e) {
      print('❌ 파쿠르 장소 상세 조회 실패: $e');
      throw Exception('파쿠르 장소 상세 조회 실패: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchSpotsRemote(String query, {int limit = 20}) async {
    try {
      print('🔍 원격 파쿠르 장소 검색: "$query"');

      // Firestore의 제한적인 텍스트 검색 (전체 텍스트 검색 불가)
      // 이름으로만 검색 (시작 문자열 매칭)
      final queryLower = query.toLowerCase();

      final nameQuery = _firestore
          .collection(_collection)
          .where('searchKeywords', arrayContainsAny: [queryLower])
          .limit(limit);

      final snapshot = await nameQuery.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ 원격 파쿠르 장소 검색 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ 원격 파쿠르 장소 검색 실패: $e');
      throw Exception('원격 파쿠르 장소 검색 실패: $e');
    }
  }

  /// 전체 파쿠르 장소 조회 (첫 실행시)
  Future<List<Map<String, dynamic>>> fetchAllSpots({int limit = 1000}) async {
    try {
      print('🔍 전체 파쿠르 장소 조회 시작');

      final query = _firestore
          .collection(_collection)
          .orderBy('updatedAt', descending: true)
          .limit(limit);

      final snapshot = await query.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ 전체 파쿠르 장소 조회 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ 전체 파쿠르 장소 조회 실패: $e');
      throw Exception('전체 파쿠르 장소 조회 실패: $e');
    }
  }

  /// 카테고리별 파쿠르 장소 조회
  Future<List<Map<String, dynamic>>> fetchSpotsByCategory(String category, {int limit = 100}) async {
    try {
      print('🔍 카테고리별 파쿠르 장소 조회: $category');

      final query = _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .limit(limit);

      final snapshot = await query.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ 카테고리별 파쿠르 장소 조회 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ 카테고리별 파쿠르 장소 조회 실패: $e');
      throw Exception('카테고리별 파쿠르 장소 조회 실패: $e');
    }
  }

  /// 인기 파쿠르 장소 조회 (평점 기준)
  Future<List<Map<String, dynamic>>> fetchPopularSpots({int limit = 50}) async {
    try {
      print('🔍 인기 파쿠르 장소 조회');

      final query = _firestore
          .collection(_collection)
          .where('isVerified', isEqualTo: true)
          .orderBy('rating', descending: true)
          .orderBy('reviewCount', descending: true)
          .limit(limit);

      final snapshot = await query.get();

      final spots = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      print('✅ 인기 파쿠르 장소 조회 완료: ${spots.length}개');
      return spots;
    } catch (e) {
      print('❌ 인기 파쿠르 장소 조회 실패: $e');
      throw Exception('인기 파쿠르 장소 조회 실패: $e');
    }
  }

  /// 새로운 파쿠르 장소 추가
  Future<String> addSpot(Map<String, dynamic> spotData) async {
    try {
      print('📝 새 파쿠르 장소 추가');

      // 검색 키워드 자동 생성
      final searchKeywords = _generateSearchKeywords(spotData);

      final docRef = await _firestore.collection(_collection).add({
        ...spotData,
        'searchKeywords': searchKeywords,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ 파쿠르 장소 추가 완료: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ 파쿠르 장소 추가 실패: $e');
      throw Exception('파쿠르 장소 추가 실패: $e');
    }
  }

  /// 파쿠르 장소 업데이트
  Future<void> updateSpot(String id, Map<String, dynamic> updates) async {
    try {
      print('📝 파쿠르 장소 업데이트: $id');

      await _firestore.collection(_collection).doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ 파쿠르 장소 업데이트 완료: $id');
    } catch (e) {
      print('❌ 파쿠르 장소 업데이트 실패: $e');
      throw Exception('파쿠르 장소 업데이트 실패: $e');
    }
  }

  // === Private Methods ===

  /// sido에 해당하는 대략적인 위도/경도 범위 반환
  Map<String, double> _getSidoBounds(int sido) {
    // 각 sido별 대략적인 경계 좌표
    const sidoBounds = {
      11: {'south': 37.4, 'north': 37.7, 'west': 126.7, 'east': 127.2}, // 서울
      26: {'south': 35.0, 'north': 35.4, 'west': 128.9, 'east': 129.3}, // 부산
      27: {'south': 35.7, 'north': 36.0, 'west': 128.4, 'east': 128.8}, // 대구
      28: {'south': 37.2, 'north': 37.6, 'west': 126.4, 'east': 126.9}, // 인천
      29: {'south': 35.0, 'north': 35.3, 'west': 126.7, 'east': 127.1}, // 광주
      30: {'south': 36.2, 'north': 36.5, 'west': 127.2, 'east': 127.6}, // 대전
      31: {'south': 35.4, 'north': 35.7, 'west': 129.1, 'east': 129.5}, // 울산
      36: {'south': 36.4, 'north': 36.6, 'west': 127.1, 'east': 127.4}, // 세종
      41: {'south': 36.8, 'north': 38.3, 'west': 126.3, 'east': 127.9}, // 경기
      42: {'south': 37.0, 'north': 38.6, 'west': 127.0, 'east': 129.4}, // 강원
      43: {'south': 36.2, 'north': 37.2, 'west': 127.4, 'east': 129.0}, // 충북
      44: {'south': 35.9, 'north': 37.0, 'west': 125.4, 'east': 127.8}, // 충남
      45: {'south': 35.6, 'north': 36.3, 'west': 126.4, 'east': 127.7}, // 전북
      46: {'south': 33.8, 'north': 35.4, 'west': 124.6, 'east': 127.4}, // 전남
      47: {'south': 35.4, 'north': 37.5, 'west': 128.0, 'east': 130.9}, // 경북
      48: {'south': 34.4, 'north': 36.0, 'west': 127.4, 'east': 129.9}, // 경남
      50: {'south': 33.1, 'north': 33.6, 'west': 126.1, 'east': 126.9}, // 제주
    };

    return sidoBounds[sido] ?? sidoBounds[11]!; // 기본값: 서울
  }

  /// 검색용 키워드 생성
  List<String> _generateSearchKeywords(Map<String, dynamic> spotData) {
    final keywords = <String>{};

    // 이름에서 키워드 추출
    final name = spotData['name'] as String? ?? '';
    keywords.addAll(_extractKeywords(name));

    // 주소에서 키워드 추출
    final address = spotData['address'] as String? ?? '';
    keywords.addAll(_extractKeywords(address));

    // 태그 추가
    final tags = spotData['tags'] as List? ?? [];
    for (final tag in tags) {
      keywords.addAll(_extractKeywords(tag.toString()));
    }

    // 카테고리 추가
    final category = spotData['category'] as String? ?? '';
    keywords.addAll(_extractKeywords(category));

    // 설명에서 키워드 추출
    final description = spotData['description'] as String? ?? '';
    keywords.addAll(_extractKeywords(description));

    return keywords.toList();
  }

  /// 텍스트에서 검색 키워드 추출
  Set<String> _extractKeywords(String text) {
    final keywords = <String>{};
    final cleaned = text.toLowerCase().trim();

    // 공백으로 분리된 단어들
    final words = cleaned.split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.length >= 2) {
        keywords.add(word);

        // 초성 검색을 위한 부분 문자열 (한글의 경우)
        for (int i = 1; i <= word.length; i++) {
          keywords.add(word.substring(0, i));
        }
      }
    }

    return keywords;
  }
}