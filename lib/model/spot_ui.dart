import 'package:parkourspotkorea/model/parkour_spot.dart';
import 'package:parkourspotkorea/model/spot_image.dart';

class SpotUiModel {
  final ParkourSpot spot;
  final SpotImageModel imageModel;

  SpotUiModel({
    required this.spot,
    required this.imageModel,
  });

  SpotUiModel copyWith({
    ParkourSpot? spot,
    SpotImageModel? imageModel,
  }) {
    return SpotUiModel(
      spot: spot ?? this.spot,
      imageModel: imageModel ?? this.imageModel,
    );
  }

  // UI Helper Methods
  String get displayName =>
      spot.displayName.isNotEmpty ? spot.displayName : spot.name;

  bool get hasAddress => spot.address.isNotEmpty;
  bool get hasTags => spot.tags.isNotEmpty;
  bool get hasDescription => spot.description.isNotEmpty;
  bool get hasFirestoreImages => spot.imageUrls.isNotEmpty;

  String get formattedCoordinates =>
      '${spot.location.latitude.toStringAsFixed(6)}, ${spot.location.longitude.toStringAsFixed(6)}';
}