import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value, ComparableExpr;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../interfaces/parkour_spot_interface.dart';
import '../model/parkour_spot.dart';

// Drift DB / Table
import '../database/app_database.dart';

class LocalParkourSpotRepository implements IParkourSpotRepository {
  LocalParkourSpotRepository({required AppDatabase db}) : _db = db;
  final AppDatabase _db;

  @override
  Future<List<ParkourSpot>> fetchNearby({
    required LatLng center,
    double radiusKm = 5.0,
    int limit = 200,
  }) async {
    final b = _bounds(center, radiusKm);

    // 1) 위/경도 바운딩박스 1차 필터 (SQL 인덱스 효과를 받습니다)
    final rows = await (_db.select(_db.parkourSpots)
      ..where((t) => t.latitude.isBetweenValues(b.minLat, b.maxLat))
      ..where((t) => t.longitude.isBetweenValues(b.minLng, b.maxLng))
      ..limit(limit))
        .get();

    // 2) 행 → 도메인 모델, 3) 하버사인으로 진짜 반경 필터, 4) 거리순 정렬
    final all = rows.map(_toModel).toList();

    final filtered = all.where((s) {
      return _haversineKm(center, s.location) <= radiusKm;
    }).toList()
      ..sort((a, b2) {
        final da = _haversineKm(center, a.location);
        final db = _haversineKm(center, b2.location);
        return da.compareTo(db);
      });

    return filtered;
  }

  @override
  Stream<List<ParkourSpot>> watchNearby({
    required LatLng center,
    double radiusKm = 5.0,
    int limit = 200,
  }) {
    final b = _bounds(center, radiusKm);

    final query = (_db.select(_db.parkourSpots)
      ..where((t) => t.latitude.isBetweenValues(b.minLat, b.maxLat))
      ..where((t) => t.longitude.isBetweenValues(b.minLng, b.maxLng))
      ..limit(limit))
        .watch();

    return query.map((rows) {
      final all = rows.map(_toModel).toList();
      final filtered = all.where((s) {
        return _haversineKm(center, s.location) <= radiusKm;
      }).toList()
        ..sort((a, b2) {
          final da = _haversineKm(center, a.location);
          final db = _haversineKm(center, b2.location);
          return da.compareTo(db);
        });
      return filtered;
    });
  }

  @override
  Future<ParkourSpot?> getById(String id) async {
    final row =
    await (_db.select(_db.parkourSpots)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<void> upsert(ParkourSpot spot) async {
    // TEXT(JSON) 컬럼은 간단히 jsonEncode/Decode로 직렬화
    await _db.into(_db.parkourSpots).insertOnConflictUpdate(
      ParkourSpotsCompanion(
        id: Value(spot.documentId),
        name: Value(spot.name),
        description: spot.description.isEmpty
            ? const Value.absent()
            : Value(spot.description),
        address: spot.address.isEmpty
            ? const Value.absent()
            : Value(spot.address),
        latitude: Value(spot.location.latitude),
        longitude: Value(spot.location.longitude),
        category: Value(spot.category),
        difficulty: spot.difficulty.isEmpty
            ? const Value.absent()
            : Value(spot.difficulty),
        imageUrls: Value(jsonEncode(spot.imageUrls)),
        tags: Value(jsonEncode(spot.tags)),
        rating: Value(spot.rating ?? 0.0),
        reviewCount: Value(spot.reviewCount ?? 0),
        isVerified: Value(spot.isVerified),
        createdAt: Value(spot.createdAt ?? DateTime.now()),
        updatedAt: Value(spot.updatedAt ?? DateTime.now()),
        lastSyncAt: const Value(null),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.parkourSpots)..where((t) => t.id.equals(id))).go();
  }

  // ===== helpers =====

  ParkourSpot _toModel(ParkourSpotEntity e) {
    return ParkourSpot(
      documentId: e.id,
      name: e.name,
      description: e.description ?? '',
      address: e.address ?? '',
      location: LatLng(e.latitude, e.longitude),
      category: e.category,
      difficulty: e.difficulty ?? 'beginner',
      imageUrls: _safeDecodeList(e.imageUrls),
      tags: _safeDecodeList(e.tags),
      rating: e.rating,
      reviewCount: e.reviewCount,
      isVerified: e.isVerified,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  List<String> _safeDecodeList(String s) {
    if (s.isEmpty) return const [];
    try {
      final v = jsonDecode(s);
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  _Bounds _bounds(LatLng c, double rKm) {
    final latDelta = rKm / 110.574;
    final lngDelta =
        rKm / (111.320 * (math.cos(c.latitude * math.pi / 180.0))).abs();
    return _Bounds(
      c.latitude - latDelta,
      c.latitude + latDelta,
      c.longitude - lngDelta,
      c.longitude + lngDelta,
    );
    // 경계/극지 등 특수 케이스는 한국 서비스 특성상 영향 미미
  }

  double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = (b.latitude - a.latitude) * math.pi / 180.0;
    final dLng = (b.longitude - a.longitude) * math.pi / 180.0;
    final aa = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(a.latitude * math.pi / 180.0) *
            math.cos(b.latitude * math.pi / 180.0) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(aa), math.sqrt(1 - aa));
    return R * c;
  }
}

class _Bounds {
  _Bounds(this.minLat, this.maxLat, this.minLng, this.maxLng);
  final double minLat, maxLat, minLng, maxLng;
}