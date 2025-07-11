import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// 사용자의 현재 위치를 지도에 바로 표시하는 예제
class BasicMapPage extends StatefulWidget {
  @override
  _BasicMapPageState createState() => _BasicMapPageState();
}

class _BasicMapPageState extends State<BasicMapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
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

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = LatLng(pos.latitude, pos.longitude);

      // 맵 컨트롤러가 준비됐으면 카메라 이동
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 15),
          ),
        );
      }
      setState(() {});
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
              target: _currentPosition ?? LatLng(37.5665, 126.9780),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              // 위치가 이미 있으면 곧바로 이동
              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentPosition!, 15),
                );
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // 기본 버튼 비활성
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
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('장소를 검색하세요', style: TextStyle(color: Colors.grey, fontSize: 16)),
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
                // 3-1) 내 위치 찾기 버튼 (우측 정렬)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Icon(Icons.my_location, color: Colors.blueAccent),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // 3-2) scratch map, 채팅, 장소 3개 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BottomCircleButton(
                      onTap: () {/* TODO */},
                      child: Stack(
                        alignment: Alignment.center,

                        children: [

                          Text('scratch map',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration:
                              BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      label: 'scratch map',
                    ),
                    BottomCircleButton(
                      onTap: () {/* TODO */},
                      child: Icon(Icons.chat_bubble_outline,
                          size: 28, color: Colors.blueAccent),
                      label: '버디찾기',
                    ),
                    BottomCircleButton(
                      onTap: () {/* TODO */},
                      child: Icon(Icons.place, size: 28, color: Colors.blueAccent),
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
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
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
