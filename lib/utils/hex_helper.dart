import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> generateHexagon(LatLng center, double radiusInMeters) {
  const int sides = 6;
  const double angleStep = 360 / sides;
  const double earthRadius = 6371000; // m
  const double degToRad = pi / 180;
  const double radToDeg = 180 / pi;

  List<LatLng> points = [];

  for (int i = 0; i < sides; i++) {
    double angle = degToRad * (angleStep * i);
    double dx = radiusInMeters * cos(angle);
    double dy = radiusInMeters * sin(angle);

    double deltaLat = dy / earthRadius * radToDeg;
    double deltaLng = dx / (earthRadius * cos(center.latitude * degToRad)) * radToDeg;

    points.add(LatLng(center.latitude + deltaLat, center.longitude + deltaLng));
  }

  points.add(points.first); // 닫힌 polygon
  return points;
}