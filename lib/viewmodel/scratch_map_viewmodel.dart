// lib/viewmodel/scratch_map_viewmodel.dart 업데이트

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../interfaces/parkour_spot_interface.dart';
import '../interfaces/scratch_map_interface.dart';
import '../model/parkour_spot.dart';
import '../model/scratch_map_state.dart';
import '../database/app_database.dart';
import '../services/firebase/firebase_service.dart';

class ScratchMapViewModel extends ChangeNotifier {
  final IScratchMapRepository _scratchMapRepository;
  final IUserRepository _userRepository;
  final ILocationRepository _locationRepository;
  final IParkourSpotRepository _parkourSpotRepository;

  // 위치 추적 관련
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _lastHexagonId;

  // 파쿠르 장소 관련
  Set<Marker> _parkourMarkers = {};
  bool _showParkourSpots = true;
  int? _currentSido;

  ScratchMapViewModel({
    required IScratchMapRepository scratchMapRepository,
    required IUserRepository userRepository,
    required ILocationRepository locationRepository,
    required IParkourSpotRepository parkourSpotRepository, // 추가
  })  : _scratchMapRepository = scratchMapRepository,
        _userRepository = userRepository,
        _locationRepository = locationRepository,
        _parkourSpotRepository = parkourSpotRepository;

  // 현재 상태
  ScratchMapState _state = ScratchMapState.initial();
  ScratchMapState get state => _state;

  // Getters
  bool get isLoading => _state.isLoading;
  bool get isHexagonVisible => _state.isHexagonVisible;
  Set<Polygon> get allPolygons => _state.allPolygons;
  Set<Marker> get parkourMarkers => _parkourMarkers;
  bool get showParkourSpots => _showParkourSpots;
  LatLng? get cameraPosition => _state.cameraPosition;
  String? get errorMessage => _state.errorMessage;

  // 모든 마커 반환 (파쿠르 장소 + 기타)
  Set<Marker> get allMarkers {
    Set<Marker> markers = {};
    if (_showParkourSpots) {
      markers.addAll(_parkourMarkers);
    }
    return markers;
  }

  /// 초기화
  Future<void> initialize() async {
    _updateState(_state.copyWithLoading(true));

    try {
      // 1. 초기 카메라 위치 설정
      final initialPosition = await _userRepository.getInitialCameraPosition();
      _updateState(_state.copyWith(cameraPosition: initialPosition));

      // 2. sido 코드 계산
      final sido = await _locationRepository.resolveSidoCode(initialPosition);
      _currentSido = sido;

      // 3. 폴리곤 로드
      await _loadPolygonsForSido(sido);

      // 4. 파쿠르 장소 로드
      await _loadParkourSpots(sido);

      // 5. 방문한 헥사곤 복원
      await _loadVisitedHexagons();

      _updateState(_state.copyWithLoading(false));
      print('✅ ScratchMap 초기화 완료');
    } catch (e) {
      _updateState(_state.copyWithError('초기화 실패: $e'));
      print('❌ 초기화 실패: $e');
    }
  }

  /// sido별 폴리곤 로드 (기존 코드 유지)
  Future<void> _loadPolygonsForSido(int sido) async {
    try {
      final localRows = await _scratchMapRepository.getPolygonsBySido(sido);
      if (localRows.isNotEmpty) {
        final localPolygons = _scratchMapRepository.convertRowsToPolygons(localRows);
        _updateState(_state.copyWith(polygons: localPolygons));
        print('✅ 로컬 폴리곤 로드 완료: ${localPolygons.length}개');
      }

      final remotePolygons = await _scratchMapRepository.fetchAndCachePolygons(sido);
      _updateState(_state.copyWith(polygons: remotePolygons));
      print('✅ 원격 폴리곤 로드 완료: ${remotePolygons.length}개');
    } catch (e) {
      print('❌ 폴리곤 로드 실패: $e');
    }
  }

  /// 파쿠르 장소 로드
  Future<void> _loadParkourSpots(int sido) async {
    try {
      // 1. 캐시된 데이터 먼저 로드
      final cachedSpots = await _parkourSpotRepository.getCachedSpots();
      if (cachedSpots.isNotEmpty) {
        _parkourMarkers = _parkourSpotRepository.convertSpotsToMarkers(
          cachedSpots,
          onTap: _onParkourSpotTap,
        );
        notifyListeners();
        print('✅ 캐시된 파쿠르 장소 로드 완료: ${cachedSpots.length}개');
      }

      // 2. 백그라운드에서 최신 데이터 동기화
      await _parkourSpotRepository.syncSpotsFromFirestore(sido: sido);

      // 3. 동기화 후 다시 로드
      final updatedSpots = await _parkourSpotRepository.getCachedSpots();
      _parkourMarkers = _parkourSpotRepository.convertSpotsToMarkers(
        updatedSpots,
        onTap: _onParkourSpotTap,
      );
      notifyListeners();
      print('✅ 파쿠르 장소 동기화 완료: ${updatedSpots.length}개');
    } catch (e) {
      print('❌ 파쿠르 장소 로드 실패: $e');
    }
  }

  /// 파쿠르 장소 마커 클릭 처리
  void _onParkourSpotTap(ParkourSpot spot) {
    // TODO: 파쿠르 장소 상세 페이지로 이동하거나 바텀시트 표시
    print('파쿠르 장소 클릭: ${spot.name}');
  }

  /// 파쿠르 장소 표시 토글
  void toggleParkourSpots() {
    _showParkourSpots = !_showParkourSpots;
    notifyListeners();
    print('🔄 파쿠르 장소 표시: $_showParkourSpots');
  }

  /// 파쿠르 장소 검색
  Future<List<ParkourSpot>> searchParkourSpots(String query) async {
    try {
      final userLocation = _state.cameraPosition;
      final results = await _parkourSpotRepository.searchSpots(
        query,
        userLocation: userLocation,
      );
      print('🔍 파쿠르 장소 검색 결과: ${results.length}개');
      return results;
    } catch (e) {
      print('❌ 파쿠르 장소 검색 실패: $e');
      return [];
    }
  }

  /// 카메라 이동 시 주변 파쿠르 장소 로드
  Future<void> onCameraMove(CameraPosition position) async {
    try {
      // sido 변경 감지
      final newSido = await _locationRepository.resolveSidoCode(position.target);
      if (newSido != _currentSido) {
        _currentSido = newSido;
        await _loadParkourSpots(newSido);
        await _loadPolygonsForSido(newSido);
      }
    } catch (e) {
      print('❌ 카메라 이동 처리 실패: $e');
    }
  }

  /// 현재 위치로 이동 (기존 코드 유지)
  Future<LatLng?> moveToCurrentLocation() async {
    try {
      final position = await _locationRepository.getCurrentPosition();
      if (position != null) {
        final latLng = LatLng(position.latitude, position.longitude);
        _updateState(_state.copyWith(cameraPosition: latLng));

        // 새 위치의 파쿠르 장소도 로드
        final sido = await _locationRepository.resolveSidoCode(latLng);
        if (sido != _currentSido) {
          _currentSido = sido;
          await _loadParkourSpots(sido);
        }

        print('✅ 현재 위치로 이동: ${latLng.latitude}, ${latLng.longitude}');
        return latLng;
      }
      throw Exception('위치를 가져올 수 없습니다');
    } catch (e) {
      _updateState(_state.copyWithError('위치 이동 실패: $e'));
      print('❌ 위치 이동 실패: $e');
      return null;
    }
  }

  /// 헥사곤 토글 (기존 코드 유지)
  Future<void> toggleHexagons() async {
    try {
      if (_state.isHexagonVisible) {
        _stopLocationTracking();
        _updateState(_state.copyWith(isHexagonVisible: false));
        print('🔄 헥사곤 숨김 & 위치 추적 중지');
        return;
      }

      if (!_state.visitedLoaded) {
        await _loadVisitedHexagons();
      }

      await _showHexagonAtCurrentLocation();
      _startLocationTracking();
      _updateState(_state.copyWith(isHexagonVisible: true));
      print('🔄 헥사곤 표시 & 위치 추적 시작');
    } catch (e) {
      _updateState(_state.copyWithError('헥사곤 토글 실패: $e'));
      print('❌ 헥사곤 토글 실패: $e');
    }
  }

  // === 기존 메소드들 유지 ===
  Future<void> _showHexagonAtCurrentLocation() async {
    try {
      final position = await _locationRepository.getCurrentPosition();
      if (position == null) return;

      final current = LatLng(position.latitude, position.longitude);
      await _createHexagonAtPosition(current);
      _updateState(_state.copyWith(cameraPosition: current));
    } catch (e) {
      print('❌ 헥사곤 표시 실패: $e');
    }
  }

  Future<void> _loadVisitedHexagons() async {
    try {
      final uid = await _userRepository.getCurrentUserId();
      if (uid == null) return;

      final visitedHexIds = await _userRepository.getVisitedRegions(uid);
      if (visitedHexIds.isEmpty) {
        _updateState(_state.copyWith(visitedLoaded: true));
        return;
      }

      final hexagons = await _locationRepository.restoreVisitedHexagons(visitedHexIds);

      _updateState(_state.copyWith(
        hexagonPolygons: hexagons,
        visitedLoaded: true,
      ));

      print("✅ 방문한 헥사곤 복원 완료 (${visitedHexIds.length}개)");
    } catch (e) {
      print('❌ 방문 헥사곤 로드 실패: $e');
    }
  }

  void _startLocationTracking() {
    _stopLocationTracking();

    _positionStreamSubscription = _locationRepository.getPositionStream().listen(
          (Position position) {
        _handleLocationUpdate(position);
      },
      onError: (error) {
        print('❌ 위치 추적 오류: $error');
      },
    );

    print('📍 실시간 위치 추적 시작됨');
  }

  void _stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    print('🛑 실시간 위치 추적 중지됨');
  }

  Future<void> _handleLocationUpdate(Position position) async {
    if (!_state.isHexagonVisible) return;

    try {
      final current = LatLng(position.latitude, position.longitude);
      final currentHexId = await _locationRepository.generateHexId(current);

      if (_lastHexagonId == currentHexId) return;

      if (_state.hexagons.any((p) => p.polygonId.value == currentHexId)) {
        _lastHexagonId = currentHexId;
        return;
      }

      await _createHexagonAtPosition(current);
      _lastHexagonId = currentHexId;

      print('🆕 새로운 헥사곤 자동 생성: $currentHexId');
    } catch (e) {
      print('❌ 위치 업데이트 처리 실패: $e');
    }
  }

  Future<void> _createHexagonAtPosition(LatLng position) async {
    try {
      final uid = await _userRepository.getCurrentUserId();
      if (uid == null) return;

      final polygon = await _locationRepository.createHexagonAtPosition(position, uid);

      if (polygon != null) {
        final existingHexagons = Set<Polygon>.from(_state.hexagons);
        existingHexagons.add(polygon);
        _updateState(_state.copyWith(hexagonPolygons: existingHexagons));
      }
    } catch (e) {
      print('❌ 헥사곤 생성 실패: $e');
    }
  }

  void _updateState(ScratchMapState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    if (_state.errorMessage != null) {
      _updateState(_state.copyWith(errorMessage: null));
    }
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }
}