// lib/model/parkour_spot.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkourSpot {
  // === 기본 정보 ===
  final String documentId; // Firestore 문서 ID 사용 (필드의 "id"는 보조용으로 읽기만)
  final String name;
  final String displayName; // 없으면 name으로 폴백
  final String address;
  final String description;

  // === 위치 ===
  final LatLng location; // GeoPoint 또는 latitude/longitude 모두 대응
  final String category;
  final String difficulty;

  // === 메타 ===
  final List<String> imageUrls;
  final List<String> tags;
  final double? rating;
  final int? reviewCount;
  final bool isVerified;

  // === 시간 ===
  final DateTime? createdAt;  // createdAt / Timestamp / ISO8601 모두 대응
  final DateTime? updatedAt;  // updatedAt / Timestamp / ISO8601 모두 대응

  const ParkourSpot({
    required this.documentId,
    required this.name,
    required this.location,
    this.displayName = '',
    this.address = '',
    this.description = '',
    this.category = 'parkour_spot',
    this.difficulty = 'intermediate',
    this.imageUrls = const [],
    this.tags = const [],
    this.rating,
    this.reviewCount,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore -> Model (GeoPoint 또는 lat/lng 모두 지원)
  factory ParkourSpot.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});

    // 위치: GeoPoint 또는 latitude/longitude
    final geo = data['location'] as GeoPoint?;
    final lat = _toDouble(data['latitude']);
    final lng = _toDouble(data['longitude']);
    final LatLng latLng = geo != null
        ? LatLng(geo.latitude, geo.longitude)
        : (lat != null && lng != null
        ? LatLng(lat, lng)
        : const LatLng(37.5665, 126.9780)); // 서울시청 폴백

    return ParkourSpot(
      documentId: doc.id,
      name: (data['name'] ?? '').toString(),
      displayName: ((data['displayName'] ?? data['name']) ?? '').toString(),
      address: (data['address'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      location: latLng,
      category: (data['category'] ?? 'parkour_spot').toString(),
      difficulty: (data['difficulty'] ?? 'beginner').toString(),
      imageUrls: _toStringList(data['imageUrls']),
      tags: _toStringList(data['tags']),
      rating: _toDouble(data['rating']),
      reviewCount: _toInt(data['reviewCount']),
      isVerified: _toBool(data['isVerified']) ?? false,
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
    );
  }

  /// JSON -> Model (질문에 주신 샘플 JSON 구조 1:1 대응)
  factory ParkourSpot.fromJson(Map<String, dynamic> json) {
    final lat = _toDouble(json['latitude']);
    final lng = _toDouble(json['longitude']);
    return ParkourSpot(
      documentId: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      displayName: ((json['displayName'] ?? json['name']) ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      location: (lat != null && lng != null)
          ? LatLng(lat, lng)
          : const LatLng(37.5665, 126.9780),
      category: (json['category'] ?? 'parkour_spot').toString(),
      difficulty: (json['difficulty'] ?? 'beginner').toString(),
      imageUrls: _toStringList(json['imageUrls']),
      tags: _toStringList(json['tags']),
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['reviewCount']),
      isVerified: _toBool(json['isVerified']) ?? false,
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
    );
  }

  /// Model -> Firestore (호환성을 위해 lat/lng와 GeoPoint 모두 기록 권장)
  Map<String, dynamic> toFirestore() {
    return {
      'id': documentId, // 선택: 외부 ID로도 쓰고 싶다면 보관
      'name': name,
      'displayName': displayName.isNotEmpty ? displayName : name,
      'address': address,
      'description': description,
      'location': GeoPoint(location.latitude, location.longitude),
      'latitude': location.latitude,
      'longitude': location.longitude,
      'category': category,
      'difficulty': difficulty,
      'imageUrls': imageUrls,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': documentId,
      'name': name,
      'displayName': displayName.isNotEmpty ? displayName : name,
      'address': address,
      'description': description,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'category': category,
      'difficulty': difficulty,
      'imageUrls': imageUrls,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ParkourSpot copyWith({
    String? documentId,
    String? name,
    String? displayName,
    String? address,
    String? description,
    LatLng? location,
    String? category,
    String? difficulty,
    List<String>? imageUrls,
    List<String>? tags,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParkourSpot(
      documentId: documentId ?? this.documentId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      address: address ?? this.address,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'ParkourSpot($documentId, $name, ${location.latitude}, ${location.longitude})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ParkourSpot && other.documentId == documentId;

  @override
  int get hashCode => documentId.hashCode;
}

/// ---- Safe casters ----
double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString());
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString());
}

bool? _toBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().toLowerCase();
  if (s == 'true') return true;
  if (s == 'false') return false;
  return null;
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

List<String> _toStringList(dynamic v) {
  if (v == null) return const [];
  if (v is List) return v.map((e) => e.toString()).toList();
  return const [];
}