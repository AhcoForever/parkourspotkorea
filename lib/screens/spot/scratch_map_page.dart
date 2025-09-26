import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:parkourspotkorea/screens/spot/parkourspot_bottomsheet_page.dart';
import 'package:parkourspotkorea/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../model/parkour_spot.dart';
import '../../viewmodel/scratch_map_viewmodel.dart';
import '../../viewmodel/parkour_search_viewmodel.dart';
import '../../services/firebase/parkour_spot_search_service.dart';

class ScratchMapPage extends StatefulWidget {
  const ScratchMapPage({super.key});

  @override
  _ScratchMapPageState createState() => _ScratchMapPageState();
}

class _ScratchMapPageState extends State<ScratchMapPage> {
  GoogleMapController? mapController;
  String? _mapStyle;
  late ParkourSearchViewModel _searchViewModel;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchResults = false;
  bool _isScratched = false;

  // CustomInfoWindow 컨트롤러
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  @override
  void initState() {
    super.initState();

    // 검색 ViewModel 초기화 (Firebase 기반)
    final searchService = FirebaseParkourSpotSearchService();
    _searchViewModel = ParkourSearchViewModel(searchService);
    _searchViewModel.addListener(_onSearchResultsChanged);

    // ViewModel 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ScratchMapViewModel>();

      // 콜백
      viewModel.onSpotMarkerTapped = (ParkourSpot spot) {
        _showCustomInfoWindow(spot);
        _showSpotBottomSheet(spot);
      };

      // 검색 초기화는 더 빠르게 처리
      _initializeSearchAsync();

      viewModel.initialize();
    });

    // Load map style JSON file
    rootBundle
        .loadString('assets/map_style/map_style.json')
        .then((style) {
      setState(() {
        _mapStyle = style;
      });
    })
        .catchError((e) {
      debugPrint('Map style load failed: $e');
    });
  }

  /// 검색 결과 변경 시 콜백
  void _onSearchResultsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// 검색 초기화 비동기 실행
  void _initializeSearchAsync() {
    Future.delayed(Duration.zero, () async {
      try {
        await _searchViewModel.initializeSearch().timeout(
          Duration(seconds: 3),
          onTimeout: () {
            print('검색 초기화 타임아웃, 계속 진행');
          },
        );
      } catch (e) {
        print('검색 초기화 실패, 계속 진행: $e');
      }
    });
  }

  /// 검색 실행
  void _performSearch(String query) {
    _searchViewModel.updateSearchQuery(query);
    _searchViewModel.searchSpots();
    setState(() {
      _showSearchResults = query.isNotEmpty;
    });
  }

  /// 표시할 마커 세트 결정
  Set<Marker> _getDisplayMarkers(ScratchMapViewModel viewModel) {
    if (_showSearchResults && _searchViewModel.searchResults.isNotEmpty) {
      // 검색 결과 마커 생성
      return _searchViewModel.searchResults.map((spot) {
        return Marker(
          markerId: MarkerId('search_${spot.documentId}'),
          position: spot.location,
          infoWindow: InfoWindow(title: spot.name, snippet: spot.address),
          icon: viewModel.customSpotMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _showCustomInfoWindow(spot);
            _showSpotBottomSheet(spot);
          },
        );
      }).toSet();
    }
    // 기본 마커 (기존 viewModel의 마커들)
    return viewModel.parkourMarkers;
  }

  /// 검색 결과 아이템 빌드
  Widget _buildSearchResultItem(ParkourSpot spot) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF3A59D1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.location_on, color: Color(0xFF3A59D1), size: 24),
      ),
      title: Text(
        spot.name,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (spot.address.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              spot.address,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  spot.category == 'park' ? '공원' : spot.category,
                  style: TextStyle(fontSize: 10, color: Colors.blue[700]),
                ),
              ),
              SizedBox(width: 4),
              if (spot.tags.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    spot.tags.first,
                    style: TextStyle(fontSize: 10, color: Colors.green[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // 스팟 클릭 시 바텀시트 표시
        _showSpotBottomSheet(spot);

        // 검색 결과 리스트 숨기기 (선택사항)
        // setState(() {
        //   _showSearchResults = false;
        // });
      },
    );
  }

  /// CustomInfoWindow 표시
  void _showCustomInfoWindow(ParkourSpot spot) {
    _customInfoWindowController.addInfoWindow!(
      _buildInfoWindowWidget(spot),
      spot.location,
    );
  }

  /// InfoWindow 위젯 생성
  Widget _buildInfoWindowWidget(ParkourSpot spot) {
    return Container(
      decoration: BoxDecoration(
        color: BrandColors.c800,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: SecondaryColors.c500Default, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              spot.displayName.isNotEmpty ? spot.displayName : spot.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BrandColors.txtWhite,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (spot.description.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                spot.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
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
  void dispose() {
    _searchViewModel.removeListener(_onSearchResultsChanged);
    _searchViewModel.dispose();
    _searchController.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScratchMapViewModel>(
        builder: (context, viewModel, child) {
          // 로딩 상태 처리
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
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
                onMapCreated: (controller) async {
                  mapController = controller;
                  _customInfoWindowController.googleMapController = controller;

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
                style: _mapStyle,

                // 🎯 마커 바인딩 (검색 결과가 있을 때는 검색 마커, 없을 때는 기본 마커)
                markers: _getDisplayMarkers(viewModel),

                polygons: viewModel.allPolygons,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,

                onTap: (LatLng position) {
                  print('지도 탭: ${position.latitude}, ${position.longitude}');
                  // 지도 탭 시 InfoWindow 숨기기
                  _customInfoWindowController.hideInfoWindow!();
                },

                onCameraMove: (CameraPosition position) {
                  // 카메라 이동 시 InfoWindow 업데이트
                  _customInfoWindowController.onCameraMove!();
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

              // Top gradation
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/map-gradation-top.png',
                  fit: BoxFit.fitWidth,
                ),
              ),

              // Bottom gradation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/map-gradation-bottom.png',
                  fit: BoxFit.fitWidth,
                ),
              ),

              // 1) Search bar (SafeArea + Align + Padding)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {});
                      },
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return Container(
                            width: 358,
                            height: 60,
                            decoration: ShapeDecoration(
                              color: BrandColors.c800,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  color: hasFocus ? SecondaryColors.c500Default : BrandColors.normal,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 16),
                                const Icon(Icons.search, color: SecondaryColors.c500Default, size: 32),

                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onSubmitted: _performSearch,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _showSearchResults = false;
                                        });
                                        _searchViewModel.clearSearch();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                if (_searchController.text.isNotEmpty)
                                  IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _showSearchResults = false;
                                      });
                                      _searchViewModel.clearSearch();
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // 검색 제안 (검색어 입력 중일 때)
              if (_searchViewModel.searchSuggestions.isNotEmpty &&
                  !_showSearchResults)
                Positioned(
                  top: 90,
                  left: 16,
                  right: 16,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchViewModel.searchSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion =
                        _searchViewModel.searchSuggestions[index];
                        return ListTile(
                          leading: Icon(Icons.search, size: 16),
                          title: Text(suggestion),
                          onTap: () {
                            _searchController.text = suggestion;
                            _searchViewModel.selectSearchSuggestion(suggestion);
                          },
                        );
                      },
                    ),
                  ),
                ),

              // 검색 결과 리스트 (검색 완료 후)
              if (_showSearchResults &&
                  _searchViewModel.searchResults.isNotEmpty)
                Positioned(
                  top: 90,
                  left: 16,
                  right: 16,
                  bottom: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 헤더
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Color(0xFF3A59D1)),
                              SizedBox(width: 8),
                              Text(
                                '검색 결과 ${_searchViewModel.searchResults.length}개',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3A59D1),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.close, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _showSearchResults = false;
                                  });
                                  _searchController.clear();
                                  _searchViewModel.clearSearch();
                                },
                              ),
                            ],
                          ),
                        ),
                        // 검색 결과 리스트
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchViewModel.searchResults.length,
                            itemBuilder: (context, index) {
                              final spot =
                              _searchViewModel.searchResults[index];
                              return _buildSearchResultItem(spot);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 검색 로딩 인디케이터
              if (_searchViewModel.isSearching)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(width: 12),
                          Text('검색 중...'),
                        ],
                      ),
                    ),
                  ),
                ),

              // 검색 결과 카운트
              if (_showSearchResults &&
                  !_searchViewModel.isSearching &&
                  _searchViewModel.searchResults.isNotEmpty)
                Positioned(
                  bottom: 50,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF3A59D1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      '검색 결과: ${_searchViewModel.searchResults.length}개',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // 2. Top-right: My Location Button - 검색 결과가 없을 때만 표시
              if (!_showSearchResults)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120, right: 16),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final newPosition = await viewModel.moveToCurrentLocation();
                              if (newPosition != null && mapController != null) {
                                await mapController!.animateCamera(
                                  CameraUpdate.newLatLng(newPosition),
                                );
                                print('현재 위치로 이동: \\${newPosition.latitude}, \\${newPosition.longitude}');
                              }
                            },
                            child: Center(
                              child: Image.asset(
                                'assets/images/button-compass.png',
                                width: 44,
                                height: 44,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 3. Bottom Center: Bookmark (left) - Main Scratch (center) - Person (right)
              if (!_showSearchResults)
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // LEFT: Bookmark
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  print('즐겨찾기 버튼 클릭');
                                },
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/button-bookmark.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // CENTER: Main Scratch button
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {
                                    _isScratched = !_isScratched;
                                  });
                                  await viewModel.toggleHexagons();
                                },
                                child: Center(
                                  child: Image.asset(
                                    _isScratched
                                        ? 'assets/images/button-scratch-hover.png'
                                        : 'assets/images/button-scratch.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // RIGHT: Person (my page)
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  print('프로필 버튼 클릭');
                                  context.goNamed('profile');
                                },
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/button-person.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                      color: Colors.black.withValues(alpha: 0.7),
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

              // CustomInfoWindow
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 55,
                width: 200,
                offset: 80,
              ),
            ],
          );
        },
      ),
    );
  }
}