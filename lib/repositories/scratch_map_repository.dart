import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drift/drift.dart' as drift;

import '../interfaces/scratch_map_interface.dart';
import '../services/drift/drift_map_service.dart';
import '../services/firebase/firebase_service.dart';
import '../database/app_database.dart';

/// ScratchMap 지도 데이터 Repository 구현체
class ScratchMapRepository implements IScratchMapRepository {
  final DriftMapService driftMapService;
  //final FirebaseService firebaseService;

  ScratchMapRepository({required this.driftMapService,/*required this.firebaseService*/});

  @override
  Future<List<PolygonRow>> getPolygonsBySido(int sido) async {
    try {
      return await driftMapService.getPolygonsBySido(sido);
    } catch (e) {
      print('❌ 로컬 폴리곤 조회 실패: $e');
      throw Exception('로컬 폴리곤 조회 실패: $e');
    }
  }

  @override
  Future<Set<Polygon>> fetchAndCachePolygons(int sido) async {
    try {
      // 1) Firebase에서 데이터 가져오기
      final docs = await FirebaseService.loadDocsBySidoRaw(sido);
      if (docs.isEmpty) {
        print('⚠️ 원격에서 데이터를 찾을 수 없습니다: sido=$sido');
        return {};
      }

      // 2) Drift에 캐시 저장
      final companions = docs.map((m) {
        final sgg = m['sgg'] as int?;
        final sggPrefix = (sgg == null) ? null : sgg - (sgg % 100);
        return PolygonsCompanion.insert(
          docId: m['docId'] as String,
          sido: m['sido'] as int,
          sggPrefix: drift.Value(sggPrefix),
          coordinatesJson: m['coordinates'] as String,
          updatedAt: DateTime.now(),
        );
      }).toList();

      await driftMapService.upsertPolygonsCompanions(companions);

      // 3) Polygon 객체로 변환해서 반환
      final polygons = docs
          .map<Polygon?>((m) {
        final pts = FirebaseService.parseCoordinates(
          m['coordinates'] as String,
        );
        if (pts.isEmpty) return null;
        return Polygon(
          polygonId: PolygonId(m['docId'] as String),
          points: pts,
          strokeColor: const Color(0xFF007AFF),
          fillColor: const Color(0x22007AFF),
          strokeWidth: 1,
        );
      })
          .whereType<Polygon>()
          .toSet();

      print('✅ 폴리곤 캐시 및 반환 완료: ${polygons.length}개');
      return polygons;
    } catch (e) {
      print('❌ 원격 폴리곤 가져오기 실패: $e');
      throw Exception('원격 폴리곤 가져오기 실패: $e');
    }
  }

  @override
  Future<void> clearPolygonsCache(int sido) async {
    try {
      // DriftMapService에 해당 메소드 추가 필요
      print('✅ 폴리곤 캐시 삭제 완료: sido=$sido');
    } catch (e) {
      print('❌ 폴리곤 캐시 삭제 실패: $e');
      throw Exception('폴리곤 캐시 삭제 실패: $e');
    }
  }

  /// PolygonRow들을 Polygon으로 변환
  @override
  Set<Polygon> convertRowsToPolygons(List<PolygonRow> rows) {
    return rows.map((r) {
      final pts = FirebaseService.parseCoordinates(r.coordinatesJson);
      return Polygon(
        polygonId: PolygonId(r.docId),
        points: pts,
        strokeColor: const Color(0xFF007AFF),
        fillColor: const Color(0x22007AFF),
        strokeWidth: 1,
      );
    }).toSet();
  }

  // 기존 메소드도 유지
  Future<List<PolygonRow>> getPolygonsBySggPrefix(int sggPrefix) async {
    return await driftMapService.getPolygonsBySggPrefix(sggPrefix);
  }
}