// lib/screens/mapsearch_page.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkourspotkorea/viewmodel/parkour_search_viewmodel.dart';
import 'package:parkourspotkorea/model/parkour_spot.dart';
import 'package:parkourspotkorea/services/firebase/parkour_spot_search_service.dart';

class MapSearchDetailPage extends StatefulWidget {
  const MapSearchDetailPage({super.key});
  
  @override
  State<MapSearchDetailPage> createState() => _MapSearchDetailPageState();
}

class _MapSearchDetailPageState extends State<MapSearchDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  late ParkourSearchViewModel _searchViewModel;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeSearch();
  }

  void _initializeSearch() {
    final searchService = FirebaseParkourSpotSearchService();
    _searchViewModel = ParkourSearchViewModel(searchService);
    _searchViewModel.addListener(_onSearchResultsChanged);
    _searchViewModel.initializeSearch();
  }

  void _onSearchResultsChanged() {
    if (mounted) {
      _updateMapMarkers();
      setState(() {});
    }
  }

  void _updateMapMarkers() {
    _markers.clear();
    for (final spot in _searchViewModel.searchResults) {
      _markers.add(
        Marker(
          markerId: MarkerId(spot.documentId),
          position: spot.location,
          infoWindow: InfoWindow(
            title: spot.name,
            snippet: spot.address,
          ),
          onTap: () => _showSpotDetailSheet(spot),
        ),
      );
    }
  }

  void _onSearchSubmitted(String keyword) {
    _searchViewModel.updateSearchQuery(keyword);
    _searchViewModel.searchSpots();
  }

  void _showSpotDetailSheet(ParkourSpot spot) {
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

                  // 제목과 별점
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spot.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (spot.rating != null) ...[
                        Row(
                          children: List.generate(5, (i) => Icon(
                            Icons.star,
                            color: i < (spot.rating ?? 0).round() ? Colors.amber : Colors.grey[300],
                            size: 20,
                          )),
                        ),
                        SizedBox(width: 8),
                        Text(
                          spot.rating?.toStringAsFixed(1) ?? '0',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  
                  // 주소
                  if (spot.address.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      spot.address,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                  
                  // 카테고리와 난이도
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _searchViewModel.getCategoryLabel(spot.category),
                          style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _searchViewModel.getDifficultyLabel(spot.difficulty),
                          style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 액션 버튼들
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.directions, color: Colors.white),
                        label: Text('길찾기', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border),
                        label: Text('저장'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),

                  // 설명
                  if (spot.description.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      '설명',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      spot.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],

                  // 태그들
                  if (spot.tags.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: spot.tags.map((tag) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Text(
                  '필터',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    _searchViewModel.clearFilters();
                    Navigator.pop(context);
                  },
                  child: Text('초기화'),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            
            Divider(),
            
            // 카테고리
            Text('카테고리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ParkourSearchViewModel.categories.map((category) {
                final isSelected = _searchViewModel.selectedCategory == category;
                return FilterChip(
                  label: Text(_searchViewModel.getCategoryLabel(category)),
                  selected: isSelected,
                  onSelected: (selected) {
                    _searchViewModel.setCategory(selected ? category : null);
                    setState(() {});
                  },
                );
              }).toList(),
            ),
            
            SizedBox(height: 16),
            
            // 난이도
            Text('난이도', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ParkourSearchViewModel.difficulties.map((difficulty) {
                final isSelected = _searchViewModel.selectedDifficulty == difficulty;
                return FilterChip(
                  label: Text(_searchViewModel.getDifficultyLabel(difficulty)),
                  selected: isSelected,
                  onSelected: (selected) {
                    _searchViewModel.setDifficulty(selected ? difficulty : null);
                    setState(() {});
                  },
                );
              }).toList(),
            ),
            
            SizedBox(height: 16),
            
            // 최소 평점
            Text('최소 평점', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Slider(
              value: _searchViewModel.minRating ?? 0.0,
              max: 5.0,
              divisions: 10,
              label: (_searchViewModel.minRating ?? 0.0).toStringAsFixed(1),
              onChanged: (value) {
                _searchViewModel.setMinRating(value > 0 ? value : null);
                setState(() {});
              },
            ),
            
            SizedBox(height: 16),
            
            // 최대 거리
            Text('최대 거리: ${_searchViewModel.maxDistance.toStringAsFixed(1)}km',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Slider(
              value: _searchViewModel.maxDistance,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              onChanged: (value) {
                _searchViewModel.setMaxDistance(value);
                setState(() {});
              },
            ),
          ],
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
              target: _searchViewModel.userLocation ?? LatLng(37.5665, 126.9780),
              zoom: 14,
            ),
            onMapCreated: (c) {},
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          
          // 검색 바
          Positioned(
            top: topPad,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _onSearchSubmitted,
                      decoration: InputDecoration(
                        hintText: '파쿠르 스팟을 검색하세요',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune, color: Colors.grey),
                    onPressed: _showFilterSheet,
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _searchViewModel.clearSearch();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // 검색 제안
          if (_searchViewModel.searchSuggestions.isNotEmpty)
            Positioned(
              top: topPad + 60,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchViewModel.searchSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _searchViewModel.searchSuggestions[index];
                    return ListTile(
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
          
          // 로딩 인디케이터
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
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
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
            
          // 결과 카운트
          if (!_searchViewModel.isSearching && _searchViewModel.searchResults.isNotEmpty)
            Positioned(
              bottom: 50,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Text(
                  '${_searchViewModel.searchResults.length}개의 스팟',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchViewModel.removeListener(_onSearchResultsChanged);
    _searchViewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
