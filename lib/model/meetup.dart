import 'package:flutter/cupertino.dart';

enum meetupStatus { upcoming, canceled, finished }

class MeetUp {
  //변수
  final String meetupId;
  String title;
  final String hostUserId;
  String hostDisplayname;
  final String prtcId;
  String prtcDisplayname;
  final String placeId;
  DateTime startTime;
  DateTime endTime;
  int? capacity;
  meetupStatus meetupstatus;
  DateTime updatedAt;
  final String address;
  List<String> images;

  MeetUp({
    required this.meetupId,
    required this.title,
    required this.hostUserId,
    required this.hostDisplayname,
    required this.prtcId,
    required this.prtcDisplayname,
    required this.placeId,
    required this.startTime,
    required this.endTime,
    this.capacity,
    required this.meetupstatus,
    required this.updatedAt,
    required this.address,
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'meetupId': meetupId,
      'title': title,
      'hostUserId': hostUserId,
      'hostDisplayname': hostDisplayname,
      'prtcId': prtcId,
      'prtcDisplayname': prtcDisplayname,
      'placeId': placeId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'capacity': capacity,
      'status': meetupstatus.name,
      'updatedAt': updatedAt.toIso8601String(),
      'address': address,
      'images': images ?? [],
    };
  }

  static MeetUp fromMap(Map<String, dynamic> map) {
    return MeetUp(
      meetupId: map['meetupId'],
      title: map['title'] ?? '',
      hostUserId: map['hostUserId'] ?? '',
      hostDisplayname: map['hostDisplayname'] ?? '',
      prtcId: map['prtcId'] ?? '',
      prtcDisplayname: map['prtcDisplayname'] ?? '',
      placeId: map['placeId'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      capacity: map['capacity'] ?? '',
      meetupstatus: map['status'] ?? '',
      updatedAt: DateTime.parse(map['updatedAt']),
      address: map['address'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  static meetupStatus _statusFromString(String status) {
    switch (status) {
      case 'upcoming':
        return meetupStatus.upcoming;
      case 'canceled':
        return meetupStatus.canceled;
      case 'finished':
        return meetupStatus.finished;
      default:
        return meetupStatus.upcoming;
    }
  }
}


