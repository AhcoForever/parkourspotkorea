import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 헥사곤 데이터 모델
class HexagonData {
  final String id;
  final LatLng center;
  final List<LatLng> points;

  const HexagonData({
    required this.id,
    required this.center,
    required this.points,
  });
}