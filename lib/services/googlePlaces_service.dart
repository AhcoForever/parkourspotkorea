// lib/services/google_places_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GooglePlacesService {
  static String get _apiKey => dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  // Places API 기본 URL들
  static const String _nearbySearchUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String _photoUrl = 'https://maps.googleapis.com/maps/api/place/photo';
  static const String _detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';

  /// 위치 기반으로 장소 검색 후 사진 URL 반환
  static Future<String?> getPlacePhotoUrl({
    required LatLng location,
    required String placeName,
    int maxWidth = 400,
    int maxHeight = 300,
  }) async {
    try {
      // 1. 근처 장소 검색
      final placeId = await _findPlaceId(location, placeName);
      if (placeId == null) {
        print('⚠️ 장소를 찾을 수 없습니다: $placeName');
        return null;
      }

      // 2. Place Details로 사진 정보 가져오기
      final photoReference = await _getPhotoReference(placeId);
      if (photoReference == null) {
        print('⚠️ 사진을 찾을 수 없습니다: $placeName');
        return _getStreetViewUrl(location); // 대체: 스트리트뷰
      }

      // 3. 사진 URL 생성
      final photoUrl = _buildPhotoUrl(
        photoReference,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      print('✅ 장소 사진 URL 생성: $placeName');
      return photoUrl;

    } catch (e) {
      print('❌ Places API 오류: $e');
      return _getStreetViewUrl(location); // 대체: 스트리트뷰
    }
  }

  /// 근처 장소 검색으로 Place ID 찾기
  static Future<String?> _findPlaceId(LatLng location, String placeName) async {
    try {
      final url = '$_nearbySearchUrl?'
          'location=${location.latitude},${location.longitude}&'
          'radius=100&'  // 100m 반경
          'keyword=${Uri.encodeComponent(placeName)}&'
          'language=ko&'
          'key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Places API 요청 실패: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['status'] != 'OK' || (data['results'] as List).isEmpty) {
        return null;
      }

      // 가장 가까운 결과의 place_id 반환
      final firstResult = (data['results'] as List).first;
      return firstResult['place_id'] as String?;

    } catch (e) {
      print('❌ Place ID 검색 실패: $e');
      return null;
    }
  }

  /// Place Details로 사진 참조 가져오기
  static Future<String?> _getPhotoReference(String placeId) async {
    try {
      final url = '$_detailsUrl?'
          'place_id=$placeId&'
          'fields=photos&'  // 사진 정보만 요청
          'language=ko&'
          'key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Place Details 요청 실패: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['status'] != 'OK') {
        return null;
      }

      final result = data['result'];
      final photos = result['photos'] as List<dynamic>?;

      if (photos == null || photos.isEmpty) {
        return null;
      }

      // 첫 번째 사진의 photo_reference 반환
      return photos.first['photo_reference'] as String?;

    } catch (e) {
      print('❌ Photo Reference 가져오기 실패: $e');
      return null;
    }
  }

  /// Photo URL 빌드
  static String _buildPhotoUrl(
      String photoReference, {
        int maxWidth = 400,
        int maxHeight = 300,
      }) {
    return '$_photoUrl?'
        'maxwidth=$maxWidth&'
        'maxheight=$maxHeight&'
        'photo_reference=$photoReference&'
        'key=$_apiKey';
  }

  /// Street View 이미지 URL (대체용)
  static String _getStreetViewUrl(
      LatLng location, {
        int size = 400,
        int heading = 0,  // 방향 (0-360도)
        int pitch = 0,    // 상하각 (-90~90도)
      }) {
    return 'https://maps.googleapis.com/maps/api/streetview?'
        'size=${size}x${(size * 0.6).toInt()}&'  // 16:10 비율
        'location=${location.latitude},${location.longitude}&'
        'heading=$heading&'
        'pitch=$pitch&'
        'fov=90&'  // 시야각
        'key=$_apiKey';
  }

  /// 키워드로 장소 사진 검색 (더 넓은 반경)
  static Future<String?> searchPlacePhoto({
    required LatLng location,
    required String keyword,
    int radius = 500,  // 검색 반경 (미터)
    int maxWidth = 400,
    int maxHeight = 300,
  }) async {
    try {
      final url = '$_nearbySearchUrl?'
          'location=${location.latitude},${location.longitude}&'
          'radius=$radius&'
          'keyword=${Uri.encodeComponent(keyword)}&'
          'type=point_of_interest&'  // 관심 지점만
          'language=ko&'
          'key=$_apiKey';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] != 'OK' || (data['results'] as List).isEmpty) {
        return _getStreetViewUrl(location);
      }

      // 각 결과에서 사진이 있는 것 찾기
      for (final result in data['results']) {
        final placeId = result['place_id'] as String?;
        if (placeId != null) {
          final photoReference = await _getPhotoReference(placeId);
          if (photoReference != null) {
            return _buildPhotoUrl(
              photoReference,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            );
          }
        }
      }

      return _getStreetViewUrl(location);
    } catch (e) {
      print('❌ 장소 사진 검색 실패: $e');
      return _getStreetViewUrl(location);
    }
  }

  /// API 키 설정 체크
  static bool get isConfigured => _apiKey != 'YOUR_GOOGLE_PLACES_API_KEY_HERE';

  /// 다양한 각도의 Street View 이미지들
  static List<String> getStreetViewImages(
      LatLng location, {
        int size = 400,
        List<int> headings = const [0, 90, 180, 270],  // 4방향
      }) {
    return headings.map((heading) => _getStreetViewUrl(
      location,
      size: size,
      heading: heading,
    )).toList();
  }
}

/// Places API 응답 모델
class PlacePhoto {
  final String photoReference;
  final int width;
  final int height;
  final List<String> attributions;

  PlacePhoto({
    required this.photoReference,
    required this.width,
    required this.height,
    required this.attributions,
  });

  factory PlacePhoto.fromJson(Map<String, dynamic> json) {
    return PlacePhoto(
      photoReference: json['photo_reference'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      attributions: (json['html_attributions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  /// 이 사진의 URL 생성
  String getUrl({int maxWidth = 400, int maxHeight = 300}) {
    return GooglePlacesService._buildPhotoUrl(
      photoReference,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }
}