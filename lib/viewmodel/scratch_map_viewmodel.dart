import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert'; // JSON 파싱을 위해 추가
import 'dart:async'; // StreamSubscription을 위해 추가
import 'package:geolocator/geolocator.dart'; // Position을 위해 추가

import '../interfaces/scratch_map_interfaces.dart';
import '../model/scratch_map_state.dart';
import '../database/app_database.dart'; // PolygonRow를 위해 추가
import '../services/firebase/firebase_service.dart'; // 좌표 파싱용

class ScratchMapViewModel extends ChangeNotifier {
  final IScratchMapRepository _scratchMapRepository;
  final IUserRepository _userRepository;
  final ILocationRepository _locationRepository;

  // 위치 추적 관련
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _lastHexagonId;

  ScratchMapViewModel({
    required IScratchMapRepository scratchMapRepository,
    required IUserRepository userRepository,
    required ILocationRepository locationRepository,
  })  : _scratchMapRepository = scratchMapRepository,
        _userRepository = userRepository,
        _locationRepository = locationRepository;

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
      // 1. 초기 카메라 위치 설정
      final initialPosition = await _userRepository.getInitialCameraPosition();
      _updateState(_state.copyWith(cameraPosition: initialPosition));

      // 2. sido 코드 계산 및 폴리곤 로드
      final sido = await _locationRepository.resolveSidoCode(initialPosition);
      await _loadPolygonsForSido(sido);

      // 3. 방문한 헥사곤 복원
      await _loadVisitedHexagons();

      _updateState(_state.copyWithLoading(false));
      print('✅ ScratchMap 초기화 완료');
    } catch (e) {
      _updateState(_state.copyWithError('초기화 실패: $e'));
      print('❌ 초기화 실패: $e');
    }
  }

  /// sido별 폴리곤 로드
  Future<void> _loadPolygonsForSido(int sido) async {
    try {
      // 1. 로컬 캐시 먼저 로드
      final localRows = await _scratchMapRepository.getPolygonsBySido(sido);
      if (localRows.isNotEmpty) {
        final localPolygons = _scratchMapRepository.convertRowsToPolygons(localRows);
        _updateState(_state.copyWith(polygons: localPolygons));
        print('✅ 로컬 폴리곤 로드 완료: ${localPolygons.length}개');
      }

      // 2. 원격에서 최신 데이터 가져와서 업데이트
      final remotePolygons = await _scratchMapRepository.fetchAndCachePolygons(sido);
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

  /// 실시간 위치 추적 시작
  void _startLocationTracking() {
    _stopLocationTracking();

    // Repository를 통해 위치 스트림 구독
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