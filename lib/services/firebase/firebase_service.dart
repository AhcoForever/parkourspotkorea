
// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Firestore에서 모든 행정구역 경계 데이터를 가져오는 함수
//   Future<List<Polygon>> fetchAdministrativeBoundaries() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('dong_features')
//           .get();
//
//       List<Polygon> polygons = [];
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         final String admName = data['adm_nm'];
//         final String docId = doc.id;
//         final String coordinatesJson = data['coordinates'];
//
//         final coordinates = _parseCoordinates(coordinatesJson);
//
//         // 지도에 사용할 Polygon 생성
//         final polygon = Polygon(
//           polygonId: PolygonId(docId),
//           points: coordinates,
//           strokeColor: const Color(0xFF0000FF),
//           fillColor: const Color(0x220000FF),
//           strokeWidth: 2,
//           consumeTapEvents: true,
//           onTap: () {
//             print('Tapped on $admName');
//           },
//         );
//
//         polygons.add(polygon);
//       }
//
//       return polygons;
//     } catch (e) {
//       print('Error fetching administrative boundaries: $e');
//       return [];
//     }
//   }
//
//   // 문자열 형태의 coordinates를 List<LatLng>로 변환
//   List<LatLng> _parseCoordinates(String coordinatesString) {
//     final decoded = json.decode(coordinatesString);
//
//     // coordinates 구조는 [[[[lng, lat], ...]]] 형태이므로 깊이 확인 필요
//     final List<dynamic> outer = decoded[0][0];
//
//     return outer
//         .map<LatLng>((coordPair) =>
//         LatLng(coordPair[1] as double, coordPair[0] as double))
//         .toList();
//   }
// }

// lib/services/firebase_service.dart
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore =
  FirebaseFirestore.instanceFor(app: Firebase.app(),);

  static Future<Set<Polygon>> loadKoreaBoundaryPolygons() async {
    final snapshot = await _firestore
        .collection('dong_features')
        .get();

    Set<Polygon> polygons = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final coordinatesStr = data['coordinates'];
      final admNm = data['adm_nm'] ?? 'unknown';
      final docId = doc.id;

      final coords = _parseCoordinates(coordinatesStr);

      if (coords.isNotEmpty) {
        polygons.add(
          Polygon(
            polygonId: PolygonId(docId),
            points: coords,
            strokeColor: const Color(0xFF007AFF),
            fillColor: const Color(0x22007AFF),
            strokeWidth: 1,
            consumeTapEvents: true,
            onTap: () => print('Tapped: $admNm'),
          ),
        );
      }
    }

    return polygons;
  }

  static List<LatLng> _parseCoordinates(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      final List<dynamic> rawCoords = decoded[0][0];
      return rawCoords
          .map<LatLng>((pair) => LatLng(pair[1], pair[0]))
          .toList();
    } catch (e) {
      print('좌표 파싱 오류: $e');
      return [];
    }
  }
}