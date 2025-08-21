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

class $ParkourSpotsTable extends ParkourSpots
    with TableInfo<$ParkourSpotsTable, ParkourSpotEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParkourSpotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    id,
    name,
    description,
    address,
    latitude,
    longitude,
    category,
    difficulty,
    imageUrls,
    tags,
    rating,
    reviewCount,
    isVerified,
    createdAt,
    updatedAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parkour_spots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParkourSpotEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParkourSpotEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParkourSpotEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      )!,
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $ParkourSpotsTable createAlias(String alias) {
    return $ParkourSpotsTable(attachedDatabase, alias);
  }
}

class ParkourSpotEntity extends DataClass
    implements Insertable<ParkourSpotEntity> {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final double latitude;
  final double longitude;
  final String category;
  final String? difficulty;
  final String imageUrls;
  final String tags;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncAt;
  const ParkourSpotEntity({
    required this.id,
    required this.name,
    this.description,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.difficulty,
    required this.imageUrls,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['image_urls'] = Variable<String>(imageUrls);
    map['tags'] = Variable<String>(tags);
    map['rating'] = Variable<double>(rating);
    map['review_count'] = Variable<int>(reviewCount);
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  ParkourSpotsCompanion toCompanion(bool nullToAbsent) {
    return ParkourSpotsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      latitude: Value(latitude),
      longitude: Value(longitude),
      category: Value(category),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      imageUrls: Value(imageUrls),
      tags: Value(tags),
      rating: Value(rating),
      reviewCount: Value(reviewCount),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory ParkourSpotEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParkourSpotEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      address: serializer.fromJson<String?>(json['address']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      category: serializer.fromJson<String>(json['category']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      imageUrls: serializer.fromJson<String>(json['imageUrls']),
      tags: serializer.fromJson<String>(json['tags']),
      rating: serializer.fromJson<double>(json['rating']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'address': serializer.toJson<String?>(address),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'category': serializer.toJson<String>(category),
      'difficulty': serializer.toJson<String?>(difficulty),
      'imageUrls': serializer.toJson<String>(imageUrls),
      'tags': serializer.toJson<String>(tags),
      'rating': serializer.toJson<double>(rating),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  ParkourSpotEntity copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> address = const Value.absent(),
    double? latitude,
    double? longitude,
    String? category,
    Value<String?> difficulty = const Value.absent(),
    String? imageUrls,
    String? tags,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => ParkourSpotEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    address: address.present ? address.value : this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    category: category ?? this.category,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    imageUrls: imageUrls ?? this.imageUrls,
    tags: tags ?? this.tags,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  ParkourSpotEntity copyWithCompanion(ParkourSpotsCompanion data) {
    return ParkourSpotEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      tags: data.tags.present ? data.tags.value : this.tags,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParkourSpotEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('tags: $tags, ')
          ..write('rating: $rating, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    address,
    latitude,
    longitude,
    category,
    difficulty,
    imageUrls,
    tags,
    rating,
    reviewCount,
    isVerified,
    createdAt,
    updatedAt,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParkourSpotEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.imageUrls == this.imageUrls &&
          other.tags == this.tags &&
          other.rating == this.rating &&
          other.reviewCount == this.reviewCount &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class ParkourSpotsCompanion extends UpdateCompanion<ParkourSpotEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> address;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> category;
  final Value<String?> difficulty;
  final Value<String> imageUrls;
  final Value<String> tags;
  final Value<double> rating;
  final Value<int> reviewCount;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const ParkourSpotsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.tags = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParkourSpotsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    required double latitude,
    required double longitude,
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.tags = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.isVerified = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       latitude = Value(latitude),
       longitude = Value(longitude),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ParkourSpotEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<String>? imageUrls,
    Expression<String>? tags,
    Expression<double>? rating,
    Expression<int>? reviewCount,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (tags != null) 'tags': tags,
      if (rating != null) 'rating': rating,
      if (reviewCount != null) 'review_count': reviewCount,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParkourSpotsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? address,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? category,
    Value<String?>? difficulty,
    Value<String>? imageUrls,
    Value<String>? tags,
    Value<double>? rating,
    Value<int>? reviewCount,
    Value<bool>? isVerified,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return ParkourSpotsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('ParkourSpotsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('tags: $tags, ')
          ..write('rating: $rating, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParkourSpotIndicesTable extends ParkourSpotIndices
    with TableInfo<$ParkourSpotIndicesTable, ParkourSpotIndexEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParkourSpotIndicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _spotIdMeta = const VerificationMeta('spotId');
  @override
  late final GeneratedColumn<String> spotId = GeneratedColumn<String>(
    'spot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTermMeta = const VerificationMeta(
    'searchTerm',
  );
  @override
  late final GeneratedColumn<String> searchTerm = GeneratedColumn<String>(
    'search_term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _termTypeMeta = const VerificationMeta(
    'termType',
  );
  @override
  late final GeneratedColumn<int> termType = GeneratedColumn<int>(
    'term_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [spotId, searchTerm, termType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parkour_spot_indices';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParkourSpotIndexEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('spot_id')) {
      context.handle(
        _spotIdMeta,
        spotId.isAcceptableOrUnknown(data['spot_id']!, _spotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotIdMeta);
    }
    if (data.containsKey('search_term')) {
      context.handle(
        _searchTermMeta,
        searchTerm.isAcceptableOrUnknown(data['search_term']!, _searchTermMeta),
      );
    } else if (isInserting) {
      context.missing(_searchTermMeta);
    }
    if (data.containsKey('term_type')) {
      context.handle(
        _termTypeMeta,
        termType.isAcceptableOrUnknown(data['term_type']!, _termTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_termTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {spotId, searchTerm, termType};
  @override
  ParkourSpotIndexEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParkourSpotIndexEntity(
      spotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_id'],
      )!,
      searchTerm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_term'],
      )!,
      termType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}term_type'],
      )!,
    );
  }

  @override
  $ParkourSpotIndicesTable createAlias(String alias) {
    return $ParkourSpotIndicesTable(attachedDatabase, alias);
  }
}

class ParkourSpotIndexEntity extends DataClass
    implements Insertable<ParkourSpotIndexEntity> {
  final String spotId;
  final String searchTerm;
  final int termType;
  const ParkourSpotIndexEntity({
    required this.spotId,
    required this.searchTerm,
    required this.termType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['spot_id'] = Variable<String>(spotId);
    map['search_term'] = Variable<String>(searchTerm);
    map['term_type'] = Variable<int>(termType);
    return map;
  }

  ParkourSpotIndicesCompanion toCompanion(bool nullToAbsent) {
    return ParkourSpotIndicesCompanion(
      spotId: Value(spotId),
      searchTerm: Value(searchTerm),
      termType: Value(termType),
    );
  }

  factory ParkourSpotIndexEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParkourSpotIndexEntity(
      spotId: serializer.fromJson<String>(json['spotId']),
      searchTerm: serializer.fromJson<String>(json['searchTerm']),
      termType: serializer.fromJson<int>(json['termType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'spotId': serializer.toJson<String>(spotId),
      'searchTerm': serializer.toJson<String>(searchTerm),
      'termType': serializer.toJson<int>(termType),
    };
  }

  ParkourSpotIndexEntity copyWith({
    String? spotId,
    String? searchTerm,
    int? termType,
  }) => ParkourSpotIndexEntity(
    spotId: spotId ?? this.spotId,
    searchTerm: searchTerm ?? this.searchTerm,
    termType: termType ?? this.termType,
  );
  ParkourSpotIndexEntity copyWithCompanion(ParkourSpotIndicesCompanion data) {
    return ParkourSpotIndexEntity(
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      searchTerm: data.searchTerm.present
          ? data.searchTerm.value
          : this.searchTerm,
      termType: data.termType.present ? data.termType.value : this.termType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParkourSpotIndexEntity(')
          ..write('spotId: $spotId, ')
          ..write('searchTerm: $searchTerm, ')
          ..write('termType: $termType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(spotId, searchTerm, termType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParkourSpotIndexEntity &&
          other.spotId == this.spotId &&
          other.searchTerm == this.searchTerm &&
          other.termType == this.termType);
}

class ParkourSpotIndicesCompanion
    extends UpdateCompanion<ParkourSpotIndexEntity> {
  final Value<String> spotId;
  final Value<String> searchTerm;
  final Value<int> termType;
  final Value<int> rowid;
  const ParkourSpotIndicesCompanion({
    this.spotId = const Value.absent(),
    this.searchTerm = const Value.absent(),
    this.termType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParkourSpotIndicesCompanion.insert({
    required String spotId,
    required String searchTerm,
    required int termType,
    this.rowid = const Value.absent(),
  }) : spotId = Value(spotId),
       searchTerm = Value(searchTerm),
       termType = Value(termType);
  static Insertable<ParkourSpotIndexEntity> custom({
    Expression<String>? spotId,
    Expression<String>? searchTerm,
    Expression<int>? termType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (spotId != null) 'spot_id': spotId,
      if (searchTerm != null) 'search_term': searchTerm,
      if (termType != null) 'term_type': termType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParkourSpotIndicesCompanion copyWith({
    Value<String>? spotId,
    Value<String>? searchTerm,
    Value<int>? termType,
    Value<int>? rowid,
  }) {
    return ParkourSpotIndicesCompanion(
      spotId: spotId ?? this.spotId,
      searchTerm: searchTerm ?? this.searchTerm,
      termType: termType ?? this.termType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (spotId.present) {
      map['spot_id'] = Variable<String>(spotId.value);
    }
    if (searchTerm.present) {
      map['search_term'] = Variable<String>(searchTerm.value);
    }
    if (termType.present) {
      map['term_type'] = Variable<int>(termType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParkourSpotIndicesCompanion(')
          ..write('spotId: $spotId, ')
          ..write('searchTerm: $searchTerm, ')
          ..write('termType: $termType, ')
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
  late final $ParkourSpotsTable parkourSpots = $ParkourSpotsTable(this);
  late final $ParkourSpotIndicesTable parkourSpotIndices =
      $ParkourSpotIndicesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    polygons,
    parkourSpots,
    parkourSpotIndices,
  ];
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
typedef $$ParkourSpotsTableCreateCompanionBuilder =
    ParkourSpotsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String?> address,
      required double latitude,
      required double longitude,
      Value<String> category,
      Value<String?> difficulty,
      Value<String> imageUrls,
      Value<String> tags,
      Value<double> rating,
      Value<int> reviewCount,
      Value<bool> isVerified,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$ParkourSpotsTableUpdateCompanionBuilder =
    ParkourSpotsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> address,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> category,
      Value<String?> difficulty,
      Value<String> imageUrls,
      Value<String> tags,
      Value<double> rating,
      Value<int> reviewCount,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

class $$ParkourSpotsTableFilterComposer
    extends Composer<_$AppDatabase, $ParkourSpotsTable> {
  $$ParkourSpotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParkourSpotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParkourSpotsTable> {
  $$ParkourSpotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParkourSpotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParkourSpotsTable> {
  $$ParkourSpotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$ParkourSpotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParkourSpotsTable,
          ParkourSpotEntity,
          $$ParkourSpotsTableFilterComposer,
          $$ParkourSpotsTableOrderingComposer,
          $$ParkourSpotsTableAnnotationComposer,
          $$ParkourSpotsTableCreateCompanionBuilder,
          $$ParkourSpotsTableUpdateCompanionBuilder,
          (
            ParkourSpotEntity,
            BaseReferences<
              _$AppDatabase,
              $ParkourSpotsTable,
              ParkourSpotEntity
            >,
          ),
          ParkourSpotEntity,
          PrefetchHooks Function()
        > {
  $$ParkourSpotsTableTableManager(_$AppDatabase db, $ParkourSpotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParkourSpotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParkourSpotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParkourSpotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<String> imageUrls = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParkourSpotsCompanion(
                id: id,
                name: name,
                description: description,
                address: address,
                latitude: latitude,
                longitude: longitude,
                category: category,
                difficulty: difficulty,
                imageUrls: imageUrls,
                tags: tags,
                rating: rating,
                reviewCount: reviewCount,
                isVerified: isVerified,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<String> category = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<String> imageUrls = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParkourSpotsCompanion.insert(
                id: id,
                name: name,
                description: description,
                address: address,
                latitude: latitude,
                longitude: longitude,
                category: category,
                difficulty: difficulty,
                imageUrls: imageUrls,
                tags: tags,
                rating: rating,
                reviewCount: reviewCount,
                isVerified: isVerified,
                createdAt: createdAt,
                updatedAt: updatedAt,
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

typedef $$ParkourSpotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParkourSpotsTable,
      ParkourSpotEntity,
      $$ParkourSpotsTableFilterComposer,
      $$ParkourSpotsTableOrderingComposer,
      $$ParkourSpotsTableAnnotationComposer,
      $$ParkourSpotsTableCreateCompanionBuilder,
      $$ParkourSpotsTableUpdateCompanionBuilder,
      (
        ParkourSpotEntity,
        BaseReferences<_$AppDatabase, $ParkourSpotsTable, ParkourSpotEntity>,
      ),
      ParkourSpotEntity,
      PrefetchHooks Function()
    >;
typedef $$ParkourSpotIndicesTableCreateCompanionBuilder =
    ParkourSpotIndicesCompanion Function({
      required String spotId,
      required String searchTerm,
      required int termType,
      Value<int> rowid,
    });
typedef $$ParkourSpotIndicesTableUpdateCompanionBuilder =
    ParkourSpotIndicesCompanion Function({
      Value<String> spotId,
      Value<String> searchTerm,
      Value<int> termType,
      Value<int> rowid,
    });

class $$ParkourSpotIndicesTableFilterComposer
    extends Composer<_$AppDatabase, $ParkourSpotIndicesTable> {
  $$ParkourSpotIndicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchTerm => $composableBuilder(
    column: $table.searchTerm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get termType => $composableBuilder(
    column: $table.termType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParkourSpotIndicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ParkourSpotIndicesTable> {
  $$ParkourSpotIndicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchTerm => $composableBuilder(
    column: $table.searchTerm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get termType => $composableBuilder(
    column: $table.termType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParkourSpotIndicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParkourSpotIndicesTable> {
  $$ParkourSpotIndicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get spotId =>
      $composableBuilder(column: $table.spotId, builder: (column) => column);

  GeneratedColumn<String> get searchTerm => $composableBuilder(
    column: $table.searchTerm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get termType =>
      $composableBuilder(column: $table.termType, builder: (column) => column);
}

class $$ParkourSpotIndicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParkourSpotIndicesTable,
          ParkourSpotIndexEntity,
          $$ParkourSpotIndicesTableFilterComposer,
          $$ParkourSpotIndicesTableOrderingComposer,
          $$ParkourSpotIndicesTableAnnotationComposer,
          $$ParkourSpotIndicesTableCreateCompanionBuilder,
          $$ParkourSpotIndicesTableUpdateCompanionBuilder,
          (
            ParkourSpotIndexEntity,
            BaseReferences<
              _$AppDatabase,
              $ParkourSpotIndicesTable,
              ParkourSpotIndexEntity
            >,
          ),
          ParkourSpotIndexEntity,
          PrefetchHooks Function()
        > {
  $$ParkourSpotIndicesTableTableManager(
    _$AppDatabase db,
    $ParkourSpotIndicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParkourSpotIndicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParkourSpotIndicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParkourSpotIndicesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> spotId = const Value.absent(),
                Value<String> searchTerm = const Value.absent(),
                Value<int> termType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParkourSpotIndicesCompanion(
                spotId: spotId,
                searchTerm: searchTerm,
                termType: termType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String spotId,
                required String searchTerm,
                required int termType,
                Value<int> rowid = const Value.absent(),
              }) => ParkourSpotIndicesCompanion.insert(
                spotId: spotId,
                searchTerm: searchTerm,
                termType: termType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParkourSpotIndicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParkourSpotIndicesTable,
      ParkourSpotIndexEntity,
      $$ParkourSpotIndicesTableFilterComposer,
      $$ParkourSpotIndicesTableOrderingComposer,
      $$ParkourSpotIndicesTableAnnotationComposer,
      $$ParkourSpotIndicesTableCreateCompanionBuilder,
      $$ParkourSpotIndicesTableUpdateCompanionBuilder,
      (
        ParkourSpotIndexEntity,
        BaseReferences<
          _$AppDatabase,
          $ParkourSpotIndicesTable,
          ParkourSpotIndexEntity
        >,
      ),
      ParkourSpotIndexEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PolygonsTableTableManager get polygons =>
      $$PolygonsTableTableManager(_db, _db.polygons);
  $$ParkourSpotsTableTableManager get parkourSpots =>
      $$ParkourSpotsTableTableManager(_db, _db.parkourSpots);
  $$ParkourSpotIndicesTableTableManager get parkourSpotIndices =>
      $$ParkourSpotIndicesTableTableManager(_db, _db.parkourSpotIndices);
}
