import 'package:drift/drift.dart' as drift;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/app_db.dart';
import '../../database/app_database.dart';
import '../../services/drift/drift_map_service.dart';
import '../../services/drift/drift_user_service.dart';
import '../../services/firebase/firebase_service.dart';
import '../../utils/hex_helper.dart';

class MapPage2 extends StatefulWidget {
  @override
  _MapPage2State createState() => _MapPage2State();
}

class _MapPage2State extends State<MapPage2> {
  late final AppDatabase _db;
  late final DriftMapService _mapSvc;
  late final DriftUserService _userSvc;
  GoogleMapController? mapController;
  Set<Polygon> polygons = {};
  LatLng? cameraPosition;
  bool isLoading = true;

  // 육각형 모양 폴리곤 그리기
  Set<Polygon> _hexagonPolygons = {};
  bool _isHexagonVisible = false;
  bool _visitedLoaded = false; // 방문 기록 로드 여부

  // Helper to generate hexagon ID based on center LatLng
  String _generateHexagonId(LatLng center) {
    final lat = center.latitude.toStringAsFixed(3);
    final lng = center.longitude.toStringAsFixed(3);
    return 'hex_${lat}_$lng';
  }

  @override
  void initState() {
    super.initState();
    _db = AppDB.instance;
    _mapSvc = DriftMapService(_db);
    _userSvc = DriftUserService(_db);
    _initializeMapSidoLocalFirst();
  }

  /// 1) 초기화: 내 위치 → sido 계산 → Drift 캐시 우선 표시 → 원격 최신화 후 갱신
  Future<void> _initializeMapSidoLocalFirst() async {
    final pos = await _getInitialCameraPositionFromLocal();
    //todo: jh , service 객체 직접생성. provider 태우지 않기. provier는 나중에 view model 태울 예정임. 필요한 method는 service에서 가져오기.
    // 1) 카메라 초기 위치
    setState(() {
      cameraPosition = pos;
      isLoading = true;
    });

    // 2) 내 위치로 sido 코드 계산
    //todo: jh geocoding도 backend로 여기고 refactoring
    final sido = await _resolveSidoCode(pos);

    // 3) Drift 캐시 먼저 표시

    final localRows = await _mapSvc.getPolygonsBySido(sido);
    if (localRows.isNotEmpty) {
      final localPolys = _buildPolygonsFromRows(localRows);
      setState(() {
        polygons = localPolys.union(_hexagonPolygons);
        isLoading = false;
      });
    } else {
      //empty 상황
      //todo JH : drift에 polygon정보가 없으면 firebase에서 읽어와서 drift에 넣고, drift로부터 다시 읽어야함.
    }

    // 4) 원격 최신화 → 캐시 upsert → 화면 갱신
    final docs = await FirebaseService.loadDocsBySidoRaw(sido);
    //todo: jh FirebaseService 객체화,
    //todo: jh try-catch 로 error 처리
    final companions = docs.map((m) {
      final sgg = m['sgg'] as int?;
      final sggPrefix = (sgg == null) ? null : sgg - (sgg % 100);
      return PolygonsCompanion.insert(
        docId: m['docId'] as String,
        sido: m['sido'] as int,
        sggPrefix: drift.Value(sggPrefix),
        coordinatesJson: m['coordinates'] as String,
        updatedAt: DateTime.now(),
      );
    }).toList();
    await _mapSvc.upsertPolygonsCompanions(companions);
    final fetchedPolygons = docs
        .map<Polygon?>((m) {
          final pts = FirebaseService.parseCoordinates(
            m['coordinates'] as String,
          );
          if (pts.isEmpty) return null;
          return Polygon(
            polygonId: PolygonId(m['docId'] as String),
            points: pts,
            strokeColor: const Color(0xFF007AFF),
            fillColor: const Color(0x22007AFF),
            strokeWidth: 1,
          );
        })
        .whereType<Polygon>()
        .toSet();

    if (!mounted) return;
    setState(() {
      polygons = fetchedPolygons.union(_hexagonPolygons);
      isLoading = false;
    });

    // 방문 헥사곤 복원 (기존 로직 유지)
    await _loadVisitedHexagons();
  }

  Future<LatLng> _getInitialCameraPositionFromLocal() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final u = await _userSvc.getUser(uid);
      if (u != null &&
          u.currentLatitude != null &&
          u.currentLongitude != null) {
        return LatLng(u.currentLatitude!, u.currentLongitude!);
      }
    }
    return const LatLng(37.5665, 126.9780); // 서울 시청 fallback
  }

  /// 3) 위경도 -> sido 코드 계산 (간단 매핑)
  Future<int> _resolveSidoCode(LatLng ll) async {
    final placemarks = await placemarkFromCoordinates(
      ll.latitude,
      ll.longitude,
    );
    if (placemarks.isEmpty) return 11; // 서울 fallback

    final name = placemarks.first.administrativeArea ?? '';

    const sidoMap = {
      '서울특별시': 11,
      '부산광역시': 26,
      '대구광역시': 27,
      '인천광역시': 28,
      '광주광역시': 29,
      '대전광역시': 30,
      '울산광역시': 31,
      '세종특별자치시': 36,
      '경기도': 41,
      '강원특별자치도': 42,
      '충청북도': 43,
      '충청남도': 44,
      '전라북도': 45,
      '전라남도': 46,
      '경상북도': 47,
      '경상남도': 48,
      '제주특별자치도': 50,
    };

    final normalized = name.replaceAll('강원도', '강원특별자치도');
    return sidoMap[normalized] ?? 11;
  }

  /// 2) Drift Row -> Polygon 변환
  Set<Polygon> _buildPolygonsFromRows(List<PolygonRow> rows) {
    return rows.map((r) {
      final pts = FirebaseService.parseCoordinates(r.coordinatesJson);
      return Polygon(
        polygonId: PolygonId(r.docId),
        points: pts,
        strokeColor: const Color(0xFF007AFF),
        fillColor: const Color(0x22007AFF),
        strokeWidth: 1,
      );
    }).toSet();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      final latlng = LatLng(pos.latitude, pos.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));
    } catch (e) {
      print('위치 오류: $e');
    }
  }

  Future<void> _toggleHexagons() async {
    // 토글 OFF: 현재 표시된 헥사곤을 숨기기(데이터는 유지)
    if (_isHexagonVisible) {
      setState(() {
        _isHexagonVisible = false;
      });
      return;
    }

    // 토글 ON: 방문 헥사곤이 아직 로드되지 않았다면 먼저 로드
    if (!_visitedLoaded) {
      await _loadVisitedHexagons();
    }

    // 현재 위치의 헥사곤도 표시 (중복이면 색상만 유지)
    await _showHexagonAtMyLocation();

    // 표시 상태 ON
    if (mounted) {
      setState(() {
        _isHexagonVisible = true;
      });
    }
  }

  Future<void> _showHexagonAtMyLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final center = LatLng(position.latitude, position.longitude);
    final hexId = _generateHexagonId(center);
    final hexPoints = generateHexagon(center, 100);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('로그인 정보 없음 - 방문 기록을 저장할 수 없습니다.');
      return;
    }
    final visitedHexIds = await _userSvc.getVisitedRegions(uid);
    final isVisited = visitedHexIds.contains(hexId);

    final hexPolygon = Polygon(
      polygonId: PolygonId(hexId),
      points: hexPoints,
      strokeColor: isVisited ? Colors.green : const Color(0xFFFF5722),
      fillColor: isVisited ? const Color(0x4432CD32) : const Color(0x44FF5722),
      strokeWidth: 2,
    );

    setState(() {
      _hexagonPolygons.removeWhere((p) => p.polygonId.value == hexId);
      _hexagonPolygons.add(hexPolygon);
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(center, 15));

    if (!isVisited) {
      await _userSvc.visitNewRegion(uid, hexId);
      print("🟢 방문 이력 저장됨: $hexId");
    } else {
      print('이미 방문한 헥사곤: $hexId');
    }
  }

  Future<void> _loadVisitedHexagons() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final visitedHexIds = await _userSvc.getVisitedRegions(uid);

    final toAdd = <Polygon>{};
    for (final hexId in visitedHexIds) {
      final coords = hexId.replaceFirst('hex_', '').split('_');
      if (coords.length != 2) continue;

      final lat = double.tryParse(coords[0]);
      final lng = double.tryParse(coords[1]);
      if (lat == null || lng == null) continue;

      final center = LatLng(lat, lng);
      final hexPoints = generateHexagon(center, 100);

      toAdd.add(
        Polygon(
          polygonId: PolygonId(hexId),
          points: hexPoints,
          strokeColor: Colors.green,
          fillColor: const Color(0x4432CD32),
          strokeWidth: 2,
        ),
      );
    }

    setState(() {
      _hexagonPolygons.addAll(toAdd);
      _visitedLoaded = true;
    });

    print("✅ 방문한 헥사곤 복원 완료 (${visitedHexIds.length}개)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        cameraPosition ??
                        const LatLng(37.5665, 126.9780), //널 가드
                    zoom: 15,
                  ),
                  polygons: _isHexagonVisible
                      ? polygons.union(_hexagonPolygons)
                      : polygons,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),

          // 1. Search bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xF2FFFFFF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFFCAD2F3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF3A59D1)),
                  SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print("검색창 클릭됨");
                        // TODO: 검색 페이지 또는 검색 기능 연결
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 2. Top-right Button (setting and star)
          Positioned(
            top: 100,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'settings_button',
                  mini: true,
                  onPressed: () {
                    print('설정 버튼 클릭');
                  },
                  child: Icon(Icons.settings, color: Color(0xFF3A59D1)),
                ),
                SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'Location Bookmark',
                  mini: true,
                  onPressed: () {
                    print('즐겨찾기 버튼 클릭');
                  },
                  child: Icon(Icons.star_outlined, color: Color(0xFF3A59D1)),
                ),
              ],
            ),
          ),
          // 3. Scratch Map Button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: FloatingActionButton(
                  heroTag: 'globe_button',
                  onPressed: () async {
                    print('지구본 버튼 클릭');
                   await _toggleHexagons();
                  },
                  child: Icon(Icons.public, color: Color(0xFF3A59D1)),
                ),
              ),
            ),
          ),
          // My Location Button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24, right: 16),
                child: FloatingActionButton(
                  heroTag: 'location_button',
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.near_me, color: Color(0xFF3A59D1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
