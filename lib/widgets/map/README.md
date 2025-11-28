# GenericMapWidget - 범용 지도 위젯

GoogleMap + 마커 + 내 위치 기능을 포함한 재사용 가능한 Flutter 지도 위젯입니다.

## 특징

- ✅ **범용성**: 특정 도메인 의존성 없이 어떤 프로젝트에서도 사용 가능
- ✅ **커스터마이징**: InfoWindow, BottomSheet, 마커 아이콘 등을 자유롭게 커스터마이징
- ✅ **내 위치**: GPS 권한 요청 및 현재 위치 자동 탐지
- ✅ **지도 스타일**: 커스텀 지도 스타일 JSON 지원
- ✅ **이벤트 콜백**: 마커 클릭, 지도 이동 등 다양한 이벤트 처리

---

## 다른 프로젝트로 이동하기

### 1단계: 패키지 설치

`pubspec.yaml`에 다음 패키지를 추가하세요:

```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  custom_info_window: ^1.0.1
```

### 2단계: 파일 복사

다음 3개 파일을 새 프로젝트로 복사하세요:

```
lib/
├── model/
│   └── map_marker_data.dart          # 범용 마커 데이터 모델
└── widgets/
    └── map/
        ├── map_location_service.dart  # 위치 권한 + GPS 서비스
        └── generic_map_widget.dart    # 범용 지도 위젯
```

### 3단계: Android 설정

`android/app/src/main/AndroidManifest.xml`에 다음을 추가:

```xml
<manifest ...>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <application ...>
        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```

### 4단계: iOS 설정

`ios/Runner/Info.plist`에 다음을 추가:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>이 앱은 지도에서 현재 위치를 표시하기 위해 위치 권한이 필요합니다.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>이 앱은 지도에서 현재 위치를 표시하기 위해 위치 권한이 필요합니다.</string>
```

`ios/Runner/AppDelegate.swift`에 Google Maps API Key 추가:

```swift
import UIKit
import Flutter
import GoogleMaps  // 추가

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")  // 추가
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## 사용 방법

### 기본 사용

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:your_project/model/map_marker_data.dart';
import 'package:your_project/widgets/map/generic_map_widget.dart';

class MyMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final markers = [
      MapMarkerData(
        id: '1',
        title: '서울시청',
        subtitle: '대한민국 서울특별시',
        position: LatLng(37.5665, 126.9780),
      ),
      MapMarkerData(
        id: '2',
        title: '남산타워',
        position: LatLng(37.5512, 126.9882),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('지도')),
      body: GenericMapWidget(
        markers: markers,
        onMarkerTap: (data) => print('마커 클릭: ${data.title}'),
      ),
    );
  }
}
```

### InfoWindow 커스터마이징

```dart
GenericMapWidget(
  markers: markers,
  infoWindowBuilder: (data) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        data.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  },
)
```

### BottomSheet 커스터마이징

```dart
GenericMapWidget(
  markers: markers,
  bottomSheetBuilder: (context, data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (data.subtitle != null) Text(data.subtitle!),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  },
)
```

### 지도 스타일 적용

1. `assets/map_style/map_style.json` 파일 준비
2. `pubspec.yaml`에 assets 추가:
   ```yaml
   flutter:
     assets:
       - assets/map_style/
   ```
3. 위젯에서 사용:
   ```dart
   GenericMapWidget(
     markers: markers,
     mapStyleJsonPath: 'assets/map_style/map_style.json',
   )
   ```

### 커스텀 마커 아이콘

```dart
class MyMapPage extends StatefulWidget {
  @override
  State<MyMapPage> createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
  }

  Future<void> _loadCustomIcon() async {
    final icon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/marker.png',
    );
    setState(() => _customIcon = icon);
  }

  @override
  Widget build(BuildContext context) {
    return GenericMapWidget(
      markers: markers,
      customMarkerIcon: _customIcon,
    );
  }
}
```

### extraData 활용

```dart
final markers = [
  MapMarkerData(
    id: '1',
    title: '카페 A',
    subtitle: '맛있는 커피',
    position: LatLng(37.5665, 126.9780),
    extraData: {
      'rating': 4.5,
      'imageUrl': 'https://example.com/cafe.jpg',
      'category': 'cafe',
      'phone': '02-1234-5678',
    },
  ),
];

// BottomSheet에서 사용
bottomSheetBuilder: (context, data) {
  final rating = data.extraData?['rating'];
  final category = data.extraData?['category'];

  return Container(
    child: Column(
      children: [
        Text(data.title),
        if (rating != null) Text('평점: $rating'),
        if (category != null) Text('카테고리: $category'),
      ],
    ),
  );
}
```

---

## API 레퍼런스

### GenericMapWidget 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|---------|------|------|-------|------|
| `initialPosition` | `LatLng?` | ❌ | `null` | 초기 카메라 위치 (null이면 현재 위치 사용) |
| `initialZoom` | `double` | ❌ | `15.0` | 초기 줌 레벨 |
| `markers` | `List<MapMarkerData>` | ✅ | - | 표시할 마커 데이터 리스트 |
| `mapStyleJsonPath` | `String?` | ❌ | `null` | 지도 스타일 JSON 파일 경로 |
| `customMarkerIcon` | `BitmapDescriptor?` | ❌ | `null` | 커스텀 마커 아이콘 |
| `infoWindowBuilder` | `Widget Function(MapMarkerData)?` | ❌ | `null` | InfoWindow 내용 빌더 |
| `bottomSheetBuilder` | `Widget Function(BuildContext, MapMarkerData)?` | ❌ | `null` | BottomSheet 내용 빌더 |
| `onMarkerTap` | `void Function(MapMarkerData)?` | ❌ | `null` | 마커 클릭 콜백 |
| `onCameraMove` | `void Function(LatLng)?` | ❌ | `null` | 카메라 이동 콜백 |
| `onMapTap` | `void Function(LatLng)?` | ❌ | `null` | 지도 탭 콜백 |
| `showMyLocationButton` | `bool` | ❌ | `true` | 내 위치 버튼 표시 여부 |
| `showMyLocation` | `bool` | ❌ | `true` | 내 위치 표시 여부 |
| `infoWindowHeight` | `double` | ❌ | `100.0` | InfoWindow 높이 |
| `infoWindowWidth` | `double` | ❌ | `200.0` | InfoWindow 너비 |
| `infoWindowOffset` | `double` | ❌ | `50.0` | InfoWindow 오프셋 |

### MapMarkerData 필드

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `id` | `String` | ✅ | 마커 고유 ID |
| `title` | `String` | ✅ | 마커 제목 |
| `subtitle` | `String?` | ❌ | 마커 부제목 |
| `position` | `LatLng` | ✅ | 마커 위치 좌표 |
| `extraData` | `Map<String, dynamic>?` | ❌ | 추가 데이터 |

### MapLocationService 메서드

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getCurrentLocation()` | `Future<LatLng?>` | 현재 위치 가져오기 |
| `getCurrentLocationWithTimeout()` | `Future<LatLng?>` | 타임아웃 설정된 현재 위치 가져오기 |
| `calculateDistance()` | `double` | 두 위치 사이의 거리 (미터) |
| `calculateDistanceInKm()` | `double` | 두 위치 사이의 거리 (킬로미터) |
| `getLocationStream()` | `Stream<LatLng>` | 실시간 위치 추적 스트림 |
| `isLocationServiceEnabled()` | `Future<bool>` | 위치 서비스 활성화 여부 |
| `checkPermission()` | `Future<LocationPermission>` | 현재 권한 상태 확인 |
| `openAppSettings()` | `Future<bool>` | 앱 설정 열기 |

---

## 예시 파일

더 자세한 사용 예시는 `example_map_usage.dart` 파일을 참고하세요:

- `BasicMapExample`: 기본 사용법
- `CustomizedMapExample`: InfoWindow + BottomSheet 커스터마이징
- `StyledMapExample`: 지도 스타일 + 커스텀 마커
- `DynamicMapExample`: 실시간 데이터 업데이트

---

## 문제 해결

### 위치 권한이 작동하지 않아요

1. AndroidManifest.xml / Info.plist에 권한이 추가되었는지 확인
2. 실제 기기에서 테스트 (에뮬레이터는 GPS 시뮬레이션 필요)
3. 기기 설정에서 위치 서비스가 활성화되었는지 확인

### 마커가 표시되지 않아요

1. `markers` 리스트가 비어있지 않은지 확인
2. 좌표 값이 올바른지 확인 (위도: -90~90, 경도: -180~180)
3. 줌 레벨이 너무 낮거나 높지 않은지 확인

### 지도 스타일이 적용되지 않아요

1. JSON 파일 경로가 올바른지 확인
2. pubspec.yaml에 assets가 등록되었는지 확인
3. JSON 파일 형식이 올바른지 확인 ([Google Maps Styling Wizard](https://mapstyle.withgoogle.com/) 사용 권장)

---

## 라이선스

이 코드는 자유롭게 사용, 수정, 배포할 수 있습니다.
