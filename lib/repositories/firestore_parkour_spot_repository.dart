import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../interfaces/parkour_spot_interface.dart';
import '../model/parkour_spot.dart';

class FirestoreParkourSpotRepository implements IParkourSpotRepository {
  FirestoreParkourSpotRepository({
    FirebaseFirestore? firestore,
    String collectionPath = 'spot',
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _col = (firestore ?? FirebaseFirestore.instance).collection(collectionPath);

  final FirebaseFirestore _firestore;
  final CollectionReference _col;

  @override
  Future<List<ParkourSpot>> fetchNearby({
    required LatLng center,
    double radiusKm = 5.0,
    int limit = 200,
  }) async {
    final b = _bounds(center, radiusKm);

    final qs = await _col
        .where('latitude', isGreaterThanOrEqualTo: b.minLat)
        .where('latitude', isLessThanOrEqualTo: b.maxLat)
        .limit(limit)
        .get();

    final all = qs.docs.map((d) => ParkourSpot.fromFirestore(d)).toList();

    final filtered = all.where((s) {
      final lng = s.location.longitude;
      if (lng < b.minLng || lng > b.maxLng) return false;
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
    final q = _col
        .where('latitude', isGreaterThanOrEqualTo: b.minLat)
        .where('latitude', isLessThanOrEqualTo: b.maxLat)
        .limit(limit);

    return q.snapshots().map((snap) {
      final all = snap.docs.map((d) => ParkourSpot.fromFirestore(d)).toList();
      final filtered = all.where((s) {
        final lng = s.location.longitude;
        if (lng < b.minLng || lng > b.maxLng) return false;
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
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return ParkourSpot.fromFirestore(doc);
  }

  @override
  Future<void> upsert(ParkourSpot spot) async {
    await _col.doc(spot.documentId).set(spot.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  // ===== helpers =====
  _Bounds _bounds(LatLng c, double rKm) {
    final latDelta = rKm / 110.574;
    final lngDelta = rKm / (111.320 * math.cos(c.latitude * math.pi / 180.0)).abs();
    return _Bounds(c.latitude - latDelta, c.latitude + latDelta, c.longitude - lngDelta, c.longitude + lngDelta);
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