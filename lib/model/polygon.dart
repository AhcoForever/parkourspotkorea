class Polygon {
   double latitude;
   double longitude;
   Map<String, dynamic> coordinate;
   String admNm;
   int admCd2;
   int sido;
   String sidonm;
   int sgg;
   String sggnm;

  Polygon({
    required this.latitude,
    required this.longitude,
    required this.coordinate,
    required this.admNm,
    required this.admCd2,
    required this.sido,
    required this.sidonm,
    required this.sgg,
    required this.sggnm,
  });

  /// Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'coordinate': coordinate,
      'admNm': admNm,
      'admCd2': admCd2,
      'sido': sido,
      'sidonm': sidonm,
      'sgg': sgg,
      'sggnm': sggnm,
    };
  }

  /// Map에서 객체로 변환
  factory Polygon.fromMap(Map<String, dynamic> map) {
    return Polygon(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      coordinate: Map<String, dynamic>.from(map['coordinate']),
      admNm: map['admNm'] ?? '',
      admCd2: map['admCd2'] ?? 0,
      sido: map['sido'] ?? 0,
      sidonm: map['sidonm'] ?? '',
      sgg: map['sgg'] ?? 0,
      sggnm: map['sggnm'] ?? '',
    );
  }
}
