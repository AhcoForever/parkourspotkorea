import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
      context.read<ScratchMapViewModel>().initialize();
    });
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
                },
                initialCameraPosition: CameraPosition(
                  target:
                      viewModel.cameraPosition ??
                      const LatLng(37.5665, 126.9780),
                  zoom: 15,
                ),
                polygons: viewModel.allPolygons,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onCameraMove: (CameraPosition position) {
                  // 카메라 이동 시 viewModel에 위치 업데이트 (선택사항)
                },
              ),

              // 1) Search bar (SafeArea + Align + Padding)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    // 좌우/상단 여백
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
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // ViewModel의 dispose는 Provider가 자동으로 처리
    super.dispose();
  }
}
