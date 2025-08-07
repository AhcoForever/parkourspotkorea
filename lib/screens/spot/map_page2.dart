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
      body: isLoading
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
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.near_me,
            color: Color(0xFF3A59D1),
        ),
      ),
    );
  }
}
