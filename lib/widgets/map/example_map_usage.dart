// lib/widgets/map/example_map_usage.dart
// 이 파일은 GenericMapWidget 사용 예시입니다
// 실제 프로젝트에서는 이 파일을 복사하지 않고 참고만 하세요

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/map_marker_data.dart';
import 'generic_map_widget.dart';

/// GenericMapWidget 사용 예시 1: 기본 사용
class BasicMapExample extends StatelessWidget {
  const BasicMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    // 예시 마커 데이터
    final markers = [
      MapMarkerData(
        id: '1',
        title: '서울시청',
        subtitle: '대한민국 서울특별시',
        position: const LatLng(37.5665, 126.9780),
      ),
      MapMarkerData(
        id: '2',
        title: '남산타워',
        subtitle: '서울의 랜드마크',
        position: const LatLng(37.5512, 126.9882),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('기본 지도 예시')),
      body: GenericMapWidget(
        markers: markers,
        // 마커 클릭 시 콘솔 출력
        onMarkerTap: (data) => print('마커 클릭: ${data.title}'),
      ),
    );
  }
}

/// GenericMapWidget 사용 예시 2: InfoWindow + BottomSheet 커스터마이징
class CustomizedMapExample extends StatelessWidget {
  const CustomizedMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    final markers = [
      MapMarkerData(
        id: '1',
        title: '카페 A',
        subtitle: '맛있는 커피',
        position: const LatLng(37.5665, 126.9780),
        extraData: {
          'rating': 4.5,
          'imageUrl': 'https://example.com/cafe-a.jpg',
          'category': 'cafe',
        },
      ),
      MapMarkerData(
        id: '2',
        title: '레스토랑 B',
        subtitle: '훌륭한 요리',
        position: const LatLng(37.5512, 126.9882),
        extraData: {
          'rating': 4.8,
          'imageUrl': 'https://example.com/restaurant-b.jpg',
          'category': 'restaurant',
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('커스터마이징 지도 예시')),
      body: GenericMapWidget(
        markers: markers,
        initialZoom: 13,

        // InfoWindow 커스터마이징
        infoWindowBuilder: (data) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (data.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.subtitle!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
                if (data.extraData?['rating'] != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${data.extraData!['rating']}'),
                    ],
                  ),
                ],
              ],
            ),
          );
        },

        // BottomSheet 커스터마이징
        bottomSheetBuilder: (context, data) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 드래그 핸들
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 제목
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 부제목
                if (data.subtitle != null)
                  Text(
                    data.subtitle!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                const SizedBox(height: 16),

                // 평점
                if (data.extraData?['rating'] != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${data.extraData!['rating']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // 카테고리
                if (data.extraData?['category'] != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.extraData!['category'],
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                const SizedBox(height: 20),

                // 버튼들
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // 길찾기 기능 구현
                          print('길찾기: ${data.title}');
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('길찾기'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('닫기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },

        // 마커 클릭 콜백
        onMarkerTap: (data) {
          print('마커 클릭: ${data.title}');
        },
      ),
    );
  }
}

/// GenericMapWidget 사용 예시 3: 지도 스타일 + 커스텀 마커 아이콘
class StyledMapExample extends StatefulWidget {
  const StyledMapExample({super.key});

  @override
  State<StyledMapExample> createState() => _StyledMapExampleState();
}

class _StyledMapExampleState extends State<StyledMapExample> {
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
  }

  Future<void> _loadCustomIcon() async {
    try {
      final icon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/custom-marker.png',
      );
      setState(() => _customIcon = icon);
    } catch (e) {
      print('커스텀 아이콘 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = [
      MapMarkerData(
        id: '1',
        title: '위치 1',
        position: const LatLng(37.5665, 126.9780),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('스타일 지도 예시')),
      body: GenericMapWidget(
        markers: markers,
        // 지도 스타일 적용
        mapStyleJsonPath: 'assets/map_style/map_style.json',
        // 커스텀 마커 아이콘
        customMarkerIcon: _customIcon,
      ),
    );
  }
}

/// GenericMapWidget 사용 예시 4: 실시간 데이터 업데이트
class DynamicMapExample extends StatefulWidget {
  const DynamicMapExample({super.key});

  @override
  State<DynamicMapExample> createState() => _DynamicMapExampleState();
}

class _DynamicMapExampleState extends State<DynamicMapExample> {
  List<MapMarkerData> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    // 실제로는 API에서 데이터를 가져옴
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _markers = [
        MapMarkerData(
          id: '1',
          title: '동적 마커 1',
          position: const LatLng(37.5665, 126.9780),
        ),
        MapMarkerData(
          id: '2',
          title: '동적 마커 2',
          position: const LatLng(37.5512, 126.9882),
        ),
      ];
    });
  }

  void _addRandomMarker() {
    setState(() {
      _markers.add(
        MapMarkerData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '새 마커 ${_markers.length + 1}',
          position: LatLng(
            37.5665 + (DateTime.now().millisecond % 100) / 10000,
            126.9780 + (DateTime.now().millisecond % 100) / 10000,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('동적 지도 예시')),
      body: _markers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GenericMapWidget(markers: _markers),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRandomMarker,
        child: const Icon(Icons.add_location),
      ),
    );
  }
}
