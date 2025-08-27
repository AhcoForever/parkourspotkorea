
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkourspotkorea/screens/spot/parkourspot_BottomSheet_page.dart';
import 'package:provider/provider.dart';

import '../../model/parkour_spot.dart';
import '../../viewmodel/scratch_map_viewmodel.dart';

class ScratchMapPage extends StatefulWidget {
  @override
  _ScratchMapPageState createState() => _ScratchMapPageState();
}

class _ScratchMapPageState extends State<ScratchMapPage> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    // ViewModel 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ScratchMapViewModel>();

      // 콜백
      viewModel.onSpotMarkerTapped = (ParkourSpot spot) {
        _showSpotBottomSheet(spot);
      };

      viewModel.initialize();
    });
  }

  /// Bottom Sheet 표시
  void _showSpotBottomSheet(ParkourSpot spot) {
    print('🎉 Bottom Sheet 표시: ${spot.name}');

    ParkourBottomSheetHelper.show(
      context,
      spot,
      onClose: () {
        print('Bottom Sheet 닫힘: ${spot.name}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScratchMapViewModel>(
        builder: (context, viewModel, child) {
          // 로딩 상태 처리
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 에러 상태 처리
          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('오류: ${viewModel.errorMessage}'),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.clearError();
                      viewModel.initialize();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;

                  // 마커 로드 (카메라 중심)
                  final center =
                      viewModel.cameraPosition ??
                          const LatLng(37.5665, 126.9780);
                  viewModel.loadAndShowSpots(center, radiusKm: 7);
                },
                initialCameraPosition: CameraPosition(
                  target:
                  viewModel.cameraPosition ??
                      const LatLng(37.5665, 126.9780),
                  zoom: 15,
                ),

                // 🎯 마커 바인딩 (각 마커에 onTap이 이미 설정됨)
                markers: viewModel.parkourMarkers,

                polygons: viewModel.allPolygons,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,

                onTap: (LatLng position) {
                  print('지도 탭: ${position.latitude}, ${position.longitude}');
                  // 지도 탭 시 추가 처리 가능 (선택사항)
                },

                onCameraMove: (CameraPosition position) {
                  // 카메라 이동 시 viewModel에 위치 업데이트
                },
                onCameraIdle: () async {
                  // 카메라 멈출 때마다 갱신
                  if (mapController == null) return;
                  final size = MediaQuery.of(context).size;
                  final center = await mapController!.getLatLng(
                    ScreenCoordinate(
                      x: (size.width ~/ 2),
                      y: (size.height ~/ 2),
                    ),
                  );
                  viewModel.loadAndShowSpots(center, radiusKm: 5);
                },
              ),

              // 1) Search bar (SafeArea + Align + Padding)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      width: 358,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        color: const Color(0x99F4F7FE),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            color: const Color(0xFFCAD2F3),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x197F93E1),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          const Icon(Icons.search, color: Color(0xFF3A59D1)),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print("검색창 클릭됨");
                                // TODO: 검색 페이지 또는 검색 기능 연결
                              },
                              child: Text(
                                '파쿠르 스팟 검색...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Top-right Button (myPage and setting and star )
              Positioned(
                top: 150,
                right: 29,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'myPage_button',
                      mini: true,
                      onPressed: () {
                        print('프로필 버튼 클릭');
                      },
                      child: SvgPicture.asset(
                        width: 18,
                        height: 18,
                        'assets/icons/person.svg',
                      ),
                    ),

                    const SizedBox(height: 12),

                    FloatingActionButton(
                      heroTag: 'setting_button',
                      mini: true,
                      onPressed: () {
                        print('설정 버튼 클릭');
                      },
                      child: const Icon(
                        size: 24,
                        Icons.settings,
                        color: Color(0xFF3A59D1),
                      ),
                    ),

                    const SizedBox(height: 12),

                    FloatingActionButton(
                      heroTag: 'Location Bookmark',
                      mini: true,
                      onPressed: () {
                        print('즐겨찾기 버튼 클릭');
                      },
                      child: SvgPicture.asset(
                        'assets/icons/star.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Scratch Map Button
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: FloatingActionButton(
                        heroTag: 'globe_button',
                        onPressed: () async {
                          await viewModel.toggleHexagons();
                        },
                        backgroundColor: viewModel.isHexagonVisible
                            ? Color(0xFF42549B)
                            : const Color(0x99F4F7FE),
                        child: SvgPicture.asset(
                          'assets/icons/material-symbols_globe-asia-sharp.svg',
                          width: 56,
                          height: 56,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // My Location Button
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 45, right: 53),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: FloatingActionButton(
                        heroTag: 'location_button',
                        onPressed: () async {
                          final newPosition = await viewModel
                              .moveToCurrentLocation();
                          if (newPosition != null && mapController != null) {
                            mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(newPosition, 16),
                            );
                          }
                        },
                        child: const Icon(
                          size: 24,
                          Icons.near_me,
                          color: Color(0xFF3A59D1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 🔄 로딩 인디케이터 (스팟 로드 중)
              if (viewModel.isLoadingSpots)
                Positioned(
                  top: 100,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '파쿠르 스팟 로딩 중...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}