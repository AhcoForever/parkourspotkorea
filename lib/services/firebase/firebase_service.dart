import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
  );

  /// 시/도 코드로 문서 로드 (Raw 데이터)
  static Future<List<Map<String, dynamic>>> loadDocsBySidoRaw(int sido) async {
    final snapshot = await _firestore
        .collection('dong_features')
        .where('sido', isEqualTo: sido)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'docId': doc.id,
        'sido': data['sido'],
        'sgg': data['sgg'],
        'coordinates': data['coordinates'],
        'updated_at': data['updated_at'],
        'adm_nm': data['adm_nm'],
      };
    }).toList();
  }

  /// 시군구 prefix 코드로 문서 로드 (Raw 데이터)
  static Future<List<Map<String, dynamic>>> loadDocsBySggPrefixRaw(
    int sggPrefix,
  ) async {
    final snapshot = await _firestore
        .collection('dong_features')
        .where('sgg', isEqualTo: sggPrefix)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'docId': doc.id,
        'sido': data['sido'],
        'sgg': data['sgg'],
        'coordinates': data['coordinates'],
        'updated_at': data['updated_at'],
        'adm_nm': data['adm_nm'],
      };
    }).toList();
  }

  static Future<Set<Polygon>> loadKoreaBoundaryPolygons() async {
    final snapshot = await _firestore.collection('dong_features').get();

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
      return rawCoords.map<LatLng>((pair) => LatLng(pair[1], pair[0])).toList();
    } catch (e) {
      print('좌표 파싱 오류: $e');
      return [];
    }
  }

  // firebase_service.dart (클래스 내부)
  static List<LatLng> parseCoordinates(String jsonStr) =>
      _parseCoordinates(jsonStr);
}

//Todo: static 없이 객체화로 변경
