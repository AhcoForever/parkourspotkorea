import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../interfaces/parkour_spot_interface.dart';
import '../interfaces/scratch_map_interface.dart';
import '../model/parkour_spot.dart';
import '../model/scratch_map_state.dart';

class ScratchMapViewModel extends ChangeNotifier {
  final IScratchMapRepository _scratchMapRepository;
  final IUserRepository _userRepository;
  final ILocationRepository _locationRepository;
  final IParkourSpotRepository _spotRepo;

  // 파쿠르 스팟 마커 상태
  final Set<Marker> _parkourMarkers = {};
  BitmapDescriptor? _customSpotMarker;

  Set<Marker> get parkourMarkers => _parkourMarkers;
  bool _isLoadingSpots = false;

  bool get isLoadingSpots => _isLoadingSpots;
  BitmapDescriptor? get customSpotMarker => _customSpotMarker;

  /// 중심 좌표 기준 주변 스팟을 가져와 마커로 표시
  Future<void> loadAndShowSpots(LatLng center, {double radiusKm = 5.0}) async {
    if (_isLoadingSpots) return;
    _isLoadingSpots = true;
    notifyListeners();

    try {
      final spots = await _spotRepo.fetchNearby(
        center: center,
        radiusKm: radiusKm,
      );
      // 🎯 스팟 정보 캐시에 저장
      _loadedSpots.clear();
      for (final spot in spots) {
        _loadedSpots[spot.documentId] = spot;
      }

      _parkourMarkers
        ..clear() // 기존 마커 완전 제거
        ..addAll(
          spots.map((spot) {
            return Marker(
              markerId: MarkerId('spot_${spot.documentId}'),
              position: spot.location,
              infoWindow: InfoWindow(
                title: spot.displayName.isNotEmpty
                    ? spot.displayName
                    : spot.name,
                snippet: spot.description,
              ),
              icon: _customSpotMarker ?? _getMarkerIcon(spot.category),
              onTap: () {
                print('🎯 마커 탭: ${spot.name} (${spot.documentId})');
                _onMarkerTapped(spot);
              },
            );
          }),
        );
      // 스팟 정보 캐시 추가
      _loadedSpots.clear();
      for(final spot in spots){
        _loadedSpots[spot.documentId] = spot;
      }
      print('✅ 주변 스팟 ${spots.length}개 로드/표시 완료');
    } catch (e) {
      print('❌ loadAndShowSpots 실패: $e');
    } finally {
      _isLoadingSpots = false;
      notifyListeners();
    }
  }

  Function(ParkourSpot)? onSpotMarkerTapped;

  void _onMarkerTapped(ParkourSpot spot) {
    print('🎯 마커 탭됨: ${spot.name}');

    // 외부 콜백이 있으면 호출
    if (onSpotMarkerTapped != null) {
      onSpotMarkerTapped!(spot);
    }
  }

  // 위치 추적 관련
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _lastHexagonId;

  ScratchMapViewModel({
    required IScratchMapRepository scratchMapRepository,
    required IUserRepository userRepository,
    required ILocationRepository locationRepository,
    required IParkourSpotRepository spotRepository,
  }) : _scratchMapRepository = scratchMapRepository,
       _userRepository = userRepository,
       _locationRepository = locationRepository,
       _spotRepo = spotRepository;

  // 현재 상태
  ScratchMapState _state = ScratchMapState.initial();

  ScratchMapState get state => _state;

  // Getters
  bool get isLoading => _state.isLoading;

  bool get isHexagonVisible => _state.isHexagonVisible;

  Set<Polygon> get allPolygons => _state.allPolygons;

  LatLng? get cameraPosition => _state.cameraPosition;

  String? get errorMessage => _state.errorMessage;

  /// 초기화
  Future<void> initialize() async {
    _updateState(_state.copyWithLoading(true));

    try {
      // 커스텀 마커 아이콘 로드
      await _loadCustomMarkerIcon();


      // 1. 현재 위치를 초기 카메라 위치로 설정 (timeout 추가)
      Position? currentPosition;
      try {
        currentPosition = await _locationRepository.getCurrentPosition().timeout(
          Duration(seconds: 5),
          onTimeout: () => null,
        );
      } catch (e) {
        print('위치 가져오기 실패: $e');
        currentPosition = null;
      }

      LatLng initialPosition;

      if (currentPosition != null) {
        initialPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
        print('현재 위치로 초기화: ${initialPosition.latitude}, ${initialPosition.longitude}');
      } else {
        // 현재 위치를 가져올 수 없으면 기본값 사용
        try {
          initialPosition = await _userRepository.getInitialCameraPosition().timeout(
            Duration(seconds: 3),
            onTimeout: () => const LatLng(37.5665, 126.9780), // 서울시청 기본값
          );
          print('기본 위치로 폴백: ${initialPosition.latitude}, ${initialPosition.longitude}');
        } catch (e) {
          print('기본 위치 가져오기 실패, 하드코딩된 기본값 사용: $e');
          initialPosition = const LatLng(37.5665, 126.9780);
        }
      }

      _updateState(_state.copyWith(cameraPosition: initialPosition));

      // 2. sido 코드 계산 및 폴리곤 로드 (timeout 추가)
      try {
        final sido = await _locationRepository.resolveSidoCode(initialPosition).timeout(
          Duration(seconds: 5),
          onTimeout: () => 11, // 서울 기본값
        );
        await _loadPolygonsForSido(sido).timeout(Duration(seconds: 5));
      } catch (e) {
        print('폴리곤 로드 실패, 계속 진행: $e');
        // 폴리곤 로드 실패해도 계속 진행
      }

      // 3. 방문한 헥사곤 복원 (timeout 추가)
      try {
        await _loadVisitedHexagons().timeout(Duration(seconds: 3));
      } catch (e) {
        print('헥사곤 로드 실패, 계속 진행: $e');
        // 헥사곤 로드 실패해도 계속 진행
      }

      _updateState(_state.copyWithLoading(false));
      print('ScratchMap 초기화 완료');
    } catch (e) {
      _updateState(_state.copyWithError('초기화 실패: $e'));
      print('초기화 실패: $e');
    }
  }

  /// sido별 폴리곤 로드
  Future<void> _loadPolygonsForSido(int sido) async {
    try {
      // 1. 로컬 캐시 먼저 로드
      final localRows = await _scratchMapRepository.getPolygonsBySido(sido);
      if (localRows.isNotEmpty) {
        final localPolygons = _scratchMapRepository.convertRowsToPolygons(
          localRows,
        );
        _updateState(_state.copyWith(polygons: localPolygons));
        print('✅ 로컬 폴리곤 로드 완료: ${localPolygons.length}개');
      }

      // 2. 원격에서 최신 데이터 가져와서 업데이트
      final remotePolygons = await _scratchMapRepository.fetchAndCachePolygons(
        sido,
      );
      _updateState(_state.copyWith(polygons: remotePolygons));
      print('✅ 원격 폴리곤 로드 완료: ${remotePolygons.length}개');
    } catch (e) {
      print('❌ 폴리곤 로드 실패: $e');
    }
  }

  /// 현재 위치로 이동
  Future<LatLng?> moveToCurrentLocation() async {
    try {
      final position = await _locationRepository.getCurrentPosition();

      if (position != null) {
        final latLng = LatLng(position.latitude, position.longitude);
        _updateState(_state.copyWith(cameraPosition: latLng));
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

  /// 헥사곤 토글
  Future<void> toggleHexagons() async {
    try {
      if (_state.isHexagonVisible) {
        // 토글 OFF - 위치 추적도 중지
        _stopLocationTracking();
        _updateState(_state.copyWith(isHexagonVisible: false));
        print('🔄 헥사곤 숨김 & 위치 추적 중지');
        return;
      }

      // 토글 ON
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

  /// 현재 위치에 헥사곤 표시
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

  /// 방문한 헥사곤 복원
  Future<void> _loadVisitedHexagons() async {
    try {
      final uid = await _userRepository.getCurrentUserId();
      if (uid == null) return;

      final visitedHexIds = await _userRepository.getVisitedRegions(uid);
      if (visitedHexIds.isEmpty) {
        _updateState(_state.copyWith(visitedLoaded: true));
        return;
      }

      // Repository를 통해 헥사곤 복원
      final hexagons = await _locationRepository.restoreVisitedHexagons(
        visitedHexIds,
      );

      _updateState(
        _state.copyWith(hexagonPolygons: hexagons, visitedLoaded: true),
      );

      print("✅ 방문한 헥사곤 복원 완료 (${visitedHexIds.length}개)");
    } catch (e) {
      print('❌ 방문 헥사곤 로드 실패: $e');
    }
  }

  /// 실시간 위치 추적 시작
  void _startLocationTracking() {
    _stopLocationTracking();

    // Repository를 통해 위치 스트림 구독
    _positionStreamSubscription = _locationRepository
        .getPositionStream()
        .listen(
          (Position position) {
            _handleLocationUpdate(position);
          },
          onError: (error) {
            print('❌ 위치 추적 오류: $error');
          },
        );

    print('📍 실시간 위치 추적 시작됨');
  }

  /// 실시간 위치 추적 중지
  void _stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    print('🛑 실시간 위치 추적 중지됨');
  }

  /// 위치 업데이트 처리
  Future<void> _handleLocationUpdate(Position position) async {
    if (!_state.isHexagonVisible) return;

    try {
      final current = LatLng(position.latitude, position.longitude);

      // Repository를 통해 헥사곤 ID 생성
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

  /// 특정 위치에 헥사곤 생성
  Future<void> _createHexagonAtPosition(LatLng position) async {
    try {
      final uid = await _userRepository.getCurrentUserId();
      if (uid == null) return;

      // Repository를 통해 헥사곤 생성 및 방문 처리
      final polygon = await _locationRepository.createHexagonAtPosition(
        position,
        uid,
      );

      if (polygon != null) {
        final existingHexagons = Set<Polygon>.from(_state.hexagons);
        existingHexagons.add(polygon);
        _updateState(_state.copyWith(hexagonPolygons: existingHexagons));
      }
    } catch (e) {
      print('❌ 헥사곤 생성 실패: $e');
    }
  }

  /// 스팟 ID로 상세 정보 조회
  Future<ParkourSpot?> getSpotById(String documentId) async {
    try {
      return await _spotRepo.getById(documentId);
    } catch (e) {
      print('❌ 스팟 조회 실패: $e');
      return null;
    }
  }

  /// 현재 로드된 마커들의 스팟 정보 맵
  final Map<String, ParkourSpot> _loadedSpots = {};

  /// 캐시된 스팟 정보로 빠른 조회
  ParkourSpot? getCachedSpot(String documentId) {
    return _loadedSpots[documentId];
  }

  /// 카테고리별 마커 아이콘 (선택사항)
  BitmapDescriptor _getMarkerIcon(String category) {
    // 기본 마커 사용 (나중에 커스텀 아이콘으로 교체 가능)
    switch (category.toLowerCase()) {
      case 'park':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'school':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'parkour_gym':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      default:

        return BitmapDescriptor.defaultMarkerWithHue(270.0);
    }
  }

  Future<void> _loadCustomMarkerIcon() async {
    try {
      _customSpotMarker = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(24, 28)),
        'assets/images/spot-marker.png',
      );
      print('✅ 커스텀 스팟 마커 로드 완료');
    } catch (e) {
      print('❌ 커스텀 마커 로드 실패 (PNG): $e');

      // PNG가 없다면 기본 마커 사용
      _customSpotMarker = null;
    }
  }

  /// 상태 업데이트 헬퍼
  void _updateState(ScratchMapState newState) {
    _state = newState;
    notifyListeners();
  }

  /// 에러 상태 클리어
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
