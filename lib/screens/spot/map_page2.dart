import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkourspotkorea/repositories/user_repository.dart';

import '../../services/firebase/firebase_service.dart';

class MapPage2 extends StatefulWidget {
  @override
  _MapPage2State createState() => _MapPage2State();
}

class _MapPage2State extends State<MapPage2> {
  GoogleMapController? mapController;
  Set<Polygon> polygons = {};
  LatLng? cameraPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPolygons();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final pos = await UserRepository().getInitialCameraPosition();
    final loadedPolygons = await FirebaseService.loadKoreaBoundaryPolygons();
    setState(() {
      cameraPosition = pos;
      polygons = loadedPolygons;
      isLoading = false;
    });
  }

  Future<void> _fetchPolygons() async {
    print('Firestore에서 경계 불러오는 중...');
    final loadedPolygons = await FirebaseService.loadKoreaBoundaryPolygons();
    setState(() {
      polygons = loadedPolygons;
      isLoading = false;
    });
    print('지도에 폴리곤 렌더링 완료');
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      final latlng = LatLng(pos.latitude, pos.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(latlng, 14));
    } catch (e) {
      print('위치 오류: $e');
    }
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
                    target: cameraPosition!,
                    zoom: 15,
                  ),
                  polygons: polygons,
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xF2FFFFFF),
                borderRadius: BorderRadius.circular(24),
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
                      child: Text(
                        "장소 검색",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A707C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 2. Top-right Button (setting and star)
          Positioned(
            top: 60,
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
                  child: Icon(Icons.star, color: Color(0xFF3A59D1)),
                ),
              ],
            ),
          ),
          // 3. Scratch Map Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: FloatingActionButton(
                heroTag: 'globe_button',
                onPressed: () {
                  print('지구본 버튼 클릭');
                },
                child: Icon(Icons.public, color: Color(0xFF3A59D1)),
              ),
            ),
          ),
          // My Location Button
          Align(
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
        ],
      ),
    );
  }
}
