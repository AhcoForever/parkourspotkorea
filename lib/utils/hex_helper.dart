import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 육각형 폴리곤 좌표 생성 (pointy-top) - 벌집 패턴에 맞게 수정
List<LatLng> generateHexagon(LatLng center, double radiusInMeters) {
  const int sides = 6;
  const double earthRadius = 6371000.0; // m

  final List<LatLng> points = [];
  for (int i = 0; i < sides; i++) {
    // 각도(rad) - pointy-top 벌집 패턴을 위해 30도(π/6)에서 시작
    final double angle = (30.0 + (360.0 / sides) * i) * math.pi / 180.0;
    // 중심에서 동서(dx), 남북(dy) 오프셋 (m)
    final double dx = radiusInMeters * math.cos(angle);
    final double dy = radiusInMeters * math.sin(angle);
    // m → 위경도 변환 (정밀도 개선)
    final double deltaLat = (dy / earthRadius) * 180.0 / math.pi;
    final double deltaLng =
        (dx / (earthRadius * math.cos(center.latitude * math.pi / 180.0))) *
            180.0 /
            math.pi;

    // 정밀도를 위해 소수점 제한 (약 1cm 정밀도)
    final double newLat = _roundToPrecision(center.latitude + deltaLat, 7);
    final double newLng = _roundToPrecision(center.longitude + deltaLng, 7);

    points.add(LatLng(newLat, newLng));
  }

  // 폴리곤을 닫기 위해 첫 번째 점을 마지막에 추가
  points.add(points.first);
  return points;
}

/// 부동소수점 정밀도 제한 함수
double _roundToPrecision(double value, int precision) {
  final factor = math.pow(10, precision);
  return (value * factor).round() / factor;
}

// ─────────────────────────────────────────────────────────────────────────────
// 아래부터는 "첫 헥사곤 중심을 원점으로 삼는" 헥사 그리드 스냅/ID 유틸 (정밀도 개선)
// ─────────────────────────────────────────────────────────────────────────────

/// 위경도를 원점 기준 '미터' 좌표로 변환 (정밀도 개선)
math.Point<double> _latLngToLocalMeters(LatLng origin, LatLng p) {
  const double mPerDegLat = 111320.0;
  final double mPerDegLng = 111320.0 * math.cos(origin.latitude * math.pi / 180.0);
  final double dx = (p.longitude - origin.longitude) * mPerDegLng;
  final double dy = (p.latitude - origin.latitude) * mPerDegLat;
  return math.Point<double>(
      _roundToPrecision(dx, 3), // 1mm 정밀도
      _roundToPrecision(dy, 3)
  );
}

/// 로컬 '미터' 좌표를 위경도로 변환 (정밀도 개선)
LatLng _localMetersToLatLng(LatLng origin, double x, double y) {
  const double mPerDegLat = 111320.0;
  final double mPerDegLng = 111320.0 * math.cos(origin.latitude * math.pi / 180.0);
  final double lat = origin.latitude + (y / mPerDegLat);
  final double lng = origin.longitude + (x / mPerDegLng);
  return LatLng(
      _roundToPrecision(lat, 7), // 약 1cm 정밀도
      _roundToPrecision(lng, 7)
  );
}

/// pointy-top 헥사곤: 픽셀(x,y 미터) → 축좌표(q,r) (정밀도 개선)
math.Point<double> _pixelToAxial(double x, double y, double size) {
  final double q = (math.sqrt(3) / 3.0 * x - 1.0 / 3.0 * y) / size;
  final double r = (2.0 / 3.0 * y) / size;
  return math.Point<double>(
      _roundToPrecision(q, 6),
      _roundToPrecision(r, 6)
  );
}

/// 축좌표를 가장 가까운 정수 헥스로 반올림 (cube rounding)
math.Point<int> _axialRound(double q, double r) {
  double x = q;
  double z = r;
  double y = -x - z;

  int rx = x.round();
  int ry = y.round();
  int rz = z.round();

  final double xDiff = (rx - x).abs();
  final double yDiff = (ry - y).abs();
  final double zDiff = (rz - z).abs();

  if (xDiff > yDiff && xDiff > zDiff) {
    rx = -ry - rz;
  } else if (yDiff > zDiff) {
    ry = -rx - rz;
  } else {
    rz = -rx - ry;
  }
  return math.Point<int>(rx, rz); // (q,r)
}

/// 축좌표(q,r) → 픽셀(미터) 중심 좌표 (정밀도 개선)
math.Point<double> _axialToPixel(int q, int r, double size) {
  final double x = size * (math.sqrt(3) * (q + r / 2.0));
  final double y = size * (3.0 / 2.0 * r);
  return math.Point<double>(
      _roundToPrecision(x, 3), // 1mm 정밀도
      _roundToPrecision(y, 3)
  );
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