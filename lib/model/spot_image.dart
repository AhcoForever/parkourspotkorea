class SpotImageModel {
  final String? imageUrl;
  final String? keyword;
  final SpotImageStatus status;
  final String? errorMessage;

  const SpotImageModel._({
    this.imageUrl,
    this.keyword,
    required this.status,
    this.errorMessage,
  });

  factory SpotImageModel.loading() =>
      const SpotImageModel._(status: SpotImageStatus.loading);

  factory SpotImageModel.success(String url, String keyword) =>
      SpotImageModel._(
        imageUrl: url,
        keyword: keyword,
        status: SpotImageStatus.success,
      );

  factory SpotImageModel.error(String error) =>
      SpotImageModel._(status: SpotImageStatus.error, errorMessage: error);

  factory SpotImageModel.notFound() =>
      const SpotImageModel._(status: SpotImageStatus.notFound);

  factory SpotImageModel.notConfigured() =>
      const SpotImageModel._(status: SpotImageStatus.notConfigured);

  // Getters
  bool get isLoading => status == SpotImageStatus.loading;

  bool get hasImage => status == SpotImageStatus.success && imageUrl != null;

  bool get hasError => status == SpotImageStatus.error;

  bool get isNotFound => status == SpotImageStatus.notFound;

  bool get isNotConfigured => status == SpotImageStatus.notConfigured;

  @override
  String toString() => 'SpotImageModel(status: $status, url: $imageUrl)';
}

enum SpotImageStatus { loading, success, error, notFound, notConfigured }
