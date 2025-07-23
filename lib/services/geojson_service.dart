import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static Future<Set<Polygon>> loadKoreaBundary() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/GeoJSON/HangJeongDong_ver20250401.geojson',
      );
      print('GeoJSON 로드 성공! 파일 크기 : ${jsonString.length}');
      Map<String, dynamic> geoJson = json.decode(jsonString);
      print('features 개수: ${geoJson['features'].length}');
      Set<Polygon> polygons = {};

      if (geoJson['type'] != 'FeatureCollection') {
        print('예상과 다른 GeoJSON 타입:${geoJson['type']}');
      }

      //FeatureCollection 내의 각 행정구역 처리
      if (geoJson['type'] == 'FeatureCollection') {
        for (int i = 0; i < geoJson['features'].length; i++) {
          var feature = geoJson['features'][i];
          var properties = feature['properties'];
          var geometry = feature['geometry'];

          //MultiPolygon 처리
          if (geometry['type'] == 'MultiPolygon') {
            var coordinates = geometry['coordinates'];

            //MultiPolygon은 여러 개의 Polygon을 포함할 수 있음
            for (int j = 0; j < coordinates.length; j++) {
              var polygonCoords = coordinates[j][0]; //첫 번째 외곽선

              List<LatLng> points = [];
              for (var coord in polygonCoords) {
                //GeoJSON은 경도/위도 순서로 되어 있음 -> google maps : LatLng(위도, 경도)
                points.add(LatLng(coord[1], coord[0]));
              }
              if (points.length >= 3) {
                // 유효한 polygon을 위해 최소 3개 점 필요
                polygons.add(
                  Polygon(
                    polygonId: PolygonId('${properties['adm_cd']}_$j'),
                    points: points,
                    strokeColor: Colors.red,
                    strokeWidth: 5,
                    fillColor: Colors.pink.withOpacity(0.1), //아직 방문하지 않은 지역
                  ),
                );
              }
            }
          }
        }
      }
      return polygons;
    } catch (e) {
      print('Error loading GeoJSON: $e');
      return {};
    }
    ;
  }
}
