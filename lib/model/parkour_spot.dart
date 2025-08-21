import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 파쿠르 스팟 모델 클래스
class ParkourSpot {
  // === 기본 정보 ===
  final String documentId;
  final String name;
  final String displayName;
  final String address;
  final String mappedAddress;

  // === 위치 정보 ===
  final LatLng location;
  final String rcode;

  // === 카테고리 ===
  final String type;
  final String category;
  final String subcategory;
  final String mcid;
  final String mcidName;

  // === 설명 및 메모 ===
  final String memo;
  final String folderMemo;
  final String description;

  // === 네이버 지도 정보 ===
  final String bookmarkId;
  final String sid;
  final String url;
  final String naverMapUrl;

  // === 폴더 정보 ===
  final String folderName;
  final String folderId;
  final String sharerNickName;
  final String externalLink;
  final int bookmarkCount;

  // === 시간 정보 ===
  final DateTime? creationTime;
  final DateTime? lastUpdateTime;
  final DateTime? useTime;
  final DateTime? uploadedAt;

  // === 상태 정보 ===
  final bool available;
  final bool isMatched;
  final bool isIndoor;
  final bool isActive;

  // === 파쿠르 관련 ===
  final List<String> tags;
  final String difficulty;
  final List<String> equipment;

  // === 메타데이터 ===
  final String source;
  final String version;
  final Map<String, dynamic>? originalData;

  const ParkourSpot({
    required this.documentId,
    required this.name,
    required this.location,
    this.displayName = '',
    this.address = '',
    this.mappedAddress = '',
    this.rcode = '',
    this.type = 'place',
    this.category = 'parkour_spot',
    this.subcategory = 'general',
    this.mcid = '',
    this.mcidName = '',
    this.memo = '',
    this.folderMemo = '',
    this.description = '',
    this.bookmarkId = '',
    this.sid = '',
    this.url = '',
    this.naverMapUrl = '',
    this.folderName = '',
    this.folderId = '',
    this.sharerNickName = '',
    this.externalLink = '',
    this.bookmarkCount = 0,
    this.creationTime,
    this.lastUpdateTime,
    this.useTime,
    this.uploadedAt,
    this.available = true,
    this.isMatched = true,
    this.isIndoor = false,
    this.isActive = true,
    this.tags = const [],
    this.difficulty = 'intermediate',
    this.equipment = const [],
    this.source = 'naver_map_parkour_collection',
    this.version = '1.0',
    this.originalData,
  });

  /// Firestore 문서에서 ParkourSpot 객체 생성
  factory ParkourSpot.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final geoPoint = data['location'] as GeoPoint?;

    return ParkourSpot(
      documentId: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      address: data['address'] ?? '',
      mappedAddress: data['mappedAddress'] ?? '',
      location: geoPoint != null
          ? LatLng(geoPoint.latitude, geoPoint.longitude)
          : const LatLng(37.5665, 126.9780), // 기본값: 서울시청
      rcode: data['rcode'] ?? '',
      type: data['type'] ?? 'place',
      category: data['category'] ?? 'parkour_spot',
      subcategory: data['subcategory'] ?? 'general',
      mcid: data['mcid'] ?? '',
      mcidName: data['mcidName'] ?? '',
      memo: data['memo'] ?? '',
      folderMemo: data['folderMemo'] ?? '',
      description: data['description'] ?? '',
      bookmarkId: data['bookmarkId'] ?? '',
      sid: data['sid'] ?? '',
      url: data['url'] ?? '',
      naverMapUrl: data['naverMapUrl'] ?? '',
      folderName: data['folderName'] ?? '',
      folderId: data['folderId'] ?? '',
      sharerNickName: data['sharerNickName'] ?? '',
      externalLink: data['externalLink'] ?? '',
      bookmarkCount: data['bookmarkCount'] ?? 0,
      creationTime: (data['creationTime'] as Timestamp?)?.toDate(),
      lastUpdateTime: (data['lastUpdateTime'] as Timestamp?)?.toDate(),
      useTime: (data['useTime'] as Timestamp?)?.toDate(),
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate(),
      available: data['available'] ?? true,
      isMatched: data['isMatched'] ?? true,
      isIndoor: data['isIndoor'] ?? false,
      isActive: data['isActive'] ?? true,
      tags: List<String>.from(data['tags'] ?? []),
      difficulty: data['difficulty'] ?? 'intermediate',
      equipment: List<String>.from(data['equipment'] ?? []),
      source: data['source'] ?? 'naver_map_parkour_collection',
      version: data['version'] ?? '1.0',
      originalData: data['originalData'] as Map<String, dynamic>?,
    );
  }

  /// JSON Map에서 ParkourSpot 객체 생성
  factory ParkourSpot.fromJson(Map<String, dynamic> json) {
    return ParkourSpot(
      documentId: json['documentId'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      address: json['address'] ?? '',
      mappedAddress: json['mappedAddress'] ?? '',
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : const LatLng(37.5665, 126.9780),
      rcode: json['rcode'] ?? '',
      type: json['type'] ?? 'place',
      category: json['category'] ?? 'parkour_spot',
      subcategory: json['subcategory'] ?? 'general',
      mcid: json['mcid'] ?? '',
      mcidName: json['mcidName'] ?? '',
      memo: json['memo'] ?? '',
      folderMemo: json['folderMemo'] ?? '',
      description: json['description'] ?? '',
      bookmarkId: json['bookmarkId'] ?? '',
      sid: json['sid'] ?? '',
      url: json['url'] ?? '',
      naverMapUrl: json['naverMapUrl'] ?? '',
      folderName: json['folderName'] ?? '',
      folderId: json['folderId'] ?? '',
      sharerNickName: json['sharerNickName'] ?? '',
      externalLink: json['externalLink'] ?? '',
      bookmarkCount: json['bookmarkCount'] ?? 0,
      creationTime: json['creationTime'] != null
          ? DateTime.parse(json['creationTime'])
          : null,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'])
          : null,
      useTime: json['useTime'] != null
          ? DateTime.parse(json['useTime'])
          : null,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : null,
      available: json['available'] ?? true,
      isMatched: json['isMatched'] ?? true,
      isIndoor: json['isIndoor'] ?? false,
      isActive: json['isActive'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
      difficulty: json['difficulty'] ?? 'intermediate',
      equipment: List<String>.from(json['equipment'] ?? []),
      source: json['source'] ?? 'naver_map_parkour_collection',
      version: json['version'] ?? '1.0',
      originalData: json['originalData'] as Map<String, dynamic>?,
    );
  }

  /// ParkourSpot을 Firestore용 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'documentId': documentId,
      'name': name,
      'displayName': displayName,
      'address': address,
      'mappedAddress': mappedAddress,
      'location': GeoPoint(location.latitude, location.longitude),
      'rcode': rcode,
      'type': type,
      'category': category,
      'subcategory': subcategory,
      'mcid': mcid,
      'mcidName': mcidName,
      'memo': memo,
      'folderMemo': folderMemo,
      'description': description,
      'bookmarkId': bookmarkId,
      'sid': sid,
      'url': url,
      'naverMapUrl': naverMapUrl,
      'folderName': folderName,
      'folderId': folderId,
      'sharerNickName': sharerNickName,
      'externalLink': externalLink,
      'bookmarkCount': bookmarkCount,
      'creationTime': creationTime != null ? Timestamp.fromDate(creationTime!) : null,
      'lastUpdateTime': lastUpdateTime != null ? Timestamp.fromDate(lastUpdateTime!) : null,
      'useTime': useTime != null ? Timestamp.fromDate(useTime!) : null,
      'uploadedAt': uploadedAt != null ? Timestamp.fromDate(uploadedAt!) : FieldValue.serverTimestamp(),
      'available': available,
      'isMatched': isMatched,
      'isIndoor': isIndoor,
      'isActive': isActive,
      'tags': tags,
      'difficulty': difficulty,
      'equipment': equipment,
      'source': source,
      'version': version,
      'originalData': originalData,
    };
  }

  /// JSON Map으로 변환
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'name': name,
      'displayName': displayName,
      'address': address,
      'mappedAddress': mappedAddress,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'rcode': rcode,
      'type': type,
      'category': category,
      'subcategory': subcategory,
      'mcid': mcid,
      'mcidName': mcidName,
      'memo': memo,
      'folderMemo': folderMemo,
      'description': description,
      'bookmarkId': bookmarkId,
      'sid': sid,
      'url': url,
      'naverMapUrl': naverMapUrl,
      'folderName': folderName,
      'folderId': folderId,
      'sharerNickName': sharerNickName,
      'externalLink': externalLink,
      'bookmarkCount': bookmarkCount,
      'creationTime': creationTime?.toIso8601String(),
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
      'useTime': useTime?.toIso8601String(),
      'uploadedAt': uploadedAt?.toIso8601String(),
      'available': available,
      'isMatched': isMatched,
      'isIndoor': isIndoor,
      'isActive': isActive,
      'tags': tags,
      'difficulty': difficulty,
      'equipment': equipment,
      'source': source,
      'version': version,
      'originalData': originalData,
    };
  }

  /// 복사본 생성 (copyWith)
  ParkourSpot copyWith({
    String? documentId,
    String? name,
    String? displayName,
    String? address,
    String? mappedAddress,
    LatLng? location,
    String? rcode,
    String? type,
    String? category,
    String? subcategory,
    String? mcid,
    String? mcidName,
    String? memo,
    String? folderMemo,
    String? description,
    String? bookmarkId,
    String? sid,
    String? url,
    String? naverMapUrl,
    String? folderName,
    String? folderId,
    String? sharerNickName,
    String? externalLink,
    int? bookmarkCount,
    DateTime? creationTime,
    DateTime? lastUpdateTime,
    DateTime? useTime,
    DateTime? uploadedAt,
    bool? available,
    bool? isMatched,
    bool? isIndoor,
    bool? isActive,
    List<String>? tags,
    String? difficulty,
    List<String>? equipment,
    String? source,
    String? version,
    Map<String, dynamic>? originalData,
  }) {
    return ParkourSpot(
      documentId: documentId ?? this.documentId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      address: address ?? this.address,
      mappedAddress: mappedAddress ?? this.mappedAddress,
      location: location ?? this.location,
      rcode: rcode ?? this.rcode,
      type: type ?? this.type,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      mcid: mcid ?? this.mcid,
      mcidName: mcidName ?? this.mcidName,
      memo: memo ?? this.memo,
      folderMemo: folderMemo ?? this.folderMemo,
      description: description ?? this.description,
      bookmarkId: bookmarkId ?? this.bookmarkId,
      sid: sid ?? this.sid,
      url: url ?? this.url,
      naverMapUrl: naverMapUrl ?? this.naverMapUrl,
      folderName: folderName ?? this.folderName,
      folderId: folderId ?? this.folderId,
      sharerNickName: sharerNickName ?? this.sharerNickName,
      externalLink: externalLink ?? this.externalLink,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      creationTime: creationTime ?? this.creationTime,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      useTime: useTime ?? this.useTime,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      available: available ?? this.available,
      isMatched: isMatched ?? this.isMatched,
      isIndoor: isIndoor ?? this.isIndoor,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      equipment: equipment ?? this.equipment,
      source: source ?? this.source,
      version: version ?? this.version,
      originalData: originalData ?? this.originalData,
    );
  }

  @override
  String toString() {
    return 'ParkourSpot(documentId: $documentId, name: $name, address: $address, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParkourSpot && other.documentId == documentId;
  }

  @override
  int get hashCode => documentId.hashCode;
}