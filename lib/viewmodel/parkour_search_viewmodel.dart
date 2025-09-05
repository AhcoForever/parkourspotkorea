// lib/viewmodel/parkour_search_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkourspotkorea/model/parkour_spot.dart';
import 'package:parkourspotkorea/services/firebase/parkour_spot_search_service.dart';
import 'package:geolocator/geolocator.dart';

class ParkourSearchViewModel extends ChangeNotifier {
  final FirebaseParkourSpotSearchService _searchService;
  
  ParkourSearchViewModel(this._searchService);
  
  // 검색 결과
  List<ParkourSpot> _searchResults = [];
  List<ParkourSpot> get searchResults => _searchResults;
  
  // 검색 상태
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  
  // 에러 상태
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  // 검색 필터
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;
  
  double? _minRating;
  double? get minRating => _minRating;
  
  String? _selectedDifficulty;
  String? get selectedDifficulty => _selectedDifficulty;
  
  double _maxDistance = 10.0; // km
  double get maxDistance => _maxDistance;
  
  // 사용자 위치
  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;
  
  // 검색어 제안
  List<String> _searchSuggestions = [];
  List<String> get searchSuggestions => _searchSuggestions;
  
  // 인기 검색어
  List<String> _popularTerms = [];
  List<String> get popularTerms => _popularTerms;
  
  Future<void> initializeSearch() async {
    await _getUserLocation();
    await _loadPopularTerms();
    await searchNearbySpots();
  }
  
  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.always || 
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        _userLocation = LatLng(position.latitude, position.longitude);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('위치 가져오기 실패: $e');
    }
  }
  
  Future<void> _loadPopularTerms() async {
    try {
      _popularTerms = await _searchService.getPopularSearchTerms();
      notifyListeners();
    } catch (e) {
      debugPrint('인기 검색어 로딩 실패: $e');
    }
  }
  
  Future<void> searchSpots({bool showLoading = true}) async {
    if (showLoading) {
      _isSearching = true;
      _errorMessage = null;
      notifyListeners();
    }
    
    try {
      _searchResults = await _searchService.searchSpots(
        query: _searchQuery.isEmpty ? null : _searchQuery,
        category: _selectedCategory,
        minRating: _minRating,
        difficulty: _selectedDifficulty,
        userLocation: _userLocation,
        maxDistanceKm: _maxDistance,
        limit: 50,
      );
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '검색 중 오류가 발생했습니다: $e';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
  
  Future<void> searchNearbySpots() async {
    if (_userLocation == null) return;
    
    _isSearching = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _searchResults = await _searchService.getNearbySpots(
        _userLocation!,
        radiusKm: _maxDistance,
        limit: 20,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '주변 검색 중 오류가 발생했습니다: $e';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _updateSearchSuggestions();
    notifyListeners();
  }
  
  void setCategory(String? category) {
    _selectedCategory = category;
    searchSpots();
  }
  
  void setMinRating(double? rating) {
    _minRating = rating;
    searchSpots();
  }
  
  void setDifficulty(String? difficulty) {
    _selectedDifficulty = difficulty;
    searchSpots();
  }
  
  void setMaxDistance(double distance) {
    _maxDistance = distance;
    searchSpots();
  }
  
  void clearFilters() {
    _selectedCategory = null;
    _minRating = null;
    _selectedDifficulty = null;
    _maxDistance = 10.0;
    searchSpots();
  }
  
  Future<void> _updateSearchSuggestions() async {
    try {
      _searchSuggestions = await _searchService.getSearchSuggestions(_searchQuery);
      notifyListeners();
    } catch (e) {
      debugPrint('검색 제안 업데이트 실패: $e');
    }
  }
  
  void selectSearchSuggestion(String suggestion) {
    _searchQuery = suggestion;
    _searchSuggestions.clear();
    searchSpots();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _searchSuggestions.clear();
    searchNearbySpots();
  }
  
  // 카테고리 옵션
  static const List<String> categories = [
    'parkour_spot',
    'training_ground', 
    'gym',
    'outdoor',
  ];
  
  static const Map<String, String> categoryLabels = {
    'parkour_spot': '파쿠르 스팟',
    'training_ground': '훈련장',
    'gym': '체육관',
    'outdoor': '야외',
  };
  
  // 난이도 옵션
  static const List<String> difficulties = [
    'beginner',
    'intermediate',
    'advanced',
  ];
  
  static const Map<String, String> difficultyLabels = {
    'beginner': '초급',
    'intermediate': '중급',
    'advanced': '고급',
  };
  
  String getCategoryLabel(String category) {
    return categoryLabels[category] ?? category;
  }
  
  String getDifficultyLabel(String difficulty) {
    return difficultyLabels[difficulty] ?? difficulty;
  }
}