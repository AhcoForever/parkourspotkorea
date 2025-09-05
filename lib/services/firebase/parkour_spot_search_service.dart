// lib/services/firebase/parkour_spot_search_service.dart

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkourspotkorea/model/parkour_spot.dart';

class FirebaseParkourSpotSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'spot';
  
  /// 텍스트 기반 검색 (이름, 주소, 설명 필드에서 검색)
  Future<List<ParkourSpot>> searchSpots({
    String? query,
    String? category,
    double? minRating,
    String? difficulty,
    LatLng? userLocation,
    double? maxDistanceKm,
    int limit = 50,
  }) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _firestore.collection(_collection);
      
      // 활성화된 스팟만
      firestoreQuery = firestoreQuery.where('isActive', isEqualTo: true);
      firestoreQuery = firestoreQuery.where('available', isEqualTo: true);
      
      // 카테고리 필터 (subcategory 기준)
      if (category != null && category.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('subcategory', isEqualTo: category);
      }
      
      // 실내/실외 필터
      if (difficulty == 'indoor') {
        firestoreQuery = firestoreQuery.where('isIndoor', isEqualTo: true);
      } else if (difficulty == 'outdoor') {
        firestoreQuery = firestoreQuery.where('isIndoor', isEqualTo: false);
      }
      
      firestoreQuery = firestoreQuery.limit(limit);
      
      final querySnapshot = await firestoreQuery.get();
      List<ParkourSpot> spots = querySnapshot.docs
          .map((doc) => _documentToParkourSpot(doc))
          .toList();
      
      // 텍스트 검색 (클라이언트 사이드에서 필터링)
      if (query != null && query.isNotEmpty) {
        final searchTerms = query.toLowerCase().split(' ');
        spots = spots.where((spot) {
          final searchableText = '${spot.name} ${spot.address} ${spot.description} ${spot.tags.join(' ')}'.toLowerCase();
          return searchTerms.every((term) => searchableText.contains(term));
        }).toList();
      }
      
      // 거리 기반 필터링
      if (userLocation != null && maxDistanceKm != null) {
        spots = spots.where((spot) {
          final distance = _calculateDistance(
            userLocation.latitude, userLocation.longitude,
            spot.location.latitude, spot.location.longitude,
          );
          return distance <= maxDistanceKm;
        }).toList();
        
        // 거리순 정렬
        spots.sort((a, b) {
          final distA = _calculateDistance(
            userLocation.latitude, userLocation.longitude,
            a.location.latitude, a.location.longitude,
          );
          final distB = _calculateDistance(
            userLocation.latitude, userLocation.longitude,
            b.location.latitude, b.location.longitude,
          );
          return distA.compareTo(distB);
        });
      }
      
      return spots;
    } catch (e) {
      print('Firestore 검색 실패: $e');
      return [];
    }
  }
  
  /// 주변 스팟 검색 (GeoHash 기반)
  Future<List<ParkourSpot>> getNearbySpots(
    LatLng userLocation, {
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    try {
      // 간단한 bounding box 계산
      final bounds = _calculateBoundingBox(userLocation, radiusKm);
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('latitude', isGreaterThanOrEqualTo: bounds['minLat'])
          .where('latitude', isLessThanOrEqualTo: bounds['maxLat'])
          .limit(limit * 2) // 여분으로 더 가져와서 경도 필터링
          .get();
      
      List<ParkourSpot> spots = querySnapshot.docs
          .map((doc) => _documentToParkourSpot(doc))
          .where((spot) {
            // 경도 필터링
            return spot.location.longitude >= bounds['minLng']! && 
                   spot.location.longitude <= bounds['maxLng']!;
          })
          .where((spot) {
            // 정확한 거리 계산
            final distance = _calculateDistance(
              userLocation.latitude, userLocation.longitude,
              spot.location.latitude, spot.location.longitude,
            );
            return distance <= radiusKm;
          })
          .toList();
      
      // 거리순 정렬
      spots.sort((a, b) {
        final distA = _calculateDistance(
          userLocation.latitude, userLocation.longitude,
          a.location.latitude, a.location.longitude,
        );
        final distB = _calculateDistance(
          userLocation.latitude, userLocation.longitude,
          b.location.latitude, b.location.longitude,
        );
        return distA.compareTo(distB);
      });
      
      return spots.take(limit).toList();
    } catch (e) {
      print('주변 스팟 검색 실패: $e');
      return [];
    }
  }
  
  /// 카테고리별 스팟 가져오기
  Future<List<ParkourSpot>> getSpotsByCategory(String category, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('subcategory', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .where('available', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => _documentToParkourSpot(doc))
          .toList();
    } catch (e) {
      print('카테고리별 검색 실패: $e');
      return [];
    }
  }
  
  /// 인기 검색어 (태그 기반)
  Future<List<String>> getPopularSearchTerms() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('available', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();
      
      final Set<String> popularTerms = {};
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        
        // tags 배열에서 추출
        if (data['tags'] is List) {
          final tags = (data['tags'] as List).map((tag) => tag.toString()).toList();
          popularTerms.addAll(tags);
        }
        
        // 이름에서 키워드 추출
        final name = data['name']?.toString() ?? '';
        final nameWords = name.split(' ');
        popularTerms.addAll(nameWords.where((word) => word.length > 1));
      }
      
      return popularTerms.take(10).toList();
    } catch (e) {
      print('인기 검색어 가져오기 실패: $e');
      return ['파쿠르', '공원', '체육관', '훈련장', '야외'];
    }
  }
  
  /// 검색어 제안
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      return await getPopularSearchTerms();
    }
    
    try {
      final lowerQuery = query.toLowerCase();
      
      // 카테고리 제안 (실제 Firestore subcategory 기준)
      const categories = {
        'park': '공원',
        'gym': '체육관',
        'university': '대학교',
        'playground': '놀이터',
        'sports_facility': '체육시설',
      };
      
      final suggestions = <String>[];
      
      // 카테고리 매칭
      for (final entry in categories.entries) {
        if (entry.key.contains(lowerQuery) || entry.value.contains(lowerQuery)) {
          suggestions.add(entry.value);
        }
      }
      
      // 실내/실외 제안
      const environments = {
        'indoor': '실내',
        'outdoor': '실외',
      };
      
      for (final entry in environments.entries) {
        if (entry.key.contains(lowerQuery) || entry.value.contains(lowerQuery)) {
          suggestions.add(entry.value);
        }
      }
      
      // 일반적인 검색어
      final commonTerms = ['공원', '대학교', '체육관', '한강', '서울숲', '언더커버'];
      suggestions.addAll(
        commonTerms.where((term) => term.contains(query))
      );
      
      return suggestions.take(5).toList();
    } catch (e) {
      print('검색 제안 실패: $e');
      return [];
    }
  }
  
  /// 거리 계산 (Haversine formula)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * 
        math.sin(dLng / 2) * math.sin(dLng / 2);
    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }
  
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
  
  /// Bounding box 계산
  Map<String, double> _calculateBoundingBox(LatLng center, double radiusKm) {
    const double kmPerDegree = 111.32; // 대략적인 값
    final double deltaLat = radiusKm / kmPerDegree;
    final double deltaLng = radiusKm / (kmPerDegree * math.cos(_toRadians(center.latitude)));
    
    return {
      'minLat': center.latitude - deltaLat,
      'maxLat': center.latitude + deltaLat,
      'minLng': center.longitude - deltaLng,
      'maxLng': center.longitude + deltaLng,
    };
  }
  
  /// Firestore 문서를 ParkourSpot 모델로 변환
  ParkourSpot _documentToParkourSpot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    
    // tags 배열 처리
    List<String> tags = [];
    if (data['tags'] is List) {
      tags = (data['tags'] as List).map((tag) => tag.toString()).toList();
    }
    
    // GeoPoint 또는 개별 lat/lng 처리
    LatLng location;
    if (data['location'] is GeoPoint) {
      final geoPoint = data['location'] as GeoPoint;
      location = LatLng(geoPoint.latitude, geoPoint.longitude);
    } else {
      final lat = data['latitude'] as double? ?? 37.5665;
      final lng = data['longitude'] as double? ?? 126.9780;
      location = LatLng(lat, lng);
    }
    
    // Timestamp를 DateTime으로 변환
    DateTime? createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    }
    
    DateTime? updatedAt;
    if (data['updatedAt'] is Timestamp) {
      updatedAt = (data['updatedAt'] as Timestamp).toDate();
    }
    
    return ParkourSpot(
      documentId: doc.id,
      name: data['name']?.toString() ?? '',
      displayName: data['name']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      description: '', // Firestore 스키마에 description 없음
      location: location,
      category: data['subcategory']?.toString() ?? 'park',
      difficulty: data['isIndoor'] == true ? 'indoor' : 'outdoor',
      imageUrls: [], // 현재 스키마에 이미지 URL 없음
      tags: tags,
      rating: null, // 현재 스키마에 rating 없음
      reviewCount: null, // 현재 스키마에 reviewCount 없음
      isVerified: data['isActive'] == true && data['available'] == true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}