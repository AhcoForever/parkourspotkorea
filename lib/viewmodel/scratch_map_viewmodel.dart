import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert'; // JSON 파싱을 위해 추가
import 'dart:async'; // StreamSubscription을 위해 추가
import 'package:geolocator/geolocator.dart'; // Position을 위해 추가

import '../interfaces/scratch_map_interfaces.dart';
import '../const/constants.dart';
import '../model/scratch_map_state.dart';
import '../utils/hex_helper.dart';
import '../database/app_database.dart'; // PolygonRow를 위해 추가

/// ScratchMap 페이지의 ViewModel
class ScratchMapViewModel extends ChangeNotifier {
  final IScratchMapRepository scratchMapRepository;
  final ILocationService locationService;
  final IUserRepository userRepository;
  final IHexagonService hexagonService;

  // 위치 추적 관련
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _lastHexagonId; // 마지막으로 생성된 헥사곤 ID 추적

  ScratchMapViewModel({
    required this.scratchMapRepository,
    required this.locationService,
    required this.userRepository,
    required this.hexagonService,
  });

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
      final initialPosition = await userRepository.getInitialCameraPosition();
      _updateState(_state.copyWith(cameraPosition: initialPosition));

      // 2. sido 코드 계산 및 폴리곤 로드
      final sido = await locationService.resolveSidoCode(initialPosition);
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
      final localRows = await scratchMapRepository.getPolygonsBySido(sido);
      if (localRows.isNotEmpty) {
        final localPolygons = _convertRowsToPolygons(localRows); // 직접 변환
        _updateState(_state.copyWith(polygons: localPolygons));
        print('✅ 로컬 폴리곤 로드 완료: ${localPolygons.length}개');
      }

      // 2. 원격에서 최신 데이터 가져와서 업데이트
      final remotePolygons = await scratchMapRepository.fetchAndCachePolygons(sido);
      _updateState(_state.copyWith(polygons: remotePolygons));
      print('✅ 원격 폴리곤 로드 완료: ${remotePolygons.length}개');
    } catch (e) {
      print('❌ 폴리곤 로드 실패: $e');
      // 에러가 발생해도 기존 데이터는 유지
    }
  }

  /// 현재 위치로 이동
  Future<LatLng?> moveToCurrentLocation() async {
    try {
      final position = await locationService.getCurrentPosition();
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
      _startLocationTracking(); // 실시간 위치 추적 시작
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
      final position = await locationService.getCurrentPosition();
      if (position == null) return;

      final current = LatLng(position.latitude, position.longitude);
      await _createHexagonAtPosition(current); // 공통 로직 사용

      // 카메라 이동
      _updateState(_state.copyWith(cameraPosition: current));
    } catch (e) {
      print('❌ 헥사곤 표시 실패: $e');
    }
  }

  /// 방문한 헥사곤 복원
  Future<void> _loadVisitedHexagons() async {
    try {
      final uid = await userRepository.getCurrentUserId();
      if (uid == null) return;

      final visitedHexIds = await userRepository.getVisitedRegions(uid);
      if (visitedHexIds.isEmpty) {
        _updateState(_state.copyWith(visitedLoaded: true));
        return;
      }

      final hexagons = <Polygon>{};

      for (final hexId in visitedHexIds) {
        final hexagonData = hexagonService.restoreHexagon(AppConstants.GLOBAL_HEX_ORIGIN, hexId);
        if (hexagonData != null) {
          hexagons.add(Polygon(
            polygonId: PolygonId(hexId),
            points: hexagonData.points,
            strokeColor: Colors.green,
            fillColor: const Color(0x4432CD32),
            strokeWidth: 2,
          ));
        }
      }

      _updateState(_state.copyWith(
        hexagonPolygons: hexagons,
        visitedLoaded: true,
      ));

      print("✅ 방문한 헥사곤 복원 완료 (${visitedHexIds.length}개)");
    } catch (e) {
      print('❌ 방문 헥사곤 로드 실패: $e');
    }
  }

  /// 상태 업데이트 헬퍼
  void _updateState(ScratchMapState newState) {
    _state = newState;
    notifyListeners();
  }

  /// 실시간 위치 추적 시작
  void _startLocationTracking() {
    // 기존 추적이 있다면 중지
    _stopLocationTracking();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 80, // 헥사곤 크기(100m)의 80% 정도로 설정
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _handleLocationUpdate(position);
    }, onError: (error) {
      print('❌ 위치 추적 오류: $error');
    });

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
    if (!_state.isHexagonVisible) return; // 헥사곤이 비활성화되어 있으면 처리하지 않음

    try {
      final current = LatLng(position.latitude, position.longitude);

      // 현재 위치의 헥사곤 ID 계산
      final currentHexId = hexagonService.generateHexId(AppConstants.GLOBAL_HEX_ORIGIN, current);

      // 마지막 헥사곤과 같다면 새로 생성하지 않음
      if (_lastHexagonId == currentHexId) {
        return;
      }

      // 이미 표시된 헥사곤인지 확인
      if (_state.hexagonPolygons.any((p) => p.polygonId.value == currentHexId)) {
        _lastHexagonId = currentHexId;
        return;
      }

      // 새로운 헥사곤 생성
      await _createHexagonAtPosition(current);
      _lastHexagonId = currentHexId;

      print('🆕 새로운 헥사곤 자동 생성: $currentHexId');
    } catch (e) {
      print('❌ 위치 업데이트 처리 실패: $e');
    }
  }

  /// 특정 위치에 헥사곤 생성 (공통 로직)
  Future<void> _createHexagonAtPosition(LatLng position) async {
    try {
      // 헥사곤 생성
      final hexagonData = hexagonService.createHexagon(AppConstants.GLOBAL_HEX_ORIGIN, position);
      if (hexagonData == null) return;

      // 방문 여부 확인
      final uid = await userRepository.getCurrentUserId();
      if (uid == null) return;

      final visitedRegions = await userRepository.getVisitedRegions(uid);
      final isVisited = visitedRegions.contains(hexagonData.id);

      // 폴리곤 생성
      final polygon = Polygon(
        polygonId: PolygonId(hexagonData.id),
        points: hexagonData.points,
        strokeColor: isVisited ? Colors.green : const Color(0xFFFF5722),
        fillColor: isVisited ? const Color(0x4432CD32) : const Color(0x44FF5722),
        strokeWidth:2,
      );

      // 상태 업데이트
      final existingHexagons = Set<Polygon>.from(_state.hexagonPolygons);
      existingHexagons.add(polygon);
      _updateState(_state.copyWith(hexagonPolygons: existingHexagons));

      // 방문 기록 저장
      if (!isVisited) {
        await userRepository.visitRegion(uid, hexagonData.id);
        print("🟢 새로운 방문 이력 저장됨: ${hexagonData.id}");
      }
    } catch (e) {
      print('❌ 헥사곤 생성 실패: $e');
    }
  }

  /// 에러 상태 클리어
  void clearError() {
    if (_state.errorMessage != null) {
      _updateState(_state.copyWith(errorMessage: null));
    }
  }

  /// PolygonRow들을 Polygon으로 변환 (private 헬퍼 메소드)
  Set<Polygon> _convertRowsToPolygons(List<PolygonRow> rows) {
    return rows.map((r) {
      final pts = _parseCoordinates(r.coordinatesJson);
      return Polygon(
        polygonId: PolygonId(r.docId),
        points: pts,
        strokeColor: const Color(0xFF007AFF),
        fillColor: const Color(0x22007AFF),
        strokeWidth: 1,
      );
    }).toSet();
  }

  /// 좌표 문자열 파싱 (Firebase에서 가져온 JSON 문자열을 LatLng 리스트로 변환)
  List<LatLng> _parseCoordinates(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      final List<dynamic> rawCoords = decoded[0][0];
      return rawCoords.map<LatLng>((pair) => LatLng(pair[1], pair[0])).toList();
    } catch (e) {
      print('좌표 파싱 오류: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _stopLocationTracking(); // 위치 추적 정리
    super.dispose();
  }
}