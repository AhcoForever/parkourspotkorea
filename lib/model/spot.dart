enum SpotDifficulty { easy, medium, hard }

class Spot {
  final String placeId;
  final String spotName;
  final String spotAddress;
  final String spotDescription;
  final double latitude;
  final double longitude;
  final List<String> spotImages;
  final SpotDifficulty difficulty;

  Spot({
    required this.placeId,
    required this.spotName,
    required this.spotAddress,
    required this.spotDescription,
    required this.latitude,
    required this.longitude,
    required this.spotImages,
    required this.difficulty,
  });

  /// Firestore 저장용
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'spotName': spotName,
      'spotAddress': spotAddress,
      'spotDescription': spotDescription,
      'latitude': latitude,
      'longitude': longitude,
      'spotImages': spotImages,
      'difficulty': difficulty.name, // enum → 문자열 저장
    };
  }

  /// Firestore에서 가져온 데이터로 Spot 객체 생성
  factory Spot.fromMap(Map<String, dynamic> map) {
    return Spot(
      placeId: map['placeId'] ?? '',
      spotName: map['spotName'] ?? '',
      spotAddress: map['spotAddress'] ?? '',
      spotDescription: map['spotDescription'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      spotImages: List<String>.from(map['spotImages'] ?? []),
      difficulty: _difficultyFromString(map['difficulty']),
    );
  }

  static SpotDifficulty _difficultyFromString(String? value) {
    switch (value) {
      case 'easy':
        return SpotDifficulty.easy;
      case 'medium':
        return SpotDifficulty.medium;
      case 'hard':
        return SpotDifficulty.hard;
      default:
        return SpotDifficulty.medium; // 기본값
    }
  }
}
