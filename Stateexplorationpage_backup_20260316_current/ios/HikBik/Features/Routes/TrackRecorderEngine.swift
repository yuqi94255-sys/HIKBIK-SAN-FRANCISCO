// MARK: - Track Recorder Engine — 單例軌跡引擎，精確度過濾、里程/爬升計算、後台錄製
import SwiftUI
import CoreLocation
import MapKit

/// 單例：專業級錄製引擎，過濾 GPS 雜訊、位移觸發、海拔累加，支援後台與模擬器測試
final class TrackRecorderEngine: NSObject, ObservableObject {
    static let shared = TrackRecorderEngine()

    /// 軌跡點（已過濾）
    @Published private(set) var locations: [CLLocation] = []
    /// 總里程（米）
    @Published private(set) var distance: Double = 0
    /// 累計爬升（米）
    @Published private(set) var elevation: Double = 0
    /// 是否正在錄製
    @Published private(set) var isRecording: Bool = false
    /// 是否暫停（暫停時不累計時長、不處理新點）
    @Published private(set) var isPaused: Bool = false
    /// 錄製經過秒數（含暫停前累計）
    @Published private(set) var elapsedSeconds: TimeInterval = 0
    /// 定位權限狀態（用於 UI 提示）
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let locationManager = CLLocationManager()
    private var lastRecordedLocation: CLLocation?
    private var recordingStartDate: Date?
    private var elapsedTimer: Timer?
    private let accuracyThreshold: CLLocationAccuracy = 20
    private let minDistanceMeters: Double = 3

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        authorizationStatus = locationManager.authorizationStatus
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    /// 進入錄製頁時即開啟 GPS，讓地圖能顯示藍點（不錄製、不寫入 locations）
    func startLocationUpdatesForDisplay() {
        locationManager.startUpdatingLocation()
    }

    /// 離開錄製頁且未在錄製時關閉 GPS，省電
    func stopLocationUpdatesForDisplay() {
        guard !isRecording else { return }
        locationManager.stopUpdatingLocation()
    }

    func startRecording() {
        guard !isRecording else { return }
        if let lastKnown = locationManager.location {
            locations = [lastKnown]
        } else {
            locations = []
        }
        distance = 0
        elevation = 0
        elapsedSeconds = 0
        lastRecordedLocation = nil
        recordingStartDate = Date()
        isPaused = false
        isRecording = true
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        startElapsedTimer()
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        isPaused = false
        locationManager.stopUpdatingLocation()
        elapsedTimer?.invalidate()
        elapsedTimer = nil
        recordingStartDate = nil
    }

    /// Called in PublishView publish-success callback. Stops timer, clears coordinates, zeros all stats.
    func forceResetRecording() {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in self?.forceResetRecording(); return }
            return
        }
        elapsedTimer?.invalidate()
        elapsedTimer = nil
        locationManager.stopUpdatingLocation()
        isRecording = false
        isPaused = false
        recordingStartDate = nil
        lastRecordedLocation = nil
        locations.removeAll()
        distance = 0
        elevation = 0
        elapsedSeconds = 0
        objectWillChange.send()
    }

    func clearAllData() { forceResetRecording() }
    func resetSession() { forceResetRecording() }

    func pauseRecording() {
        guard isRecording, !isPaused else { return }
        isPaused = true
        elapsedTimer?.invalidate()
        elapsedTimer = nil
        locationManager.stopUpdatingLocation()
    }

    func resumeRecording() {
        guard isRecording, isPaused else { return }
        isPaused = false
        recordingStartDate = Date() - elapsedSeconds
        locationManager.startUpdatingLocation()
        startElapsedTimer()
    }

    private func startElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.isRecording, !self.isPaused, let start = self.recordingStartDate else { return }
            DispatchQueue.main.async {
                self.elapsedSeconds = Date().timeIntervalSince(start)
            }
        }
        RunLoop.main.add(elapsedTimer!, forMode: .common)
    }

    /// 模擬器 / 無出門測試：手動追加一個座標，觸發 UI 實時更新
    func mockAddLocation(latitude: Double = 37.7749, longitude: Double = -122.4194, altitude: Double = 10) {
        let loc = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            altitude: altitude,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: Date()
        )
        processLocation(loc)
    }

    /// 軌跡折線座標（供 Map 繪製）
    var routePolyline: [CLLocationCoordinate2D] {
        locations.map(\.coordinate)
    }

    /// 地圖顯示區域（依軌跡邊界計算，無點時回傳預設）
    var mapRegion: MKCoordinateRegion {
        guard !locations.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
            )
        }
        let lats = locations.map(\.coordinate.latitude)
        let lons = locations.map(\.coordinate.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.5 + 0.005),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.5 + 0.005)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    var hasRecordedTrack: Bool { !locations.isEmpty }

    /// 轉為 LiveTrackDraft 供 Save as Draft / 轉 Pro Guide 使用
    func buildDraft() -> LiveTrackDraft {
        let waypoints = locations.map { (latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude, elevation: $0.altitude, timestamp: $0.timestamp) }
        return LiveTrackDraft(waypoints: waypoints)
    }

    private func processLocation(_ location: CLLocation) {
        guard isRecording, !isPaused else { return }
        // 第一個點：放寬精度（真機首次定位可能 50–100m），確保至少有一個點讓地圖對焦
        let acceptableAccuracy = locations.isEmpty ? 150.0 : accuracyThreshold
        guard location.horizontalAccuracy >= 0, location.horizontalAccuracy < acceptableAccuracy else { return }

        if locations.isEmpty {
            appendLocation(location)
            lastRecordedLocation = location
            return
        }

        guard let last = lastRecordedLocation else { return }
        let deltaMeters = location.distance(from: last)
        if deltaMeters < minDistanceMeters { return }

        appendLocation(location)
        distance += deltaMeters
        let altDiff = location.altitude - last.altitude
        if altDiff > 0 { elevation += altDiff }
        lastRecordedLocation = location
    }

    private func appendLocation(_ location: CLLocation) {
        locations.append(location)
    }
}

extension TrackRecorderEngine: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard let location = newLocations.last else { return }
        DispatchQueue.main.async { [weak self] in
            self?.processLocation(location)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = manager.authorizationStatus
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
