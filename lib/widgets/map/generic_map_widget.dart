// lib/widgets/map/generic_map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import '../../model/map_marker_data.dart';
import 'map_location_service.dart';

/// 범용 지도 위젯
///
/// GoogleMap + 마커 + 내 위치 기능을 포함한 재사용 가능한 지도 위젯
/// ParkourSpot 같은 특정 도메인 의존성 없이 어떤 프로젝트에서도 사용 가능
class GenericMapWidget extends StatefulWidget {
  /// 초기 카메라 위치 (null이면 현재 위치 사용)
  final LatLng? initialPosition;

  /// 초기 줌 레벨 (기본값 15)
  final double initialZoom;

  /// 표시할 마커 데이터 리스트
  final List<MapMarkerData> markers;

  /// 지도 스타일 JSON 파일 경로 (선택사항)
  /// 예: 'assets/map_style/map_style.json'
  final String? mapStyleJsonPath;

  /// 커스텀 마커 아이콘 (null이면 기본 마커)
  final BitmapDescriptor? customMarkerIcon;

  /// 마커 클릭 시 InfoWindow 내용 빌더 (선택사항)
  final Widget Function(MapMarkerData data)? infoWindowBuilder;

  /// 마커 클릭 시 BottomSheet 내용 빌더 (선택사항)
  final Widget Function(BuildContext context, MapMarkerData data)?
      bottomSheetBuilder;

  /// 마커 클릭 콜백 (선택사항)
  final void Function(MapMarkerData data)? onMarkerTap;

  /// 카메라 이동 콜백 (선택사항)
  final void Function(LatLng position)? onCameraMove;

  /// 지도 탭 콜백 (선택사항)
  final void Function(LatLng position)? onMapTap;

  /// 내 위치 버튼 표시 여부 (기본값 true)
  final bool showMyLocationButton;

  /// 내 위치 표시 여부 (기본값 true)
  final bool showMyLocation;

  /// InfoWindow 높이 (기본값 100)
  final double infoWindowHeight;

  /// InfoWindow 너비 (기본값 200)
  final double infoWindowWidth;

  /// InfoWindow 오프셋 (기본값 50)
  final double infoWindowOffset;

  const GenericMapWidget({
    super.key,
    this.initialPosition,
    this.initialZoom = 15.0,
    required this.markers,
    this.mapStyleJsonPath,
    this.customMarkerIcon,
    this.infoWindowBuilder,
    this.bottomSheetBuilder,
    this.onMarkerTap,
    this.onCameraMove,
    this.onMapTap,
    this.showMyLocationButton = true,
    this.showMyLocation = true,
    this.infoWindowHeight = 100.0,
    this.infoWindowWidth = 200.0,
    this.infoWindowOffset = 50.0,
  });

  @override
  State<GenericMapWidget> createState() => _GenericMapWidgetState();
}

class _GenericMapWidgetState extends State<GenericMapWidget> {
  GoogleMapController? _mapController;
  String? _mapStyle;
  LatLng? _currentPosition;
  bool _isLoading = true;
  final CustomInfoWindowController _infoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  /// 지도 초기화
  Future<void> _initializeMap() async {
    setState(() => _isLoading = true);

    // 지도 스타일 로드
    if (widget.mapStyleJsonPath != null) {
      try {
        _mapStyle = await rootBundle.loadString(widget.mapStyleJsonPath!);
      } catch (e) {
        print('지도 스타일 로드 실패: $e');
      }
    }

    // 초기 위치 설정
    if (widget.initialPosition != null) {
      _currentPosition = widget.initialPosition;
    } else {
      // 현재 위치 가져오기 (타임아웃 5초, 실패 시 서울시청)
      _currentPosition = await MapLocationService.getCurrentLocationWithTimeout(
        timeoutSeconds: 5,
        fallbackPosition: const LatLng(37.5665, 126.9780), // 서울시청
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// 마커 생성
  Set<Marker> _buildMarkers() {
    return widget.markers.map((data) {
      return Marker(
        markerId: MarkerId(data.id),
        position: data.position,
        icon: widget.customMarkerIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow.noText, // CustomInfoWindow 사용
        onTap: () => _onMarkerTapped(data),
      );
    }).toSet();
  }

  /// 마커 클릭 처리
  void _onMarkerTapped(MapMarkerData data) {
    print('마커 클릭: ${data.title}');

    // InfoWindow 표시
    if (widget.infoWindowBuilder != null) {
      _infoWindowController.addInfoWindow!(
        widget.infoWindowBuilder!(data),
        data.position,
      );
    }

    // BottomSheet 표시
    if (widget.bottomSheetBuilder != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return widget.bottomSheetBuilder!(context, data);
          },
        ),
      );
    }

    // 외부 콜백
    widget.onMarkerTap?.call(data);
  }

  /// 현재 위치로 이동
  Future<void> _moveToCurrentLocation() async {
    final location = await MapLocationService.getCurrentLocation();
    if (location != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(location),
      );
      setState(() => _currentPosition = location);
      print('현재 위치로 이동: ${location.latitude}, ${location.longitude}');
    } else {
      print('현재 위치를 가져올 수 없습니다');
      // 권한 요청 실패 시 설정으로 이동할지 물어볼 수도 있음
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한이 필요합니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            _infoWindowController.googleMapController = controller;

            // 지도 스타일 적용
            if (_mapStyle != null) {
              controller.setMapStyle(_mapStyle);
            }
          },
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: widget.initialZoom,
          ),
          markers: _buildMarkers(),
          myLocationEnabled: widget.showMyLocation,
          myLocationButtonEnabled: false, // 커스텀 버튼 사용
          onTap: (position) {
            // InfoWindow 숨기기
            _infoWindowController.hideInfoWindow!();
            // 외부 콜백
            widget.onMapTap?.call(position);
          },
          onCameraMove: (position) {
            // InfoWindow 위치 업데이트
            _infoWindowController.onCameraMove!();
            // 외부 콜백
            widget.onCameraMove?.call(position.target);
          },
        ),

        // CustomInfoWindow
        if (widget.infoWindowBuilder != null)
          CustomInfoWindow(
            controller: _infoWindowController,
            height: widget.infoWindowHeight,
            width: widget.infoWindowWidth,
            offset: widget.infoWindowOffset,
          ),

        // 내 위치 버튼
        if (widget.showMyLocationButton)
          Positioned(
            top: 100,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: _moveToCurrentLocation,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _infoWindowController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
