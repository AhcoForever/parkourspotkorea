import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 육각형 폴리곤 좌표 생성 (pointy-top)
List<LatLng> generateHexagon(LatLng center, double radiusInMeters) {
  const int sides = 6;
  const double earthRadius = 6371000; // m

  final List<LatLng> points = [];
  for (int i = 0; i < sides; i++) {
    // 각도(rad) - pointy-top을 기준으로 0도부터 시계 방향
    final double angle = (360 / sides) * i * math.pi / 180.0;
    // 중심에서 동서(dx), 남북(dy) 오프셋 (m)
    final double dx = radiusInMeters * math.cos(angle);
    final double dy = radiusInMeters * math.sin(angle);
    // m → 위경도 변환
    final double deltaLat = (dy / earthRadius) * 180.0 / math.pi;
    final double deltaLng =
        (dx / (earthRadius * math.cos(center.latitude * math.pi / 180.0))) *
        180.0 /
        math.pi;

    points.add(LatLng(center.latitude + deltaLat, center.longitude + deltaLng));
  }

  // 폴리곤을 닫고 싶으면 아래 한 줄을 유지 (Google Maps는 자동으로 닫지 않음)
  points.add(points.first);
  return points;
}

// ─────────────────────────────────────────────────────────────────────────────
// 아래부터는 "첫 헥사곤 중심을 원점으로 삼는" 헥사 그리드 스냅/ID 유틸
// ─────────────────────────────────────────────────────────────────────────────

/// 위경도를 원점 기준 '미터' 좌표로 변환
math.Point<double> _latLngToLocalMeters(LatLng origin, LatLng p) {
  const mPerDegLat = 111320.0;
  final mPerDegLng = 111320.0 * math.cos(origin.latitude * math.pi / 180.0);
  final dx = (p.longitude - origin.longitude) * mPerDegLng;
  final dy = (p.latitude - origin.latitude) * mPerDegLat;
  return math.Point<double>(dx, dy);
}

/// 로컬 '미터' 좌표를 위경도로 변환
LatLng _localMetersToLatLng(LatLng origin, double x, double y) {
  const mPerDegLat = 111320.0;
  final mPerDegLng = 111320.0 * math.cos(origin.latitude * math.pi / 180.0);
  final lat = origin.latitude + (y / mPerDegLat);
  final lng = origin.longitude + (x / mPerDegLng);
  return LatLng(lat, lng);
}

/// pointy-top 헥사곤: 픽셀(x,y 미터) → 축좌표(q,r)
math.Point<double> _pixelToAxial(double x, double y, double size) {
  final q = (math.sqrt(3) / 3 * x - 1.0 / 3.0 * y) / size;
  final r = (2.0 / 3.0 * y) / size;
  return math.Point<double>(q, r);
}

/// 축좌표를 가장 가까운 정수 헥스로 반올림 (cube rounding)
math.Point<int> _axialRound(double q, double r) {
  double x = q;
  double z = r;
  double y = -x - z;

  int rx = x.round();
  int ry = y.round();
  int rz = z.round();
  final xDiff = (rx - x).abs();
  final yDiff = (ry - y).abs();
  final zDiff = (rz - z).abs();
  if (xDiff > yDiff && xDiff > zDiff) {
    rx = -ry - rz;
  } else if (yDiff > zDiff) {
    ry = -rx - rz;
  } else {
    rz = -rx - ry;
    // 항상 반환 (non-nullable 보장)
  }
  return math.Point<int>(rx, rz); // (q,r)

}

/// 축좌표(q,r) → 픽셀(미터) 중심 좌표
math.Point<double> _axialToPixel(int q, int r, double size) {
  final x = size * (math.sqrt(3) * (q + r / 2.0));
  final y = size * (3.0 / 2.0 * r);
  return math.Point<double>(x, y);
}

/// 현재 위치를 '원점+사이즈' 기준 헥스 그리드에 스냅한 중심 LatLng 반환
LatLng snapToHexCenter(LatLng origin, LatLng p, double sizeMeters) {
  final px = _latLngToLocalMeters(origin, p);
  final fr = _pixelToAxial(px.x, px.y, sizeMeters);
  final qr = _axialRound(fr.x, fr.y);
  final centerXY = _axialToPixel(qr.x, qr.y, sizeMeters);
  return _localMetersToLatLng(origin, centerXY.x, centerXY.y);
}

/// 헥사곤 ID (q,r)
String hexIdFromLatLng(LatLng origin, LatLng p, double sizeMeters) {
  final px = _latLngToLocalMeters(origin, p);
  final fr = _pixelToAxial(px.x, px.y, sizeMeters);
  final qr = _axialRound(fr.x, fr.y);
  return 'h_${qr.x}_${qr.y}';
}

/// 저장된 (q,r) 인덱스에서 헥사곤 중심 LatLng 재구성
LatLng hexCenterFromIndex(LatLng origin, int q, int r, double sizeMeters) {
  final c = _axialToPixel(q, r, sizeMeters);
  return _localMetersToLatLng(origin, c.x, c.y);
}
