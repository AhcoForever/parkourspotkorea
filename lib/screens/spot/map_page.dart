import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkourspotkorea/services/local_geojson_service.dart';
// 사용자의 현재 위치를 지도에 바로 표시

String? _mapStyle;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  Set<Polygon> allPolygons = {}; //전체 행정구역 polygons
  Set<String> visitedAreas = {}; //방문한 지역 ID 들
  bool isLoading = true; //로딩 상태 추가


  @override
  void initState() {

    super.initState();
    _loadKoreaBundary();
    _loadMapStyle();
  }
  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
    setState(() {}); // 스타일이 로딩된 후 다시 build
  }
  Future<void> _loadKoreaBundary() async {
    print('경계선 로딩 시작...');
    Set<Polygon> loadedPolygons = await GeojsonService.loadKoreaBundary();
    setState(() {
      allPolygons = loadedPolygons;
      isLoading = false;
    });
    print('지도에 Polygon 적용 완료');
  }

  void _markAreaAsVisited(String areaId) {
    setState(() {
      visitedAreas.add(areaId);
      //방문한 지역의 polygon 색상 변경
      allPolygons = allPolygons.map((polygon) {
        if (polygon.polygonId.value.startsWith(areaId)) {
          return polygon.copyWith(fillColorParam: Colors.blue.withOpacity(0.5));
        }
        return polygon;
      }).toSet();
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
    }
  }

  //현재 내위치로 이동
  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final latlng = LatLng(pos.latitude, pos.longitude);
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latlng, 15),
      );
      setState(() {

      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 노치/상태바 아래 + 16px
    final topPadding = MediaQuery.of(context).padding.top + 16;
    // 홈 인디케이터 위 + 16px
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Scaffold(
      body: Stack(
        children: [

          // ─── 1) 구글 맵 ───────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              // 위치 준비 전엔 서울 시청
              target: LatLng(37.5326, 126.9906),
              //_currentPosition ?? LatLng(36.5, 127.5),
              zoom: 15,
            ),


            onMapCreated: (controller) {
              mapController = controller;
            },
            polygons: allPolygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // 기본 버튼 비활성
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,

          ),

          // ─── 2) 상단 검색창 ────────────────────────────────────────────────
          Positioned(
            top: topPadding,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // TODO: 검색 로직
              },
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      '장소를 검색하세요',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── 3) 하단 “내 위치 찾기” + 3개 버튼 ───────────────────────────────
          Positioned(
            bottom: bottomPadding,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 3-2) scratch map, 채팅, 장소 3개 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BottomCircleButton(
                      onTap: () {
                        /* TODO */
                        context.goNamed('scratch_map');
                      },
                      child: Icon(
                        Icons.map,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      label: 'scratch map',
                    ),
                    BottomCircleButton(
                      onTap: () {
                        /* TODO */
                      },
                      child: Icon(
                        Icons.accessibility_new_sharp,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      label: '버디찾기',
                    ),
                    BottomCircleButton(
                      onTap: () {
                        /* TODO */
                      },
                      child: Icon(
                        Icons.pin_drop_rounded,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      label: '장소',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────────────────────────────────────────────────────────────────
/// 원형 버튼 + 레이블
class BottomCircleButton extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onTap;

  const BottomCircleButton({
    Key? key,
    required this.child,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
