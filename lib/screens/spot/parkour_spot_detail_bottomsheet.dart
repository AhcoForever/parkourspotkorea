import 'package:flutter/material.dart';
import '../../model/parkour_spot.dart';
import '../../services/googlePlaces_service.dart';

class ParkourSpotBottomSheet extends StatefulWidget {
  final ParkourSpot spot;
  final VoidCallback? onClose;

  const ParkourSpotBottomSheet({Key? key, required this.spot, this.onClose})
    : super(key: key);

  @override
  State<ParkourSpotBottomSheet> createState() => _ParkourSpotBottomSheetState();
}

class _ParkourSpotBottomSheetState extends State<ParkourSpotBottomSheet> {
  String? _placeImageUrl;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _loadPlaceImage();
  }

  /// 구글 Places API에서 장소 이미지 로드
  Future<void> _loadPlaceImage() async {
    try {
      // API 키가 설정되었는지 확인
      if (!GooglePlacesService.isConfigured) {
        print('⚠️ Google Places API 키가 설정되지 않았습니다');
        setState(() => _isLoadingImage = false);
        return;
      }

      // 장소 이름에서 키워드 추출
      final keywords = _extractSearchKeywords(widget.spot.name);

      String? imageUrl;

      // 여러 키워드로 시도
      for (final keyword in keywords) {
        imageUrl = await GooglePlacesService.searchPlacePhoto(
          location: widget.spot.location,
          keyword: keyword,
          radius: 200,
          // 200m 반경에서 검색
          maxWidth: 800,
          maxHeight: 500,
        );

        if (imageUrl != null) {
          print('✅ 장소 이미지 찾음: $keyword');
          break;
        }
      }

      if (mounted) {
        setState(() {
          _placeImageUrl = imageUrl;
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      print('❌ 장소 이미지 로드 실패: $e');
      if (mounted) {
        setState(() => _isLoadingImage = false);
      }
    }
  }

  /// 검색 키워드 추출 및 우선순위 정렬
  List<String> _extractSearchKeywords(String placeName) {
    final keywords = <String>[];

    // 원본 이름 (최우선)
    keywords.add(placeName);

    // 공통 키워드 제거하고 핵심만
    final cleaned = placeName
        .replaceAll('어린이공원', '공원')
        .replaceAll('근린공원', '공원')
        .replaceAll('체육공원', '공원')
        .replaceAll('문화공원', '공원');

    if (cleaned != placeName) {
      keywords.add(cleaned);
    }

    // 지역명 + 일반 키워드
    if (placeName.contains('공원')) {
      keywords.add('공원');
    }
    if (placeName.contains('학교') || placeName.contains('대학')) {
      keywords.add('학교');
    }
    if (placeName.contains('역')) {
      keywords.add('역');
    }

    return keywords.take(3).toList(); // 최대 3개까지만
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          _buildDragHandle(),

          // 메인 컨텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 정보
                  _buildHeaderSection(),

                  SizedBox(height: 16),

                  // 이미지 섹션
                  _buildImageSection(),
                  SizedBox(height: 16),

                  // 상세 정보
                  _buildDetailSection(),

                  SizedBox(height: 20),

                  // 액션 버튼들
                  _buildActionButtons(context),

                  // 하단 여백
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildSpotImage(),
      ),
    );
  }

  Widget _buildSpotImage() {
    // 로딩 중일 때
    if (_isLoadingImage) {
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '장소 이미지 로딩 중...',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // 이미지 우선순위: 파이어스토어 URL > 구글 Places 이미지 > 기본 이미지
    if (widget.spot.imageUrls.isNotEmpty) {
      return Image.network(
        widget.spot.imageUrls.first,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Firestore 이미지 로드 실패, Places 이미지 시도');
          return _buildGoogleImage();
        },
      );
    }

    return _buildGoogleImage();
  }

  /// 구글 Places/Street View 이미지 표시
  Widget _buildGoogleImage() {
    if (_placeImageUrl != null) {
      return Stack(
        children: [
          // Places 이미지
          Image.network(
            _placeImageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('❌ Places 이미지 로드 실패, 기본 이미지 표시');
              return _buildDefaultImage();
            },
          ),

          // Google 로고/출처 표시
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(179),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _buildDefaultImage();
  }

  /// 기본 플레이스홀더 이미지
  Widget _buildDefaultImage() {
    return Container(
      color: Colors.blue[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(widget.spot.category),
            size: 48,
            color: Colors.blue[300],
          ),
          SizedBox(height: 8),
          Text(
            _getCategoryText(widget.spot.category),
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 스팟 이름
        Text(
          widget.spot.displayName.isNotEmpty
              ? widget.spot.displayName
              : widget.spot.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 4),

        // 주소
        if (widget.spot.address.isNotEmpty)
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.spot.address,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),

        SizedBox(height: 8),

        // 태그들
        if (widget.spot.tags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.spot.tags.take(3).map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 난이도
        _buildDetailRow(
          icon: Icons.fitness_center,
          label: '난이도',
          value: _getDifficultyText(widget.spot.difficulty),
          valueColor: _getDifficultyColor(widget.spot.difficulty),
        ),

        SizedBox(height: 12),

        // 카테고리
        _buildDetailRow(
          icon: Icons.category,
          label: '카테고리',
          value: _getCategoryText(widget.spot.category),
        ),

        SizedBox(height: 12),

        // 좌표 정보
        _buildDetailRow(
          icon: Icons.map,
          label: '좌표',
          value:
              '${widget.spot.location.latitude.toStringAsFixed(6)}, ${widget.spot.location.longitude.toStringAsFixed(6)}',
        ),

        // 설명 (있는 경우)
        if (widget.spot.description.isNotEmpty) ...[
          SizedBox(height: 16),
          Text(
            '설명',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.spot.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 길찾기 버튼
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _openDirections(),
            icon: Icon(Icons.directions),
            label: Text('길찾기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: 12),

        // 추가 액션 버튼들
        Row(
          children: [
            // 즐겨찾기
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _toggleBookmark(),
                icon: Icon(Icons.favorite_border),
                label: Text('즐겨찾기'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // 공유
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareSpot(),
                icon: Icon(Icons.share),
                label: Text('공유'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // === 헬퍼 메서드들 ===

  /// 카테고리별 아이콘
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'park':
        return Icons.park;
      case 'school':
        return Icons.school;
      case 'parkour_gym':
        return Icons.fitness_center;
      case 'gym':
        return Icons.sports_gymnastics;
      case 'plaza':
        return Icons.location_city;
      case 'bridge':
        return Icons.line_weight;
      default:
        return Icons.location_on;
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '초급';
      case 'intermediate':
        return '중급';
      case 'advanced':
        return '고급';
      default:
        return '중급';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'park':
        return '공원';
      case 'school':
        return '학교';
      case 'parkour_gym':
        return '파쿠르짐';
      case 'gym':
        return '체육시설';
      case 'plaza':
        return '광장';
      case 'bridge':
        return '다리';
      default:
        return '일반 스팟';
    }
  }

  // === 액션 메서드들 ===

  void _openDirections() {
    // TODO: Google Maps 앱으로 길찾기 열기
    print(
      '🗺️ 길찾기: ${widget.spot.location.latitude}, ${widget.spot.location.longitude}',
    );
  }

  void _toggleBookmark() {
    // TODO: 즐겨찾기 토글
    print('⭐ 즐겨찾기: ${widget.spot.name}');
  }

  void _shareSpot() {
    // TODO: 스팟 정보 공유
    print('📤 공유: ${widget.spot.name}');
  }
}

/// Bottom Sheet 표시용 헬퍼 함수
class ParkourBottomSheetHelper {
  static Future<void> show(
    BuildContext context,
    ParkourSpot spot, {
    VoidCallback? onClose,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,

      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        snap: true,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) {
          return ParkourSpotBottomSheet(spot: spot, onClose: onClose);
        },
      ),
    ).then((_) {
      onClose?.call();
    });
  }
}
