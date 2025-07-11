// lib/map_search_detail.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSearchDetailPage extends StatefulWidget {
  @override
  _MapSearchDetailPageState createState() => _MapSearchDetailPageState();
}

class _MapSearchDetailPageState extends State<MapSearchDetailPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse) {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = LatLng(pos.latitude, pos.longitude));
    }
  }

  void _onSearchSubmitted(String keyword) {
    // TODO: 실제 Places API 로 검색 → 위치/상세데이터 가져오기
    _showPlaceDetailSheet();
  }

  void _showPlaceDetailSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollCtrl) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 드래그 핸들
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // 제목 · 별점 · 공유/닫기
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '롯데월드타워',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                              (i) => Icon(Icons.star, color: Colors.amber, size: 20),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 경로 · 버디 찾기
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.directions, color: Colors.white),
                        label: Text('경로', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('버디 찾기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 사진 그리드 (각 영역 탭 시 확대)
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        // 큰 사진
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => _showPhotoDialog('큰 사진 확대'),
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueAccent, width: 2),
                              ),
                              child: Center(child: Text('사진')),
                            ),
                          ),
                        ),
                        // 옆 작은 사진 2개
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showPhotoDialog('작은 사진 1 확대'),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(child: Text('사진')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showPhotoDialog('작은 사진 2 확대'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(child: Text('사진')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // 장소 리뷰 헤더 (버튼)
                  InkWell(
                    onTap: () {
                      // TODO: 리뷰 페이지로 이동
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            '장소 리뷰',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  // 샘플 리뷰 (필요 시 ListView로 확장)
                  Text('보라돌이', style: TextStyle(fontSize: 16, color: Colors.blue)),
                  SizedBox(height: 4),
                  Text('서울의 랜드마크! 파쿠르 맛집!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 사진 확대용 다이얼로그
  void _showPhotoDialog(String label) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + 16;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? LatLng(37.5665, 126.9780),
              zoom: 14,
            ),
            onMapCreated: (c) => _mapController = c,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: topPad,
            left: 16,
            right: 16,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: '장소를 검색하세요',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
