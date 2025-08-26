import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/parkour_spot.dart';

abstract class SpotActionRepository {
  Future<bool> openDirections(double latitude, double longitude);

  Future<bool> toggleBookmark(String spotDocumentId);

  Future<bool> shareSpot(ParkourSpot spot);
}

class DefaultSpotActionRepository implements SpotActionRepository {
  @override
  Future<bool> openDirections(double latitude, double longitude) async {
    try {
      // Google Maps 앱으로 길찾기
      final googleMapsUrl = 'google.navigation:q=$latitude,$longitude';
      final fallbackUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

      // url_launcher 패키지 사용
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
        return true;
      } else if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
        await launchUrl(Uri.parse(fallbackUrl));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('길찾기 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> toggleBookmark(String spotDocumentId) async {
    try {
      // TODO: 실제 즐겨찾기 API 호출
      debugPrint('⭐ 즐겨찾기 토글: $spotDocumentId');
      // await bookmarkService.toggle(spotId);
      return true;
    } catch (e) {
      debugPrint('즐겨찾기 실패: $e');
      return false;
    }
  }

  @override
  Future<bool> shareSpot(ParkourSpot spot) async {
    try {
      // TODO: 실제 공유 기능 구현
      final shareText =
          '''
${spot.displayName.isNotEmpty ? spot.displayName : spot.name}
${spot.address}
https://maps.google.com/?q=${spot.location.latitude},${spot.location.longitude}
''';
      debugPrint('📤 공유: $shareText');
      // await Share.share(shareText);
      return true;
    } catch (e) {
      debugPrint('공유 실패: $e');
      return false;
    }
  }
}
