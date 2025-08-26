import 'package:flutter/foundation.dart';

import '../model/parkour_spot.dart';
import '../model/spot_image.dart';
import '../model/spot_ui.dart';
import '../repositories/spot_action_repository.dart';
import '../repositories/spot_image_repository.dart';

class SpotBottomSheetViewModel extends ChangeNotifier {
  final SpotImageRepository _imageRepository;
  final SpotActionRepository _actionRepository;

  SpotUiModel _spotUiModel;
  bool _isLoading = false;
  String? _errorMessage;

  SpotBottomSheetViewModel({
    required ParkourSpot spot,
    SpotImageRepository? imageRepository,
    SpotActionRepository? actionRepository,
  }) : _imageRepository = imageRepository ?? GooglePlacesSpotImageRepository(),
        _actionRepository = actionRepository ?? DefaultSpotActionRepository(),
        _spotUiModel = SpotUiModel(
          spot: spot,
          imageModel: SpotImageModel.loading(),
        );

  // Getters
  SpotUiModel get spotUiModel => _spotUiModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ParkourSpot get spot => _spotUiModel.spot;
  SpotImageModel get imageModel => _spotUiModel.imageModel;

  // 초기화
  Future<void> initialize() async {
    await loadImage();
  }

  // 이미지 로딩
  Future<void> loadImage() async {
    _setImageModel(SpotImageModel.loading());

    try {
      final imageModel = await _imageRepository.loadSpotImage(
        spot: _spotUiModel.spot,
      );

      _setImageModel(imageModel);

      if (imageModel.hasImage) {
        debugPrint('✅ 이미지 로드 성공: ${imageModel.keyword}');
      }
    } catch (e) {
      debugPrint('❌ 이미지 로드 실패: $e');
      _setImageModel(SpotImageModel.error(e.toString()));
    }
  }

  // 액션 메서드들
  Future<void> openDirections() async {
    _setLoading(true);
    _clearError();

    final success = await _actionRepository.openDirections(
      spot.location.latitude,
      spot.location.longitude,
    );

    if (!success) {
      _setError('길찾기를 실행할 수 없습니다.');
    }

    _setLoading(false);
  }

  Future<void> toggleBookmark() async {
    _setLoading(true);
    _clearError();

    final success = await _actionRepository.toggleBookmark(spot.documentId);

    if (!success) {
      _setError('즐겨찾기 처리에 실패했습니다.');
    }

    _setLoading(false);
  }

  Future<void> shareSpot() async {
    _setLoading(true);
    _clearError();

    final success = await _actionRepository.shareSpot(spot);

    if (!success) {
      _setError('공유에 실패했습니다.');
    }

    _setLoading(false);
  }

  // 이미지 새로고침
  Future<void> refreshImage() async {
    await loadImage();
  }

  // Private methods
  void _setImageModel(SpotImageModel imageModel) {
    _spotUiModel = _spotUiModel.copyWith(imageModel: imageModel);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
