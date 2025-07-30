import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 앱 전체에서 사용되는 상수들
class AppConstants {
  // 한국 지도 범위
  static const double KOREA_MIN_LAT = 33.0;
  static const double KOREA_MAX_LAT = 39.0;
  static const double KOREA_MIN_LNG = 124.0;
  static const double KOREA_MAX_LNG = 132.0;

  // 대한민국 중심 좌표
  static const LatLng KOREA_CENTER = LatLng(36.5, 127.5);
  static const double KOREA_DEFAULT_ZOOM = 7.0;

  // 육각형 그리드 크기 (약 1km)
  static const double HEX_GRID_SIZE = 0.01;

  // 위치 업데이트 설정
  static const double LOCATION_UPDATE_DISTANCE = 50.0; // 미터
  static const Duration LOCATION_UPDATE_INTERVAL = Duration(seconds: 30);

  // 데이터베이스 설정
  static const String DATABASE_NAME = 'korea_scratch_map.db';
  static const int DATABASE_VERSION = 1;
  static const int LOCATION_HISTORY_RETENTION_DAYS = 90; // 90일간 보관

  static const Color visitedStrokeColor = Colors.green;
  static const Color unvisitedStrokeColor = Colors.blue;
  static const Color unvisitedFillColor = Colors.purple;
  static const double visitedStrokeWidth = 2.0;
  static const double unvisitedStrokeWidth = 1.0;
  static const double unvisitedOpacity = 0.4;

  // 애니메이션 시간
  static const Duration mapAnimationDuration = Duration(milliseconds: 500);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

/// 지역별 정보
class KoreaRegions {
  static const Map<String, RegionInfo> regions = {
    '서울특별시': RegionInfo(
      code: '11',
      shortName: '서울',
      emoji: '🏛️',
      subRegionCount: 25, // 25개 구
    ),
    '부산광역시': RegionInfo(
      code: '26',
      shortName: '부산',
      emoji: '🌊',
      subRegionCount: 16,
    ),
    '대구광역시': RegionInfo(
      code: '27',
      shortName: '대구',
      emoji: '🍎',
      subRegionCount: 8,
    ),
    '인천광역시': RegionInfo(
      code: '28',
      shortName: '인천',
      emoji: '✈️',
      subRegionCount: 10,
    ),
    '광주광역시': RegionInfo(
      code: '29',
      shortName: '광주',
      emoji: '💡',
      subRegionCount: 5,
    ),
    '대전광역시': RegionInfo(
      code: '30',
      shortName: '대전',
      emoji: '🔬',
      subRegionCount: 5,
    ),
    '울산광역시': RegionInfo(
      code: '31',
      shortName: '울산',
      emoji: '🏭',
      subRegionCount: 5,
    ),
    '세종특별자치시': RegionInfo(
      code: '36',
      shortName: '세종',
      emoji: '🏤',
      subRegionCount: 1,
    ),
    '경기도': RegionInfo(
      code: '41',
      shortName: '경기',
      emoji: '🏘️',
      subRegionCount: 31,
    ),
    '강원도': RegionInfo(
      code: '42',
      shortName: '강원',
      emoji: '⛰️',
      subRegionCount: 18,
    ),
    '충청북도': RegionInfo(
      code: '43',
      shortName: '충북',
      emoji: '🌳',
      subRegionCount: 11,
    ),
    '충청남도': RegionInfo(
      code: '44',
      shortName: '충남',
      emoji: '🌾',
      subRegionCount: 15,
    ),
    '전라북도': RegionInfo(
      code: '45',
      shortName: '전북',
      emoji: '🍚',
      subRegionCount: 14,
    ),
    '전라남도': RegionInfo(
      code: '46',
      shortName: '전남',
      emoji: '🌺',
      subRegionCount: 22,
    ),
    '경상북도': RegionInfo(
      code: '47',
      shortName: '경북',
      emoji: '🏛️',
      subRegionCount: 23,
    ),
    '경상남도': RegionInfo(
      code: '48',
      shortName: '경남',
      emoji: '🦆',
      subRegionCount: 18,
    ),
    '제주특별자치도': RegionInfo(
      code: '50',
      shortName: '제주',
      emoji: '🏝️',
      subRegionCount: 2,
    ),
  };
}

class RegionInfo {
  final String code;
  final String shortName;
  final String emoji;
  final int subRegionCount;

  const RegionInfo({
    required this.code,
    required this.shortName,
    required this.emoji,
    required this.subRegionCount,
  });
}