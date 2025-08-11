import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Geofeature {
  final String? id; //문서 ID
  final String coordinate; // geometry.coordinates 를 JSON 문자열로 보관
  final String adm_nm;
  final int adm_cd;
  final int sido;
  final String sidonm;
  final int sgg;
  final String sggnm;
  final int adm_cd2;

  Geofeature({
    this.id,
    required this.coordinate,
    required this.adm_nm,
    required this.adm_cd,
    required this.sido,
    required this.sidonm,
    required this.sgg,
    required this.sggnm,
    required this.adm_cd2,
  });

  //GeoJSON -> Geofeaure
  /// properties 와 geometry.coordinates 를 꺼내서 객체화.
  /// geometry.coordinates는 firestore에 문자열로 저장할 목적으로 jsonEncode
  factory Geofeature.fromGeoJson(Map<String, dynamic> json) {
    final props = json['properties'] as Map<String, dynamic>;
    final geometry = json['geometry'] as Map<String, dynamic>;

    return Geofeature(
      coordinate: jsonEncode(geometry['coordinates']),
      adm_nm: props['adm_nm'] as String? ?? '',
      adm_cd: int.tryParse(props['adm_cd'] as String? ?? '') ?? 0,
      sido: int.tryParse(props['sido'] as String? ?? '') ?? 0,
      sidonm: props['sidonm'] as String? ?? '',
      sgg: int.tryParse(props['sgg'] as String? ?? '') ?? 0,
      sggnm: props['sggnm'] as String? ?? '',
      adm_cd2:int.parse(props['adm_cd2'] as String? ?? '') ?? 0,
    );
  }

  //firestore -> geofeature (읽어올 때)
  ///firestore에서 꺼낸 Map과 문서ID를 받아 다시 Geofeature 객체로 복원할 때 사용.
  factory Geofeature.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Geofeature(
      id: docId,
      coordinate: map['coordinates'] as String? ?? '',
      adm_nm: map['adm_nm'] as String? ?? '',
      adm_cd: map['adm_cd'] as int? ?? 0,
      sido: map['sido'] as int? ?? 0,
      sidonm: map['sidonm'] as String? ?? '',
      sgg: map['sgg'] as int? ?? 0,
      sggnm: map['sggnm'] as String? ?? '',
      adm_cd2: map['adm_cd2'] as int? ?? 0,
    );
  }

  //geofeature -> firestore (저장할 때)
  ///Firestore에 저장할 떄, 키값 형태로 변환.
  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinate,
      'adm_nm': adm_nm,
      'adm_cd': adm_cd,
      'sido': sido,
      'sidonm': sidonm,
      'sgg': sgg,
      'sggnm': sggnm,
      'migration_date': FieldValue.serverTimestamp(),
      'adm_cd2' : adm_cd2,
    };
  }
}
