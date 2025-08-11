// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentLatitudeMeta = const VerificationMeta(
    'currentLatitude',
  );
  @override
  late final GeneratedColumn<double> currentLatitude = GeneratedColumn<double>(
    'current_latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentLongitudeMeta = const VerificationMeta(
    'currentLongitude',
  );
  @override
  late final GeneratedColumn<double> currentLongitude = GeneratedColumn<double>(
    'current_longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitedRegionsMeta = const VerificationMeta(
    'visitedRegions',
  );
  @override
  late final GeneratedColumn<String> visitedRegions = GeneratedColumn<String>(
    'visited_regions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _totalVisitedCountMeta = const VerificationMeta(
    'totalVisitedCount',
  );
  @override
  late final GeneratedColumn<int> totalVisitedCount = GeneratedColumn<int>(
    'total_visited_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _explorationProgressMeta =
      const VerificationMeta('explorationProgress');
  @override
  late final GeneratedColumn<double> explorationProgress =
      GeneratedColumn<double>(
        'exploration_progress',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _lastLocationUpdateMeta =
      const VerificationMeta('lastLocationUpdate');
  @override
  late final GeneratedColumn<DateTime> lastLocationUpdate =
      GeneratedColumn<DateTime>(
        'last_location_update',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    currentLatitude,
    currentLongitude,
    visitedRegions,
    totalVisitedCount,
    explorationProgress,
    lastLocationUpdate,
    createdAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('current_latitude')) {
      context.handle(
        _currentLatitudeMeta,
        currentLatitude.isAcceptableOrUnknown(
          data['current_latitude']!,
          _currentLatitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentLatitudeMeta);
    }
    if (data.containsKey('current_longitude')) {
      context.handle(
        _currentLongitudeMeta,
        currentLongitude.isAcceptableOrUnknown(
          data['current_longitude']!,
          _currentLongitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentLongitudeMeta);
    }
    if (data.containsKey('visited_regions')) {
      context.handle(
        _visitedRegionsMeta,
        visitedRegions.isAcceptableOrUnknown(
          data['visited_regions']!,
          _visitedRegionsMeta,
        ),
      );
    }
    if (data.containsKey('total_visited_count')) {
      context.handle(
        _totalVisitedCountMeta,
        totalVisitedCount.isAcceptableOrUnknown(
          data['total_visited_count']!,
          _totalVisitedCountMeta,
        ),
      );
    }
    if (data.containsKey('exploration_progress')) {
      context.handle(
        _explorationProgressMeta,
        explorationProgress.isAcceptableOrUnknown(
          data['exploration_progress']!,
          _explorationProgressMeta,
        ),
      );
    }
    if (data.containsKey('last_location_update')) {
      context.handle(
        _lastLocationUpdateMeta,
        lastLocationUpdate.isAcceptableOrUnknown(
          data['last_location_update']!,
          _lastLocationUpdateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      currentLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_latitude'],
      )!,
      currentLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_longitude'],
      )!,
      visitedRegions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visited_regions'],
      )!,
      totalVisitedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_visited_count'],
      )!,
      explorationProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exploration_progress'],
      )!,
      lastLocationUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_location_update'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String uid;
  final String email;
  final double currentLatitude;
  final double currentLongitude;

  /// 방문한 지역 ID들 (comma-separated string)
  /// 예: "11110,11140,11170" (서울 종로구, 중구, 용산구)
  final String visitedRegions;
  final int totalVisitedCount;
  final double explorationProgress;
  final DateTime? lastLocationUpdate;
  final DateTime createdAt;
  final DateTime? lastSyncAt;
  const LocalUser({
    required this.uid,
    required this.email,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.visitedRegions,
    required this.totalVisitedCount,
    required this.explorationProgress,
    this.lastLocationUpdate,
    required this.createdAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    map['current_latitude'] = Variable<double>(currentLatitude);
    map['current_longitude'] = Variable<double>(currentLongitude);
    map['visited_regions'] = Variable<String>(visitedRegions);
    map['total_visited_count'] = Variable<int>(totalVisitedCount);
    map['exploration_progress'] = Variable<double>(explorationProgress);
    if (!nullToAbsent || lastLocationUpdate != null) {
      map['last_location_update'] = Variable<DateTime>(lastLocationUpdate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      uid: Value(uid),
      email: Value(email),
      currentLatitude: Value(currentLatitude),
      currentLongitude: Value(currentLongitude),
      visitedRegions: Value(visitedRegions),
      totalVisitedCount: Value(totalVisitedCount),
      explorationProgress: Value(explorationProgress),
      lastLocationUpdate: lastLocationUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLocationUpdate),
      createdAt: Value(createdAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String>(json['email']),
      currentLatitude: serializer.fromJson<double>(json['currentLatitude']),
      currentLongitude: serializer.fromJson<double>(json['currentLongitude']),
      visitedRegions: serializer.fromJson<String>(json['visitedRegions']),
      totalVisitedCount: serializer.fromJson<int>(json['totalVisitedCount']),
      explorationProgress: serializer.fromJson<double>(
        json['explorationProgress'],
      ),
      lastLocationUpdate: serializer.fromJson<DateTime?>(
        json['lastLocationUpdate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'currentLatitude': serializer.toJson<double>(currentLatitude),
      'currentLongitude': serializer.toJson<double>(currentLongitude),
      'visitedRegions': serializer.toJson<String>(visitedRegions),
      'totalVisitedCount': serializer.toJson<int>(totalVisitedCount),
      'explorationProgress': serializer.toJson<double>(explorationProgress),
      'lastLocationUpdate': serializer.toJson<DateTime?>(lastLocationUpdate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  LocalUser copyWith({
    String? uid,
    String? email,
    double? currentLatitude,
    double? currentLongitude,
    String? visitedRegions,
    int? totalVisitedCount,
    double? explorationProgress,
    Value<DateTime?> lastLocationUpdate = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => LocalUser(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    currentLatitude: currentLatitude ?? this.currentLatitude,
    currentLongitude: currentLongitude ?? this.currentLongitude,
    visitedRegions: visitedRegions ?? this.visitedRegions,
    totalVisitedCount: totalVisitedCount ?? this.totalVisitedCount,
    explorationProgress: explorationProgress ?? this.explorationProgress,
    lastLocationUpdate: lastLocationUpdate.present
        ? lastLocationUpdate.value
        : this.lastLocationUpdate,
    createdAt: createdAt ?? this.createdAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  LocalUser copyWithCompanion(UsersCompanion data) {
    return LocalUser(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      currentLatitude: data.currentLatitude.present
          ? data.currentLatitude.value
          : this.currentLatitude,
      currentLongitude: data.currentLongitude.present
          ? data.currentLongitude.value
          : this.currentLongitude,
      visitedRegions: data.visitedRegions.present
          ? data.visitedRegions.value
          : this.visitedRegions,
      totalVisitedCount: data.totalVisitedCount.present
          ? data.totalVisitedCount.value
          : this.totalVisitedCount,
      explorationProgress: data.explorationProgress.present
          ? data.explorationProgress.value
          : this.explorationProgress,
      lastLocationUpdate: data.lastLocationUpdate.present
          ? data.lastLocationUpdate.value
          : this.lastLocationUpdate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('currentLatitude: $currentLatitude, ')
          ..write('currentLongitude: $currentLongitude, ')
          ..write('visitedRegions: $visitedRegions, ')
          ..write('totalVisitedCount: $totalVisitedCount, ')
          ..write('explorationProgress: $explorationProgress, ')
          ..write('lastLocationUpdate: $lastLocationUpdate, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    email,
    currentLatitude,
    currentLongitude,
    visitedRegions,
    totalVisitedCount,
    explorationProgress,
    lastLocationUpdate,
    createdAt,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.currentLatitude == this.currentLatitude &&
          other.currentLongitude == this.currentLongitude &&
          other.visitedRegions == this.visitedRegions &&
          other.totalVisitedCount == this.totalVisitedCount &&
          other.explorationProgress == this.explorationProgress &&
          other.lastLocationUpdate == this.lastLocationUpdate &&
          other.createdAt == this.createdAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class UsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> uid;
  final Value<String> email;
  final Value<double> currentLatitude;
  final Value<double> currentLongitude;
  final Value<String> visitedRegions;
  final Value<int> totalVisitedCount;
  final Value<double> explorationProgress;
  final Value<DateTime?> lastLocationUpdate;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.currentLatitude = const Value.absent(),
    this.currentLongitude = const Value.absent(),
    this.visitedRegions = const Value.absent(),
    this.totalVisitedCount = const Value.absent(),
    this.explorationProgress = const Value.absent(),
    this.lastLocationUpdate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String uid,
    required String email,
    required double currentLatitude,
    required double currentLongitude,
    this.visitedRegions = const Value.absent(),
    this.totalVisitedCount = const Value.absent(),
    this.explorationProgress = const Value.absent(),
    this.lastLocationUpdate = const Value.absent(),
    required DateTime createdAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email),
       currentLatitude = Value(currentLatitude),
       currentLongitude = Value(currentLongitude),
       createdAt = Value(createdAt);
  static Insertable<LocalUser> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<double>? currentLatitude,
    Expression<double>? currentLongitude,
    Expression<String>? visitedRegions,
    Expression<int>? totalVisitedCount,
    Expression<double>? explorationProgress,
    Expression<DateTime>? lastLocationUpdate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (currentLatitude != null) 'current_latitude': currentLatitude,
      if (currentLongitude != null) 'current_longitude': currentLongitude,
      if (visitedRegions != null) 'visited_regions': visitedRegions,
      if (totalVisitedCount != null) 'total_visited_count': totalVisitedCount,
      if (explorationProgress != null)
        'exploration_progress': explorationProgress,
      if (lastLocationUpdate != null)
        'last_location_update': lastLocationUpdate,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? uid,
    Value<String>? email,
    Value<double>? currentLatitude,
    Value<double>? currentLongitude,
    Value<String>? visitedRegions,
    Value<int>? totalVisitedCount,
    Value<double>? explorationProgress,
    Value<DateTime?>? lastLocationUpdate,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      visitedRegions: visitedRegions ?? this.visitedRegions,
      totalVisitedCount: totalVisitedCount ?? this.totalVisitedCount,
      explorationProgress: explorationProgress ?? this.explorationProgress,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      createdAt: createdAt ?? this.createdAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (currentLatitude.present) {
      map['current_latitude'] = Variable<double>(currentLatitude.value);
    }
    if (currentLongitude.present) {
      map['current_longitude'] = Variable<double>(currentLongitude.value);
    }
    if (visitedRegions.present) {
      map['visited_regions'] = Variable<String>(visitedRegions.value);
    }
    if (totalVisitedCount.present) {
      map['total_visited_count'] = Variable<int>(totalVisitedCount.value);
    }
    if (explorationProgress.present) {
      map['exploration_progress'] = Variable<double>(explorationProgress.value);
    }
    if (lastLocationUpdate.present) {
      map['last_location_update'] = Variable<DateTime>(
        lastLocationUpdate.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('currentLatitude: $currentLatitude, ')
          ..write('currentLongitude: $currentLongitude, ')
          ..write('visitedRegions: $visitedRegions, ')
          ..write('totalVisitedCount: $totalVisitedCount, ')
          ..write('explorationProgress: $explorationProgress, ')
          ..write('lastLocationUpdate: $lastLocationUpdate, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PolygonsTable extends Polygons
    with TableInfo<$PolygonsTable, PolygonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PolygonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _docIdMeta = const VerificationMeta('docId');
  @override
  late final GeneratedColumn<String> docId = GeneratedColumn<String>(
    'doc_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sidoMeta = const VerificationMeta('sido');
  @override
  late final GeneratedColumn<int> sido = GeneratedColumn<int>(
    'sido',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sggPrefixMeta = const VerificationMeta(
    'sggPrefix',
  );
  @override
  late final GeneratedColumn<int> sggPrefix = GeneratedColumn<int>(
    'sgg_prefix',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coordinatesJsonMeta = const VerificationMeta(
    'coordinatesJson',
  );
  @override
  late final GeneratedColumn<String> coordinatesJson = GeneratedColumn<String>(
    'coordinates_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    docId,
    sido,
    sggPrefix,
    coordinatesJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'polygons';
  @override
  VerificationContext validateIntegrity(
    Insertable<PolygonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('doc_id')) {
      context.handle(
        _docIdMeta,
        docId.isAcceptableOrUnknown(data['doc_id']!, _docIdMeta),
      );
    } else if (isInserting) {
      context.missing(_docIdMeta);
    }
    if (data.containsKey('sido')) {
      context.handle(
        _sidoMeta,
        sido.isAcceptableOrUnknown(data['sido']!, _sidoMeta),
      );
    } else if (isInserting) {
      context.missing(_sidoMeta);
    }
    if (data.containsKey('sgg_prefix')) {
      context.handle(
        _sggPrefixMeta,
        sggPrefix.isAcceptableOrUnknown(data['sgg_prefix']!, _sggPrefixMeta),
      );
    }
    if (data.containsKey('coordinates_json')) {
      context.handle(
        _coordinatesJsonMeta,
        coordinatesJson.isAcceptableOrUnknown(
          data['coordinates_json']!,
          _coordinatesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coordinatesJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {docId};
  @override
  PolygonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PolygonRow(
      docId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_id'],
      )!,
      sido: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sido'],
      )!,
      sggPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sgg_prefix'],
      ),
      coordinatesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coordinates_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PolygonsTable createAlias(String alias) {
    return $PolygonsTable(attachedDatabase, alias);
  }
}

class PolygonRow extends DataClass implements Insertable<PolygonRow> {
  final String docId;
  final int sido;
  final int? sggPrefix;
  final String coordinatesJson;
  final DateTime updatedAt;
  const PolygonRow({
    required this.docId,
    required this.sido,
    this.sggPrefix,
    required this.coordinatesJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['doc_id'] = Variable<String>(docId);
    map['sido'] = Variable<int>(sido);
    if (!nullToAbsent || sggPrefix != null) {
      map['sgg_prefix'] = Variable<int>(sggPrefix);
    }
    map['coordinates_json'] = Variable<String>(coordinatesJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PolygonsCompanion toCompanion(bool nullToAbsent) {
    return PolygonsCompanion(
      docId: Value(docId),
      sido: Value(sido),
      sggPrefix: sggPrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(sggPrefix),
      coordinatesJson: Value(coordinatesJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory PolygonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PolygonRow(
      docId: serializer.fromJson<String>(json['docId']),
      sido: serializer.fromJson<int>(json['sido']),
      sggPrefix: serializer.fromJson<int?>(json['sggPrefix']),
      coordinatesJson: serializer.fromJson<String>(json['coordinatesJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'docId': serializer.toJson<String>(docId),
      'sido': serializer.toJson<int>(sido),
      'sggPrefix': serializer.toJson<int?>(sggPrefix),
      'coordinatesJson': serializer.toJson<String>(coordinatesJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PolygonRow copyWith({
    String? docId,
    int? sido,
    Value<int?> sggPrefix = const Value.absent(),
    String? coordinatesJson,
    DateTime? updatedAt,
  }) => PolygonRow(
    docId: docId ?? this.docId,
    sido: sido ?? this.sido,
    sggPrefix: sggPrefix.present ? sggPrefix.value : this.sggPrefix,
    coordinatesJson: coordinatesJson ?? this.coordinatesJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PolygonRow copyWithCompanion(PolygonsCompanion data) {
    return PolygonRow(
      docId: data.docId.present ? data.docId.value : this.docId,
      sido: data.sido.present ? data.sido.value : this.sido,
      sggPrefix: data.sggPrefix.present ? data.sggPrefix.value : this.sggPrefix,
      coordinatesJson: data.coordinatesJson.present
          ? data.coordinatesJson.value
          : this.coordinatesJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PolygonRow(')
          ..write('docId: $docId, ')
          ..write('sido: $sido, ')
          ..write('sggPrefix: $sggPrefix, ')
          ..write('coordinatesJson: $coordinatesJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(docId, sido, sggPrefix, coordinatesJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PolygonRow &&
          other.docId == this.docId &&
          other.sido == this.sido &&
          other.sggPrefix == this.sggPrefix &&
          other.coordinatesJson == this.coordinatesJson &&
          other.updatedAt == this.updatedAt);
}

class PolygonsCompanion extends UpdateCompanion<PolygonRow> {
  final Value<String> docId;
  final Value<int> sido;
  final Value<int?> sggPrefix;
  final Value<String> coordinatesJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PolygonsCompanion({
    this.docId = const Value.absent(),
    this.sido = const Value.absent(),
    this.sggPrefix = const Value.absent(),
    this.coordinatesJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PolygonsCompanion.insert({
    required String docId,
    required int sido,
    this.sggPrefix = const Value.absent(),
    required String coordinatesJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : docId = Value(docId),
       sido = Value(sido),
       coordinatesJson = Value(coordinatesJson),
       updatedAt = Value(updatedAt);
  static Insertable<PolygonRow> custom({
    Expression<String>? docId,
    Expression<int>? sido,
    Expression<int>? sggPrefix,
    Expression<String>? coordinatesJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (docId != null) 'doc_id': docId,
      if (sido != null) 'sido': sido,
      if (sggPrefix != null) 'sgg_prefix': sggPrefix,
      if (coordinatesJson != null) 'coordinates_json': coordinatesJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PolygonsCompanion copyWith({
    Value<String>? docId,
    Value<int>? sido,
    Value<int?>? sggPrefix,
    Value<String>? coordinatesJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PolygonsCompanion(
      docId: docId ?? this.docId,
      sido: sido ?? this.sido,
      sggPrefix: sggPrefix ?? this.sggPrefix,
      coordinatesJson: coordinatesJson ?? this.coordinatesJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (docId.present) {
      map['doc_id'] = Variable<String>(docId.value);
    }
    if (sido.present) {
      map['sido'] = Variable<int>(sido.value);
    }
    if (sggPrefix.present) {
      map['sgg_prefix'] = Variable<int>(sggPrefix.value);
    }
    if (coordinatesJson.present) {
      map['coordinates_json'] = Variable<String>(coordinatesJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PolygonsCompanion(')
          ..write('docId: $docId, ')
          ..write('sido: $sido, ')
          ..write('sggPrefix: $sggPrefix, ')
          ..write('coordinatesJson: $coordinatesJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PolygonsTable polygons = $PolygonsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, polygons];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String uid,
      required String email,
      required double currentLatitude,
      required double currentLongitude,
      Value<String> visitedRegions,
      Value<int> totalVisitedCount,
      Value<double> explorationProgress,
      Value<DateTime?> lastLocationUpdate,
      required DateTime createdAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> uid,
      Value<String> email,
      Value<double> currentLatitude,
      Value<double> currentLongitude,
      Value<String> visitedRegions,
      Value<int> totalVisitedCount,
      Value<double> explorationProgress,
      Value<DateTime?> lastLocationUpdate,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentLatitude => $composableBuilder(
    column: $table.currentLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentLongitude => $composableBuilder(
    column: $table.currentLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get explorationProgress => $composableBuilder(
    column: $table.explorationProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentLatitude => $composableBuilder(
    column: $table.currentLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentLongitude => $composableBuilder(
    column: $table.currentLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get explorationProgress => $composableBuilder(
    column: $table.explorationProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<double> get currentLatitude => $composableBuilder(
    column: $table.currentLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentLongitude => $composableBuilder(
    column: $table.currentLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get explorationProgress => $composableBuilder(
    column: $table.explorationProgress,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          LocalUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (LocalUser, BaseReferences<_$AppDatabase, $UsersTable, LocalUser>),
          LocalUser,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<double> currentLatitude = const Value.absent(),
                Value<double> currentLongitude = const Value.absent(),
                Value<String> visitedRegions = const Value.absent(),
                Value<int> totalVisitedCount = const Value.absent(),
                Value<double> explorationProgress = const Value.absent(),
                Value<DateTime?> lastLocationUpdate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                uid: uid,
                email: email,
                currentLatitude: currentLatitude,
                currentLongitude: currentLongitude,
                visitedRegions: visitedRegions,
                totalVisitedCount: totalVisitedCount,
                explorationProgress: explorationProgress,
                lastLocationUpdate: lastLocationUpdate,
                createdAt: createdAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String email,
                required double currentLatitude,
                required double currentLongitude,
                Value<String> visitedRegions = const Value.absent(),
                Value<int> totalVisitedCount = const Value.absent(),
                Value<double> explorationProgress = const Value.absent(),
                Value<DateTime?> lastLocationUpdate = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                uid: uid,
                email: email,
                currentLatitude: currentLatitude,
                currentLongitude: currentLongitude,
                visitedRegions: visitedRegions,
                totalVisitedCount: totalVisitedCount,
                explorationProgress: explorationProgress,
                lastLocationUpdate: lastLocationUpdate,
                createdAt: createdAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      LocalUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (LocalUser, BaseReferences<_$AppDatabase, $UsersTable, LocalUser>),
      LocalUser,
      PrefetchHooks Function()
    >;
typedef $$PolygonsTableCreateCompanionBuilder =
    PolygonsCompanion Function({
      required String docId,
      required int sido,
      Value<int?> sggPrefix,
      required String coordinatesJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PolygonsTableUpdateCompanionBuilder =
    PolygonsCompanion Function({
      Value<String> docId,
      Value<int> sido,
      Value<int?> sggPrefix,
      Value<String> coordinatesJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PolygonsTableFilterComposer
    extends Composer<_$AppDatabase, $PolygonsTable> {
  $$PolygonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get docId => $composableBuilder(
    column: $table.docId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sido => $composableBuilder(
    column: $table.sido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sggPrefix => $composableBuilder(
    column: $table.sggPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PolygonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PolygonsTable> {
  $$PolygonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get docId => $composableBuilder(
    column: $table.docId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sido => $composableBuilder(
    column: $table.sido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sggPrefix => $composableBuilder(
    column: $table.sggPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PolygonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PolygonsTable> {
  $$PolygonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get docId =>
      $composableBuilder(column: $table.docId, builder: (column) => column);

  GeneratedColumn<int> get sido =>
      $composableBuilder(column: $table.sido, builder: (column) => column);

  GeneratedColumn<int> get sggPrefix =>
      $composableBuilder(column: $table.sggPrefix, builder: (column) => column);

  GeneratedColumn<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PolygonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PolygonsTable,
          PolygonRow,
          $$PolygonsTableFilterComposer,
          $$PolygonsTableOrderingComposer,
          $$PolygonsTableAnnotationComposer,
          $$PolygonsTableCreateCompanionBuilder,
          $$PolygonsTableUpdateCompanionBuilder,
          (
            PolygonRow,
            BaseReferences<_$AppDatabase, $PolygonsTable, PolygonRow>,
          ),
          PolygonRow,
          PrefetchHooks Function()
        > {
  $$PolygonsTableTableManager(_$AppDatabase db, $PolygonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PolygonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PolygonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PolygonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> docId = const Value.absent(),
                Value<int> sido = const Value.absent(),
                Value<int?> sggPrefix = const Value.absent(),
                Value<String> coordinatesJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PolygonsCompanion(
                docId: docId,
                sido: sido,
                sggPrefix: sggPrefix,
                coordinatesJson: coordinatesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String docId,
                required int sido,
                Value<int?> sggPrefix = const Value.absent(),
                required String coordinatesJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PolygonsCompanion.insert(
                docId: docId,
                sido: sido,
                sggPrefix: sggPrefix,
                coordinatesJson: coordinatesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PolygonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PolygonsTable,
      PolygonRow,
      $$PolygonsTableFilterComposer,
      $$PolygonsTableOrderingComposer,
      $$PolygonsTableAnnotationComposer,
      $$PolygonsTableCreateCompanionBuilder,
      $$PolygonsTableUpdateCompanionBuilder,
      (PolygonRow, BaseReferences<_$AppDatabase, $PolygonsTable, PolygonRow>),
      PolygonRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PolygonsTableTableManager get polygons =>
      $$PolygonsTableTableManager(_db, _db.polygons);
}
