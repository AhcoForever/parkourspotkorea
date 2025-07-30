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
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parkourProficiencyMeta =
      const VerificationMeta('parkourProficiency');
  @override
  late final GeneratedColumn<String> parkourProficiency =
      GeneratedColumn<String>(
        'parkour_proficiency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _signupDateMeta = const VerificationMeta(
    'signupDate',
  );
  @override
  late final GeneratedColumn<DateTime> signupDate = GeneratedColumn<DateTime>(
    'signup_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLoginMeta = const VerificationMeta(
    'lastLogin',
  );
  @override
  late final GeneratedColumn<DateTime> lastLogin = GeneratedColumn<DateTime>(
    'last_login',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumMeta = const VerificationMeta(
    'phoneNum',
  );
  @override
  late final GeneratedColumn<int> phoneNum = GeneratedColumn<int>(
    'phone_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _favoriteSpotIDMeta = const VerificationMeta(
    'favoriteSpotID',
  );
  @override
  late final GeneratedColumn<String> favoriteSpotID = GeneratedColumn<String>(
    'favorite_spot_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userImageMeta = const VerificationMeta(
    'userImage',
  );
  @override
  late final GeneratedColumn<String> userImage = GeneratedColumn<String>(
    'user_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
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
  static const VerificationMeta _visitedRegionsMeta = const VerificationMeta(
    'visitedRegions',
  );
  @override
  late final GeneratedColumn<String> visitedRegions = GeneratedColumn<String>(
    'visited_regions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    displayName,
    parkourProficiency,
    signupDate,
    lastLogin,
    status,
    age,
    phoneNum,
    favoriteSpotID,
    userImage,
    placeId,
    latitude,
    longitude,
    visitedRegions,
    totalVisitedCount,
    lastLocationUpdate,
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
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('parkour_proficiency')) {
      context.handle(
        _parkourProficiencyMeta,
        parkourProficiency.isAcceptableOrUnknown(
          data['parkour_proficiency']!,
          _parkourProficiencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parkourProficiencyMeta);
    }
    if (data.containsKey('signup_date')) {
      context.handle(
        _signupDateMeta,
        signupDate.isAcceptableOrUnknown(data['signup_date']!, _signupDateMeta),
      );
    } else if (isInserting) {
      context.missing(_signupDateMeta);
    }
    if (data.containsKey('last_login')) {
      context.handle(
        _lastLoginMeta,
        lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta),
      );
    } else if (isInserting) {
      context.missing(_lastLoginMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('phone_num')) {
      context.handle(
        _phoneNumMeta,
        phoneNum.isAcceptableOrUnknown(data['phone_num']!, _phoneNumMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneNumMeta);
    }
    if (data.containsKey('favorite_spot_i_d')) {
      context.handle(
        _favoriteSpotIDMeta,
        favoriteSpotID.isAcceptableOrUnknown(
          data['favorite_spot_i_d']!,
          _favoriteSpotIDMeta,
        ),
      );
    }
    if (data.containsKey('user_image')) {
      context.handle(
        _userImageMeta,
        userImage.isAcceptableOrUnknown(data['user_image']!, _userImageMeta),
      );
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
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
    if (data.containsKey('last_location_update')) {
      context.handle(
        _lastLocationUpdateMeta,
        lastLocationUpdate.isAcceptableOrUnknown(
          data['last_location_update']!,
          _lastLocationUpdateMeta,
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
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      parkourProficiency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parkour_proficiency'],
      )!,
      signupDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signup_date'],
      )!,
      lastLogin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      phoneNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phone_num'],
      )!,
      favoriteSpotID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_spot_i_d'],
      ),
      userImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_image'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      visitedRegions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visited_regions'],
      ),
      totalVisitedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_visited_count'],
      )!,
      lastLocationUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_location_update'],
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
  final String displayName;
  final String parkourProficiency;
  final DateTime signupDate;
  final DateTime lastLogin;
  final String status;
  final int age;
  final int phoneNum;
  final String? favoriteSpotID;
  final String? userImage;
  final String? placeId;
  final double latitude;
  final double longitude;
  final String? visitedRegions;
  final int totalVisitedCount;
  final DateTime? lastLocationUpdate;
  const LocalUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.parkourProficiency,
    required this.signupDate,
    required this.lastLogin,
    required this.status,
    required this.age,
    required this.phoneNum,
    this.favoriteSpotID,
    this.userImage,
    this.placeId,
    required this.latitude,
    required this.longitude,
    this.visitedRegions,
    required this.totalVisitedCount,
    this.lastLocationUpdate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    map['parkour_proficiency'] = Variable<String>(parkourProficiency);
    map['signup_date'] = Variable<DateTime>(signupDate);
    map['last_login'] = Variable<DateTime>(lastLogin);
    map['status'] = Variable<String>(status);
    map['age'] = Variable<int>(age);
    map['phone_num'] = Variable<int>(phoneNum);
    if (!nullToAbsent || favoriteSpotID != null) {
      map['favorite_spot_i_d'] = Variable<String>(favoriteSpotID);
    }
    if (!nullToAbsent || userImage != null) {
      map['user_image'] = Variable<String>(userImage);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<String>(placeId);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || visitedRegions != null) {
      map['visited_regions'] = Variable<String>(visitedRegions);
    }
    map['total_visited_count'] = Variable<int>(totalVisitedCount);
    if (!nullToAbsent || lastLocationUpdate != null) {
      map['last_location_update'] = Variable<DateTime>(lastLocationUpdate);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      uid: Value(uid),
      email: Value(email),
      displayName: Value(displayName),
      parkourProficiency: Value(parkourProficiency),
      signupDate: Value(signupDate),
      lastLogin: Value(lastLogin),
      status: Value(status),
      age: Value(age),
      phoneNum: Value(phoneNum),
      favoriteSpotID: favoriteSpotID == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteSpotID),
      userImage: userImage == null && nullToAbsent
          ? const Value.absent()
          : Value(userImage),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      visitedRegions: visitedRegions == null && nullToAbsent
          ? const Value.absent()
          : Value(visitedRegions),
      totalVisitedCount: Value(totalVisitedCount),
      lastLocationUpdate: lastLocationUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLocationUpdate),
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
      displayName: serializer.fromJson<String>(json['displayName']),
      parkourProficiency: serializer.fromJson<String>(
        json['parkourProficiency'],
      ),
      signupDate: serializer.fromJson<DateTime>(json['signupDate']),
      lastLogin: serializer.fromJson<DateTime>(json['lastLogin']),
      status: serializer.fromJson<String>(json['status']),
      age: serializer.fromJson<int>(json['age']),
      phoneNum: serializer.fromJson<int>(json['phoneNum']),
      favoriteSpotID: serializer.fromJson<String?>(json['favoriteSpotID']),
      userImage: serializer.fromJson<String?>(json['userImage']),
      placeId: serializer.fromJson<String?>(json['placeId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      visitedRegions: serializer.fromJson<String?>(json['visitedRegions']),
      totalVisitedCount: serializer.fromJson<int>(json['totalVisitedCount']),
      lastLocationUpdate: serializer.fromJson<DateTime?>(
        json['lastLocationUpdate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'parkourProficiency': serializer.toJson<String>(parkourProficiency),
      'signupDate': serializer.toJson<DateTime>(signupDate),
      'lastLogin': serializer.toJson<DateTime>(lastLogin),
      'status': serializer.toJson<String>(status),
      'age': serializer.toJson<int>(age),
      'phoneNum': serializer.toJson<int>(phoneNum),
      'favoriteSpotID': serializer.toJson<String?>(favoriteSpotID),
      'userImage': serializer.toJson<String?>(userImage),
      'placeId': serializer.toJson<String?>(placeId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'visitedRegions': serializer.toJson<String?>(visitedRegions),
      'totalVisitedCount': serializer.toJson<int>(totalVisitedCount),
      'lastLocationUpdate': serializer.toJson<DateTime?>(lastLocationUpdate),
    };
  }

  LocalUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? parkourProficiency,
    DateTime? signupDate,
    DateTime? lastLogin,
    String? status,
    int? age,
    int? phoneNum,
    Value<String?> favoriteSpotID = const Value.absent(),
    Value<String?> userImage = const Value.absent(),
    Value<String?> placeId = const Value.absent(),
    double? latitude,
    double? longitude,
    Value<String?> visitedRegions = const Value.absent(),
    int? totalVisitedCount,
    Value<DateTime?> lastLocationUpdate = const Value.absent(),
  }) => LocalUser(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    parkourProficiency: parkourProficiency ?? this.parkourProficiency,
    signupDate: signupDate ?? this.signupDate,
    lastLogin: lastLogin ?? this.lastLogin,
    status: status ?? this.status,
    age: age ?? this.age,
    phoneNum: phoneNum ?? this.phoneNum,
    favoriteSpotID: favoriteSpotID.present
        ? favoriteSpotID.value
        : this.favoriteSpotID,
    userImage: userImage.present ? userImage.value : this.userImage,
    placeId: placeId.present ? placeId.value : this.placeId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    visitedRegions: visitedRegions.present
        ? visitedRegions.value
        : this.visitedRegions,
    totalVisitedCount: totalVisitedCount ?? this.totalVisitedCount,
    lastLocationUpdate: lastLocationUpdate.present
        ? lastLocationUpdate.value
        : this.lastLocationUpdate,
  );
  LocalUser copyWithCompanion(UsersCompanion data) {
    return LocalUser(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      parkourProficiency: data.parkourProficiency.present
          ? data.parkourProficiency.value
          : this.parkourProficiency,
      signupDate: data.signupDate.present
          ? data.signupDate.value
          : this.signupDate,
      lastLogin: data.lastLogin.present ? data.lastLogin.value : this.lastLogin,
      status: data.status.present ? data.status.value : this.status,
      age: data.age.present ? data.age.value : this.age,
      phoneNum: data.phoneNum.present ? data.phoneNum.value : this.phoneNum,
      favoriteSpotID: data.favoriteSpotID.present
          ? data.favoriteSpotID.value
          : this.favoriteSpotID,
      userImage: data.userImage.present ? data.userImage.value : this.userImage,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      visitedRegions: data.visitedRegions.present
          ? data.visitedRegions.value
          : this.visitedRegions,
      totalVisitedCount: data.totalVisitedCount.present
          ? data.totalVisitedCount.value
          : this.totalVisitedCount,
      lastLocationUpdate: data.lastLocationUpdate.present
          ? data.lastLocationUpdate.value
          : this.lastLocationUpdate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('parkourProficiency: $parkourProficiency, ')
          ..write('signupDate: $signupDate, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('status: $status, ')
          ..write('age: $age, ')
          ..write('phoneNum: $phoneNum, ')
          ..write('favoriteSpotID: $favoriteSpotID, ')
          ..write('userImage: $userImage, ')
          ..write('placeId: $placeId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('visitedRegions: $visitedRegions, ')
          ..write('totalVisitedCount: $totalVisitedCount, ')
          ..write('lastLocationUpdate: $lastLocationUpdate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    email,
    displayName,
    parkourProficiency,
    signupDate,
    lastLogin,
    status,
    age,
    phoneNum,
    favoriteSpotID,
    userImage,
    placeId,
    latitude,
    longitude,
    visitedRegions,
    totalVisitedCount,
    lastLocationUpdate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.parkourProficiency == this.parkourProficiency &&
          other.signupDate == this.signupDate &&
          other.lastLogin == this.lastLogin &&
          other.status == this.status &&
          other.age == this.age &&
          other.phoneNum == this.phoneNum &&
          other.favoriteSpotID == this.favoriteSpotID &&
          other.userImage == this.userImage &&
          other.placeId == this.placeId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.visitedRegions == this.visitedRegions &&
          other.totalVisitedCount == this.totalVisitedCount &&
          other.lastLocationUpdate == this.lastLocationUpdate);
}

class UsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> uid;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String> parkourProficiency;
  final Value<DateTime> signupDate;
  final Value<DateTime> lastLogin;
  final Value<String> status;
  final Value<int> age;
  final Value<int> phoneNum;
  final Value<String?> favoriteSpotID;
  final Value<String?> userImage;
  final Value<String?> placeId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> visitedRegions;
  final Value<int> totalVisitedCount;
  final Value<DateTime?> lastLocationUpdate;
  final Value<int> rowid;
  const UsersCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.parkourProficiency = const Value.absent(),
    this.signupDate = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.status = const Value.absent(),
    this.age = const Value.absent(),
    this.phoneNum = const Value.absent(),
    this.favoriteSpotID = const Value.absent(),
    this.userImage = const Value.absent(),
    this.placeId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.visitedRegions = const Value.absent(),
    this.totalVisitedCount = const Value.absent(),
    this.lastLocationUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String uid,
    required String email,
    required String displayName,
    required String parkourProficiency,
    required DateTime signupDate,
    required DateTime lastLogin,
    required String status,
    required int age,
    required int phoneNum,
    this.favoriteSpotID = const Value.absent(),
    this.userImage = const Value.absent(),
    this.placeId = const Value.absent(),
    required double latitude,
    required double longitude,
    this.visitedRegions = const Value.absent(),
    this.totalVisitedCount = const Value.absent(),
    this.lastLocationUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email),
       displayName = Value(displayName),
       parkourProficiency = Value(parkourProficiency),
       signupDate = Value(signupDate),
       lastLogin = Value(lastLogin),
       status = Value(status),
       age = Value(age),
       phoneNum = Value(phoneNum),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<LocalUser> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? parkourProficiency,
    Expression<DateTime>? signupDate,
    Expression<DateTime>? lastLogin,
    Expression<String>? status,
    Expression<int>? age,
    Expression<int>? phoneNum,
    Expression<String>? favoriteSpotID,
    Expression<String>? userImage,
    Expression<String>? placeId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? visitedRegions,
    Expression<int>? totalVisitedCount,
    Expression<DateTime>? lastLocationUpdate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (parkourProficiency != null) 'parkour_proficiency': parkourProficiency,
      if (signupDate != null) 'signup_date': signupDate,
      if (lastLogin != null) 'last_login': lastLogin,
      if (status != null) 'status': status,
      if (age != null) 'age': age,
      if (phoneNum != null) 'phone_num': phoneNum,
      if (favoriteSpotID != null) 'favorite_spot_i_d': favoriteSpotID,
      if (userImage != null) 'user_image': userImage,
      if (placeId != null) 'place_id': placeId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (visitedRegions != null) 'visited_regions': visitedRegions,
      if (totalVisitedCount != null) 'total_visited_count': totalVisitedCount,
      if (lastLocationUpdate != null)
        'last_location_update': lastLocationUpdate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? uid,
    Value<String>? email,
    Value<String>? displayName,
    Value<String>? parkourProficiency,
    Value<DateTime>? signupDate,
    Value<DateTime>? lastLogin,
    Value<String>? status,
    Value<int>? age,
    Value<int>? phoneNum,
    Value<String?>? favoriteSpotID,
    Value<String?>? userImage,
    Value<String?>? placeId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? visitedRegions,
    Value<int>? totalVisitedCount,
    Value<DateTime?>? lastLocationUpdate,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      parkourProficiency: parkourProficiency ?? this.parkourProficiency,
      signupDate: signupDate ?? this.signupDate,
      lastLogin: lastLogin ?? this.lastLogin,
      status: status ?? this.status,
      age: age ?? this.age,
      phoneNum: phoneNum ?? this.phoneNum,
      favoriteSpotID: favoriteSpotID ?? this.favoriteSpotID,
      userImage: userImage ?? this.userImage,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visitedRegions: visitedRegions ?? this.visitedRegions,
      totalVisitedCount: totalVisitedCount ?? this.totalVisitedCount,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
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
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (parkourProficiency.present) {
      map['parkour_proficiency'] = Variable<String>(parkourProficiency.value);
    }
    if (signupDate.present) {
      map['signup_date'] = Variable<DateTime>(signupDate.value);
    }
    if (lastLogin.present) {
      map['last_login'] = Variable<DateTime>(lastLogin.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (phoneNum.present) {
      map['phone_num'] = Variable<int>(phoneNum.value);
    }
    if (favoriteSpotID.present) {
      map['favorite_spot_i_d'] = Variable<String>(favoriteSpotID.value);
    }
    if (userImage.present) {
      map['user_image'] = Variable<String>(userImage.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (visitedRegions.present) {
      map['visited_regions'] = Variable<String>(visitedRegions.value);
    }
    if (totalVisitedCount.present) {
      map['total_visited_count'] = Variable<int>(totalVisitedCount.value);
    }
    if (lastLocationUpdate.present) {
      map['last_location_update'] = Variable<DateTime>(
        lastLocationUpdate.value,
      );
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
          ..write('displayName: $displayName, ')
          ..write('parkourProficiency: $parkourProficiency, ')
          ..write('signupDate: $signupDate, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('status: $status, ')
          ..write('age: $age, ')
          ..write('phoneNum: $phoneNum, ')
          ..write('favoriteSpotID: $favoriteSpotID, ')
          ..write('userImage: $userImage, ')
          ..write('placeId: $placeId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('visitedRegions: $visitedRegions, ')
          ..write('totalVisitedCount: $totalVisitedCount, ')
          ..write('lastLocationUpdate: $lastLocationUpdate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String uid,
      required String email,
      required String displayName,
      required String parkourProficiency,
      required DateTime signupDate,
      required DateTime lastLogin,
      required String status,
      required int age,
      required int phoneNum,
      Value<String?> favoriteSpotID,
      Value<String?> userImage,
      Value<String?> placeId,
      required double latitude,
      required double longitude,
      Value<String?> visitedRegions,
      Value<int> totalVisitedCount,
      Value<DateTime?> lastLocationUpdate,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> uid,
      Value<String> email,
      Value<String> displayName,
      Value<String> parkourProficiency,
      Value<DateTime> signupDate,
      Value<DateTime> lastLogin,
      Value<String> status,
      Value<int> age,
      Value<int> phoneNum,
      Value<String?> favoriteSpotID,
      Value<String?> userImage,
      Value<String?> placeId,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> visitedRegions,
      Value<int> totalVisitedCount,
      Value<DateTime?> lastLocationUpdate,
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parkourProficiency => $composableBuilder(
    column: $table.parkourProficiency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signupDate => $composableBuilder(
    column: $table.signupDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLogin => $composableBuilder(
    column: $table.lastLogin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phoneNum => $composableBuilder(
    column: $table.phoneNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteSpotID => $composableBuilder(
    column: $table.favoriteSpotID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userImage => $composableBuilder(
    column: $table.userImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
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

  ColumnFilters<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parkourProficiency => $composableBuilder(
    column: $table.parkourProficiency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signupDate => $composableBuilder(
    column: $table.signupDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLogin => $composableBuilder(
    column: $table.lastLogin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phoneNum => $composableBuilder(
    column: $table.phoneNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteSpotID => $composableBuilder(
    column: $table.favoriteSpotID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userImage => $composableBuilder(
    column: $table.userImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
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

  ColumnOrderings<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
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

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parkourProficiency => $composableBuilder(
    column: $table.parkourProficiency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get signupDate => $composableBuilder(
    column: $table.signupDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLogin =>
      $composableBuilder(column: $table.lastLogin, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get phoneNum =>
      $composableBuilder(column: $table.phoneNum, builder: (column) => column);

  GeneratedColumn<String> get favoriteSpotID => $composableBuilder(
    column: $table.favoriteSpotID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userImage =>
      $composableBuilder(column: $table.userImage, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get visitedRegions => $composableBuilder(
    column: $table.visitedRegions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVisitedCount => $composableBuilder(
    column: $table.totalVisitedCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLocationUpdate => $composableBuilder(
    column: $table.lastLocationUpdate,
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
                Value<String> displayName = const Value.absent(),
                Value<String> parkourProficiency = const Value.absent(),
                Value<DateTime> signupDate = const Value.absent(),
                Value<DateTime> lastLogin = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> phoneNum = const Value.absent(),
                Value<String?> favoriteSpotID = const Value.absent(),
                Value<String?> userImage = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> visitedRegions = const Value.absent(),
                Value<int> totalVisitedCount = const Value.absent(),
                Value<DateTime?> lastLocationUpdate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                uid: uid,
                email: email,
                displayName: displayName,
                parkourProficiency: parkourProficiency,
                signupDate: signupDate,
                lastLogin: lastLogin,
                status: status,
                age: age,
                phoneNum: phoneNum,
                favoriteSpotID: favoriteSpotID,
                userImage: userImage,
                placeId: placeId,
                latitude: latitude,
                longitude: longitude,
                visitedRegions: visitedRegions,
                totalVisitedCount: totalVisitedCount,
                lastLocationUpdate: lastLocationUpdate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String email,
                required String displayName,
                required String parkourProficiency,
                required DateTime signupDate,
                required DateTime lastLogin,
                required String status,
                required int age,
                required int phoneNum,
                Value<String?> favoriteSpotID = const Value.absent(),
                Value<String?> userImage = const Value.absent(),
                Value<String?> placeId = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<String?> visitedRegions = const Value.absent(),
                Value<int> totalVisitedCount = const Value.absent(),
                Value<DateTime?> lastLocationUpdate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                uid: uid,
                email: email,
                displayName: displayName,
                parkourProficiency: parkourProficiency,
                signupDate: signupDate,
                lastLogin: lastLogin,
                status: status,
                age: age,
                phoneNum: phoneNum,
                favoriteSpotID: favoriteSpotID,
                userImage: userImage,
                placeId: placeId,
                latitude: latitude,
                longitude: longitude,
                visitedRegions: visitedRegions,
                totalVisitedCount: totalVisitedCount,
                lastLocationUpdate: lastLocationUpdate,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
