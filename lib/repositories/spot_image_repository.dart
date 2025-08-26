import 'dart:async';

import '../model/parkour_spot.dart';
import '../model/spot_image.dart';
import '../services/googlePlaces_service.dart';

abstract class SpotImageRepository {
  Future<SpotImageModel> loadSpotImage({
    required ParkourSpot spot,
    int radius = 200,
  });
}

class GooglePlacesSpotImageRepository implements SpotImageRepository {
  static const int defaultImageWidth = 800;
  static const int defaultImageHeight = 500;

  @override
  Future<SpotImageModel> loadSpotImage({
    required ParkourSpot spot,
    int radius = 200,
  }) async {
    try {
      // API 설정 확인
      if (!GooglePlacesService.isConfigured) {
        return SpotImageModel.notConfigured();
      }

      // 키워드 추출
      final keywords = _extractSearchKeywords(spot.name);

      // 각 키워드로 이미지 검색
      for (final keyword in keywords) {
        final imageUrl = await GooglePlacesService.searchPlacePhoto(
          location: spot.location,
          keyword: keyword,
          radius: radius,
          maxWidth: defaultImageWidth,
          maxHeight: defaultImageHeight,
        );

        if (imageUrl != null) {
          return SpotImageModel.success(imageUrl, keyword);
        }
      }

      return SpotImageModel.notFound();
    } catch (e) {
      return SpotImageModel.error(e.toString());
    }
  }

  List<String> _extractSearchKeywords(String placeName) {
    final keywords = <String>[];

    // 원본 이름 추가
    keywords.add(placeName);

    // 공통 키워드 정리
    final cleaned = placeName
        .replaceAll('어린이공원', '공원')
        .replaceAll('근린공원', '공원')
        .replaceAll('체육공원', '공원')
        .replaceAll('문화공원', '공원');

    if (cleaned != placeName) {
      keywords.add(cleaned);
    }

    // 카테고리별 키워드 추가
    if (placeName.contains('공원')) keywords.add('공원');
    if (placeName.contains('학교') || placeName.contains('대학')) keywords.add('학교');
    if (placeName.contains('역')) keywords.add('역');

    return keywords.take(3).toList();
  }
}