# 詳情頁邏輯審核材料：RouteModel、ViewModel 與 DetailedTrackView 核心代碼

> 本文檔整理當前「路線詳情頁」的數據模型、視圖狀態與核心邏輯，便於進行邏輯深度審核與優化。  
> 對應實體：**數據** = `DetailedTrackModel.swift`（RouteModel）；**視圖** = `ManualJourneyDetailView.swift`（對外常稱 DetailedTrackView）；**無獨立 ViewModel**，狀態與派生邏輯均在 View 內。

---

## 一、數據模型（RouteModel / DetailedTrackModel）

**文件**：`HikBik/Models/DetailedTrackModel.swift`

### 1.1 枚舉

```swift
/// 六大地類（路線分類）
enum DetailedTrackCategory: String, CaseIterable, Identifiable, Codable {
    case nationalForest = "National Forest"
    case nationalPark = "National Park"
    case nationalGrassland = "National Grassland"
    case nationalRecreationArea = "National Recreation Area"
    case statePark = "State Park"
    case stateForest = "State Forest"
    public var id: String { rawValue }
}

/// 站點活動類型
enum ViewPointActivityType: String, CaseIterable, Identifiable, Codable {
    case hiking, mtb, overlanding, camping, climbing, paddling, summit, fishing, boating
    public var id: String { rawValue }
}
```

### 1.2 作者（社交）

```swift
struct DetailedTrackAuthor: Codable, Equatable {
    var name: String
    var avatarUrl: String?
    var isVerified: Bool
    init(name: String = "", avatarUrl: String? = nil, isVerified: Bool = false) { ... }
}
```

### 1.3 站點節點 ViewPointNode

```swift
struct ViewPointNode: Identifiable, Codable {
    var id: UUID
    var title: String
    var activityType: ViewPointActivityType
    var latitude: Double?
    var longitude: Double?
    var photoCount: Int
    var arrivalTime: String?
    var elevation: String?
    var hasWater: Bool
    var hasFuel: Bool
    var signalStrength: Int  // 0–5
    var recommendedStay: String?

    var hasValidLocation: Bool { latitude != nil && longitude != nil }
    var hasAtLeastOnePhoto: Bool { photoCount >= 1 }
    var isComplete: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && hasValidLocation && hasAtLeastOnePhoto
    }
}
```

### 1.4 路線主體 DetailedTrackPost（RouteModel）

```swift
struct DetailedTrackPost: Codable {
    var category: DetailedTrackCategory?
    var routeName: String
    var totalDurationMinutes: Int
    var viewPointNodes: [ViewPointNode]
    var elevationGain: String?
    var elevationPeak: String?
    var amenitiesDisplay: [String]?
    var author: DetailedTrackAuthor?
    var rating: Float?
    var reviewCount: Int?
    var heroImage: String?

    var isReadyToPublish: Bool {
        guard !routeName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard category != nil else { return false }
        guard totalDurationMinutes > 0 else { return false }
        guard viewPointNodes.count >= 2 else { return false }
        return viewPointNodes.allSatisfy(\.isComplete)
    }

    /// 依 itinerary 首尾 arrivalTime 解析為 "2h 30min" 等；無效時 nil，詳情頁 fallback 至 totalDurationMinutes
    var calculatedRealDuration: String? {
        guard viewPointNodes.count >= 2,
              let first = viewPointNodes.first?.arrivalTime, !first.trimmingCharacters(in: .whitespaces).isEmpty,
              let last = viewPointNodes.last?.arrivalTime, !last.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let ref = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        formatter.defaultDate = ref
        guard let d1 = formatter.date(from: first),
              let d2 = formatter.date(from: last) else { return nil }
        var interval = d2.timeIntervalSince(d1)
        if interval < 0 { interval += 24 * 3600 }
        let totalMinutes = Int(interval / 60)
        if totalMinutes < 60 { return "\(totalMinutes)min" }
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        return m > 0 ? "\(h)h \(m)min" : "\(h)h"
    }
}
```

**型別別名**：`typealias ManualJourney = DetailedTrackPost`（詳情頁入參即此型別）。

---

## 二、視圖狀態與派生（充當 ViewModel 的部分）

**文件**：`ManualJourneyDetailView.swift`  
**說明**：無單獨 ViewModel 類，以下為 View 內狀態與關鍵計算屬性，供審核「業務邏輯」與「數據流」用。

### 2.1 輸入與環境

```swift
let journey: ManualJourney   // 即 DetailedTrackPost，只讀入參
@Environment(\.dismiss) private var dismiss
```

### 2.2 狀態（@State）

| 變量 | 類型 | 用途 |
|------|------|------|
| `routeSegments` | `[[CLLocationCoordinate2D]]` | MKDirections 返回的段座標，用於地圖 Polyline |
| `isLoadingRoutes` | `Bool` | 路徑請求中，顯示 loading |
| `mapPosition` | `MapCameraPosition` | 地圖相機（3D 鏡頭 / region） |
| `showSheet` | `Bool` | 是否顯示底部 Sheet，onAppear 設 true |
| `isFavorite` | `Bool` | 收藏按鈕選中態 |
| `sheetDetent` | `PresentationDetent` | Sheet 檔位：.height(160) / .medium / .large |
| `selectedViewPointIndex` | `Int?` | 當前選中的站點索引，點 Itinerary 行時設置，驅動飛圖 + 天氣更新 |
| `weatherSnapshot` | `WeatherSnapshot?` | 當前展示的天氣，由 WeatherManager 回調寫入 |

### 2.3 派生屬性（由 journey / 狀態計算）

```swift
private var theme: LandManagementTheme { LandManagementTheme.from(journey.category) }
private var accentColor: Color { theme.accentColor }
private var isSheetFullyExpanded: Bool { sheetDetent == .large }

private var hasAnyWater: Bool { journey.viewPointNodes.contains(where: \.hasWater) }
private var hasAnyFuel: Bool { journey.viewPointNodes.contains(where: \.hasFuel) }
private var hasAnySignal: Bool { journey.viewPointNodes.contains(where: { $0.signalStrength > 0 }) }

/// 從 viewPointNodes 抽出 [CLLocationCoordinate2D]，用於地圖與路徑計算
private var routeCoordinates: [CLLocationCoordinate2D] {
    journey.viewPointNodes.compactMap { node in
        guard let lat = node.latitude, let lon = node.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

/// 若任一站為 overlanding 則用 .automobile，否則 .walking
private var directionsTransportType: MKDirectionsTransportType {
    let hasOverlanding = journey.viewPointNodes.contains { $0.activityType == .overlanding }
    return hasOverlanding ? .automobile : .walking
}
```

### 2.4 時長展示邏輯（Sheet 用）

```swift
/// 優先 calculatedRealDuration，否則用 totalDurationMinutes 格式化
private var durationDisplay: String {
    if let real = journey.calculatedRealDuration { return real }
    let m = journey.totalDurationMinutes
    if m < 60 { return "\(m)min" }
    let h = m / 60
    let r = m % 60
    return r > 0 ? "\(h)hr \(r)min" : "\(h)hr"
}
```

### 2.5 Amenities 解析（Sheet 用）

```swift
private var resolvedAmenityItems: [AmenityItem] {
    if let display = journey.amenitiesDisplay, !display.isEmpty {
        return display.compactMap { label -> AmenityItem? in
            // 根據 label 關鍵字映射 icon/label/color（water, signal, first aid, fuel, fire, toilet）
            ...
        }
    }
    var list: [AmenityItem] = []
    if hasAnyWater { list.append(...) }
    if hasAnyFuel { list.append(...) }
    if hasAnySignal { list.append(...) }
    return list
}
```

---

## 三、DetailedTrackView（ManualJourneyDetailView）核心邏輯

### 3.1 視圖結構概覽

- **最外層**：`ZStack(alignment: .top)`  
  - Layer 0：全屏地圖 `fullScreenMapLayer`（根據 `sheetDetent == .large` 輕微 blur）  
  - Layer 1：頂部懸浮按鈕 `floatingControlsLayer`  
- **修飾**：`.navigationBarBackButtonHidden(true)`、`.navigationBarHidden(true)`  
- **Sheet**：`.sheet(isPresented: $showSheet)`，內容為 `interactiveSheetContent`，`presentationDetents([.height(160), .medium, .large], selection: $sheetDetent)`  

### 3.2 生命週期與聯動

```swift
.onAppear {
    if !routeCoordinates.isEmpty {
        let region = regionForCoordinates(routeCoordinates)
        let heading = headingFromPath(routeCoordinates)
        let camera = cameraForRegion(region, heading: heading)
        withAnimation(.easeInOut(duration: 0.6)) { mapPosition = .camera(camera) }
        calculateRouteLines()
    }
    refreshWeather(forViewPointIndex: nil)  // 用 itinerary.first 座標
    showSheet = true
}
.onChange(of: sheetDetent) { _, _ in
    updateMapPositionForSheet()
}
.onChange(of: selectedViewPointIndex) { _, newIndex in
    if let idx = newIndex {
        flyToViewPoint(at: idx)
        refreshWeather(forViewPointIndex: idx)
    }
}
```

### 3.3 地圖與相機核心邏輯

```swift
/// 包含所有點 + 約 1.4 倍 padding，最小 span 約 1000m
private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard !coords.isEmpty else {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39, longitude: -98), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
    }
    let lats = coords.map(\.latitude), lons = coords.map(\.longitude)
    let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
    let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
    let rawLatDelta = max(maxLat - minLat, 0.0001)
    let rawLonDelta = max(maxLon - minLon, 0.0001)
    let padding = 1.4
    let minLatMeters: Double = 1000
    let metersPerDegreeLat: Double = 111_320
    let minLatDelta = max(minLatMeters / metersPerDegreeLat, 0.01)
    let cosLat = max(0.01, cos(center.latitude * .pi / 180))
    let minLonDelta = minLatDelta / cosLat
    let span = MKCoordinateSpan(
        latitudeDelta: max(rawLatDelta * padding, minLatDelta),
        longitudeDelta: max(rawLonDelta * padding, minLonDelta)
    )
    return MKCoordinateRegion(center: center, span: span)
}

/// 路徑首尾的球面朝向角（度），用於 3D 鏡頭 heading
private func headingFromPath(_ coords: [CLLocationCoordinate2D]) -> Double {
    guard coords.count >= 2, let first = coords.first, let last = coords.last else { return 0 }
    let φ1 = first.latitude * .pi / 180
    let φ2 = last.latitude * .pi / 180
    let Δλ = (last.longitude - first.longitude) * .pi / 180
    let y = sin(Δλ) * cos(φ2)
    let x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ)
    var deg = atan2(y, x) * 180 / .pi
    if deg < 0 { deg += 360 }
    return deg
}

/// 3D MapCamera：pitch 45°，distance 由 span 換算（約 spanMeters * 2.2，最小 800m）
private func cameraForRegion(_ region: MKCoordinateRegion, heading: Double) -> MapCamera {
    let metersPerDegree: Double = 111_320
    let cosLat = max(0.01, cos(region.center.latitude * .pi / 180))
    let latMeters = region.span.latitudeDelta * metersPerDegree
    let lonMeters = region.span.longitudeDelta * metersPerDegree * cosLat
    let spanMeters = max(latMeters, lonMeters)
    let distance = max(spanMeters * 2.2, 800)
    return MapCamera(centerCoordinate: region.center, distance: distance, heading: heading, pitch: 45)
}

/// Sheet 檔位變化時：medium 時中心南移約 28% latitudeDelta，再設 3D camera
private func updateMapPositionForSheet() {
    let coords = routeSegments.isEmpty ? routeCoordinates : routeSegments.flatMap { $0 }
    guard !coords.isEmpty else { return }
    var region = regionForCoordinates(coords)
    if sheetDetent == .medium {
        let offset = region.span.latitudeDelta * 0.28
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: region.center.latitude - offset, longitude: region.center.longitude),
            span: region.span
        )
    }
    let heading = headingFromPath(coords)
    let camera = cameraForRegion(region, heading: heading)
    withAnimation(.easeInOut(duration: 0.35)) { mapPosition = .camera(camera) }
}

/// 點擊 Itinerary 某站：地圖飛到該點，distance 650m，pitch 45，heading 沿用整條路徑
private func flyToViewPoint(at index: Int) {
    let coords = routeSegments.isEmpty ? routeCoordinates : routeSegments.flatMap { $0 }
    guard index >= 0, index < journey.viewPointNodes.count else { return }
    guard let lat = journey.viewPointNodes[index].latitude, let lon = journey.viewPointNodes[index].longitude else { return }
    let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    let distance: Double = 650
    let heading = coords.count >= 2 ? headingFromPath(coords) : 0
    let camera = MapCamera(centerCoordinate: center, distance: distance, heading: heading, pitch: 45)
    withAnimation(.easeInOut(duration: 0.55)) { mapPosition = .camera(camera) }
}
```

### 3.4 路徑計算（MKDirections）

```swift
private func calculateRouteLines() {
    let coords = routeCoordinates
    guard coords.count >= 2, routeSegments.isEmpty else { return }
    isLoadingRoutes = true
    let count = coords.count - 1
    var segments: [[CLLocationCoordinate2D]?] = Array(repeating: nil, count: count)
    let lock = NSLock()
    let group = DispatchGroup()
    let transport = directionsTransportType  // .automobile 或 .walking
    for i in 0..<count {
        group.enter()
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coords[i]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coords[i + 1]))
        request.transportType = transport
        request.requestsAlternateRoutes = false
        MKDirections(request: request).calculate { response, _ in
            defer { group.leave() }
            guard let route = response?.routes.first else { return }
            let polyline = route.polyline
            let pointCount = polyline.pointCount
            guard pointCount > 0 else { return }
            let pts = polyline.points()
            var segmentCoords: [CLLocationCoordinate2D] = []
            for j in 0..<pointCount { segmentCoords.append(pts[j].coordinate) }
            lock.lock()
            segments[i] = segmentCoords
            lock.unlock()
        }
    }
    group.notify(queue: .main) {
        routeSegments = segments.compactMap { $0 }
        isLoadingRoutes = false
        if !routeSegments.isEmpty { updateMapPositionForSheet() }
    }
}
```

### 3.5 天氣更新

```swift
/// index == nil 時用 routeCoordinates.first；否則用該站點座標
private func refreshWeather(forViewPointIndex index: Int?) {
    let coord: CLLocationCoordinate2D?
    if let i = index, i >= 0, i < journey.viewPointNodes.count,
       let lat = journey.viewPointNodes[i].latitude, let lon = journey.viewPointNodes[i].longitude {
        coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    } else {
        coord = routeCoordinates.first
    }
    guard let coordinate = coord else { return }
    WeatherManager.shared.fetchWeather(for: coordinate) { snapshot in
        weatherSnapshot = snapshot
    }
}
```

### 3.6 Sheet 內容順序（資訊層次）

1. **sheetHeroBlock**：封面圖，依 `sheetDetent` 控制高度/透明度/縮放（.large 全展，收縮時淡出縮小）  
2. **sheetTitleBlock**：路線名 + 分類膠囊  
3. **sheetSocialHeaderBlock**：作者頭像/名/認證 + 星標/評分/評論數  
4. **sheetSwipeHint**  
5. **sheetStatsCapsule**：時長、爬升等  
6. **sheetCategorySpecificBlock**：六大分區差異化（NRA/草原/國家公園/森林/州立公園等）  
7. **WeatherOverviewView**（天氣卡片）  
8. **sheetStartButton**  
9. **sheetAmenitiesBlock**  
10. **sheetElevationAreaChart**  
11. **sheetTimelineBlock**（Itinerary，點擊行設 `selectedViewPointIndex`，觸發飛圖 + 天氣）

---

## 四、依賴與外圍組件

- **WeatherManager**：`fetchWeather(for: CLLocationCoordinate2D, completion:)`，回調寫入 `weatherSnapshot`。  
- **WeatherSnapshot**：含 temperatureFahrenheit、conditionSymbol、windSpeedMph、precipitationChance、waterTempFahrenheit（NRA 等）等，詳情頁僅做展示。  
- **LandManagementTheme**：由 `journey.category` 映射 accent 色與按鈕/海拔等差異化，與 RouteModel 無直接耦合。  
- **Color(hex:)**：專案內擴展，用於主題色與固定色值。

---

## 五、審核可關注點（建議）

1. **模型**：`DetailedTrackPost` 與 `ViewPointNode` 的完整性、可選性與向後兼容；`calculatedRealDuration` 的時區/格式假設。  
2. **狀態**：`selectedViewPointIndex` 與 `sheetDetent` 的聯動是否覆蓋所有交互路徑；`routeSegments` 只寫一次、不隨 journey 變更刷新的取捨。  
3. **地圖**：`regionForCoordinates` 的邊界與最小 span；`cameraForRegion` 的 distance 公式；medium 檔位南移 0.28 的常數是否需可配置。  
4. **路徑**：MKDirections 並發與 `routeSegments.isEmpty` 條件；部分段失敗時 `compactMap` 導致斷線的處理。  
5. **天氣**：僅在 onAppear 與選中站點時拉取，無輪詢或手動刷新，是否滿足產品預期。  
6. **Sheet**：Hero 與 `sheetDetent` 的動畫是否與系統手勢一致；資訊層次與可訪問性。

以上為當前詳情頁 RouteModel、視圖狀態與 DetailedTrackView 核心邏輯的整理，可直接提供給 AI 進行邏輯深度審核與優化建議。
