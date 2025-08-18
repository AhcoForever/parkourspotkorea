import 'package:google_maps_flutter/google_maps_flutter.dart';

/// ScratchMap 화면의 상태 모델
class ScratchMapState {
  final bool isLoading;
  final bool isHexagonVisible;
  final bool visitedLoaded;
  final Set<Polygon> polygons;
  final Set<Polygon> hexagons;
  final LatLng? cameraPosition;
  final LatLng? hexGridOrigin;
  final String? errorMessage;

  const ScratchMapState({
    required this.isLoading,
    required this.isHexagonVisible,
    required this.visitedLoaded,
    required this.polygons,
    required this.hexagons,
    this.cameraPosition,
    this.hexGridOrigin,
    this.errorMessage,
  });

  /// 초기 상태
  factory ScratchMapState.initial() {
    return const ScratchMapState(
      isLoading: true,
      isHexagonVisible: false,
      visitedLoaded: false,
      polygons: {},
      hexagons: {},
    );
  }

  /// 로딩 상태
  ScratchMapState copyWithLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  /// 에러 상태
  ScratchMapState copyWithError(String error) {
    return copyWith(errorMessage: error, isLoading: false);
  }

  /// 상태 복사
  ScratchMapState copyWith({
    bool? isLoading,
    bool? isHexagonVisible,
    bool? visitedLoaded,
    Set<Polygon>? polygons,
    Set<Polygon>? hexagonPolygons,
    LatLng? cameraPosition,
    LatLng? hexGridOrigin,
    String? errorMessage,
  }) {
    return ScratchMapState(
      isLoading: isLoading ?? this.isLoading,
      isHexagonVisible: isHexagonVisible ?? this.isHexagonVisible,
      visitedLoaded: visitedLoaded ?? this.visitedLoaded,
      polygons: polygons ?? this.polygons,
      hexagons: hexagonPolygons ?? this.hexagons,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      hexGridOrigin: hexGridOrigin ?? this.hexGridOrigin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// 모든 폴리곤 반환 (헥사곤 표시 여부에 따라)
  Set<Polygon> get allPolygons {
    return isHexagonVisible
        ? polygons.union(hexagons)
        : polygons;
  }

  @override
  String toString() {
    return 'ScratchMapState(isLoading: $isLoading, '
        'isHexagonVisible: $isHexagonVisible, '
        'polygons: ${polygons.length}, '
        'hexagonPolygons: ${hexagons.length})';
  }
}