// lib/services/parkour_spot_search_service.dart

import 'package:drift/drift.dart';
import 'package:parkourspotkorea/database/app_database.dart';
import 'package:parkourspotkorea/model/parkour_spot.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkourSpotSearchService {
  final AppDatabase _database;
  
  ParkourSpotSearchService(this._database);
  
  Future<List<ParkourSpot>> searchSpots({
    String? query,
    String? category,
    double? minRating,
    String? difficulty,
    LatLng? userLocation,
    double? maxDistanceKm,
    int limit = 50,
  }) async {
    final entities = await _database.searchParkourSpots(
      query: query,
      category: category,
      minRating: minRating,
      difficulty: difficulty,
      userLat: userLocation?.latitude,
      userLng: userLocation?.longitude,
      maxDistanceKm: maxDistanceKm,
      limit: limit,
    );
    
    return entities.map(_entityToModel).toList();
  }
  
  Future<List<ParkourSpot>> getNearbySpots(
    LatLng userLocation, {
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    final entities = await _database.getNearbyParkourSpots(
      userLocation.latitude,
      userLocation.longitude,
      radiusKm: radiusKm,
      limit: limit,
    );
    
    return entities.map(_entityToModel).toList();
  }
  
  Future<List<String>> getPopularSearchTerms() async {
    return await _database.getPopularSearchTerms();
  }
  
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      return await getPopularSearchTerms();
    }
    
    // 기본적인 검색어 제안 (실제로는 더 복잡한 로직 필요)
    final lowerQuery = query.toLowerCase();
    final suggestions = <String>[];
    
    // 카테고리 제안
    const categories = ['parkour_spot', 'training_ground', 'gym', 'outdoor'];
    suggestions.addAll(
      categories.where((cat) => cat.contains(lowerQuery))
    );
    
    // 난이도 제안
    const difficulties = ['beginner', 'intermediate', 'advanced'];
    suggestions.addAll(
      difficulties.where((diff) => diff.contains(lowerQuery))
    );
    
    return suggestions.take(5).toList();
  }
  
  Future<void> addSpot(ParkourSpot spot) async {
    final companion = _modelToCompanion(spot);
    await _database.insertParkourSpot(companion);
    
    // 검색 인덱스 업데이트
    final searchTerms = _extractSearchTerms(spot);
    await _database.updateParkourSpotSearchIndices(spot.documentId, searchTerms);
  }
  
  ParkourSpot _entityToModel(ParkourSpotEntity entity) {
    return ParkourSpot(
      documentId: entity.id,
      name: entity.name,
      description: entity.description ?? '',
      address: entity.address ?? '',
      location: LatLng(entity.latitude, entity.longitude),
      category: entity.category,
      difficulty: entity.difficulty ?? 'intermediate',
      imageUrls: _parseStringList(entity.imageUrls),
      tags: _parseStringList(entity.tags),
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  
  ParkourSpotsCompanion _modelToCompanion(ParkourSpot spot) {
    return ParkourSpotsCompanion.insert(
      id: spot.documentId,
      name: spot.name,
      description: Value(spot.description.isEmpty ? null : spot.description),
      address: Value(spot.address.isEmpty ? null : spot.address),
      latitude: spot.location.latitude,
      longitude: spot.location.longitude,
      category: Value(spot.category),
      difficulty: Value(spot.difficulty.isEmpty ? null : spot.difficulty),
      imageUrls: Value(_stringListToJson(spot.imageUrls)),
      tags: Value(_stringListToJson(spot.tags)),
      rating: Value(spot.rating ?? 0.0),
      reviewCount: Value(spot.reviewCount ?? 0),
      isVerified: Value(spot.isVerified),
      createdAt: spot.createdAt ?? DateTime.now(),
      updatedAt: spot.updatedAt ?? DateTime.now(),
      lastSyncAt: Value(null),
    );
  }
  
  List<String> _extractSearchTerms(ParkourSpot spot) {
    final terms = <String>[];
    
    // 이름에서 추출
    terms.addAll(spot.name.toLowerCase().split(' '));
    
    // 주소에서 추출
    if (spot.address.isNotEmpty) {
      terms.addAll(spot.address.toLowerCase().split(' '));
    }
    
    // 설명에서 추출
    if (spot.description.isNotEmpty) {
      terms.addAll(spot.description.toLowerCase().split(' '));
    }
    
    // 태그 추가
    terms.addAll(spot.tags.map((tag) => tag.toLowerCase()));
    
    // 카테고리 추가
    terms.add(spot.category.toLowerCase());
    
    // 중복 제거 및 빈 문자열 제거
    return terms.where((term) => term.isNotEmpty).toSet().toList();
  }
  
  List<String> _parseStringList(String jsonString) {
    try {
      if (jsonString.isEmpty || jsonString == '[]') return [];
      // 간단한 JSON 배열 파싱 (실제로는 json.decode 사용 권장)
      final cleaned = jsonString.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
      if (cleaned.isEmpty) return [];
      return cleaned.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }
  
  String _stringListToJson(List<String> list) {
    if (list.isEmpty) return '[]';
    final quoted = list.map((s) => '"$s"').join(',');
    return '[$quoted]';
  }
}