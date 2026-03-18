// Route Following Navigation – 跟隨此路線：Template Route (灰) + Live Track (藍)、偏航提醒、View Point 彈窗
import SwiftUI
import MapKit
import CoreLocation

struct RouteFollowingNavigationView: View {
    let journey: ManualJourney
    var onDismiss: () -> Void

    @StateObject private var navState = RouteFollowingNavigationState()

    private var templateCoordinates: [CLLocationCoordinate2D] {
        journey.viewPointNodes.compactMap { node in
            guard let lat = node.latitude, let lon = node.longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $navState.mapPosition, interactionModes: .all) {
                UserAnnotation()
                if !templateCoordinates.isEmpty {
                    MapPolyline(coordinates: templateCoordinates)
                        .stroke(Color.gray.opacity(0.8), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                }
                if navState.liveTrackCoordinates.count >= 2 {
                    MapPolyline(coordinates: navState.liveTrackCoordinates)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .all)
            .onAppear {
                navState.start(journey: journey, templateCoords: templateCoordinates)
            }
            .onDisappear {
                navState.stop()
            }

            VStack(spacing: 0) {
                // Top data panel: Elapsed, Distance, Elevation (synced to live path)
                dataPanel
                if navState.isOffCourse {
                    Text("You are off-course!")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(.horizontal, 40)
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                HStack {
                    Button("Done") {
                        onDismiss()
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, navState.isOffCourse ? 8 : 12)
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: navState.isOffCourse)
        }
        .preferredColorScheme(.dark)
    }

    private var dataPanel: some View {
        HStack(spacing: 20) {
            dataItem(label: "Elapsed", value: navState.elapsedFormatted)
            dataItem(label: "Distance", value: navState.distanceFormatted)
            dataItem(label: "Elevation", value: navState.elevationFormatted)
        }
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func dataItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .foregroundStyle(.white.opacity(0.8))
            Text(value)
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}

// MARK: - State: Navigation-grade location, live path, smoothing, data panel (View Points hidden in tracking mode)
private final class RouteFollowingNavigationState: NSObject, ObservableObject {
    @Published var mapPosition: MapCameraPosition = .automatic
    @Published var liveTrackCoordinates: [CLLocationCoordinate2D] = []
    @Published var isOffCourse = false
    @Published private(set) var elapsedSeconds: TimeInterval = 0
    @Published private(set) var totalDistanceMeters: Double = 0
    @Published private(set) var elevationGainMeters: Double = 0

    var elapsedFormatted: String {
        let m = Int(elapsedSeconds) / 60
        let s = Int(elapsedSeconds) % 60
        return String(format: "%d:%02d", m, s)
    }
    var distanceFormatted: String {
        if totalDistanceMeters >= 1000 {
            return String(format: "%.2f km", totalDistanceMeters / 1000)
        }
        return String(format: "%.0f m", totalDistanceMeters)
    }
    var elevationFormatted: String {
        return String(format: "+%.0f m", elevationGainMeters)
    }

    private let locationManager = CLLocationManager()
    private var timer: Timer?
    private var templateCoords: [CLLocationCoordinate2D] = []
    private let offCourseThresholdMeters: Double = 30
    private var recordingStartDate: Date?
    private var lastLocationForStats: CLLocation?
    private var lastSmoothedCoordinate: CLLocationCoordinate2D?
    private let smoothingAlpha: Double = 0.6

    func start(journey: ManualJourney, templateCoords: [CLLocationCoordinate2D]) {
        self.templateCoords = templateCoords
        recordingStartDate = Date()
        lastLocationForStats = nil
        lastSmoothedCoordinate = nil
        elapsedSeconds = 0
        totalDistanceMeters = 0
        elevationGainMeters = 0
        liveTrackCoordinates = []

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()

        if let first = templateCoords.first {
            mapPosition = .region(MKCoordinateRegion(center: first, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }

    private func tick() {
        guard let loc = locationManager.location else { return }
        checkOffCourse(loc: loc)
        updateElapsed()
    }

    private func updateElapsed() {
        guard let start = recordingStartDate else { return }
        DispatchQueue.main.async { [weak self] in
            self?.elapsedSeconds = Date().timeIntervalSince(start)
        }
    }

    private func checkOffCourse(loc: CLLocation) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let dist = self.distanceToTemplate(from: loc.coordinate)
            let wasOff = self.isOffCourse
            self.isOffCourse = dist > self.offCourseThresholdMeters
            if self.isOffCourse, !wasOff {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }

    private func distanceToTemplate(from coordinate: CLLocationCoordinate2D) -> Double {
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard !templateCoords.isEmpty else { return 0 }
        var minDist: Double = .greatestFiniteMagnitude
        for c in templateCoords {
            let other = CLLocation(latitude: c.latitude, longitude: c.longitude)
            minDist = min(minDist, loc.distance(from: other))
        }
        return minDist
    }

    private func smoothedCoordinate(from location: CLLocation) -> CLLocationCoordinate2D {
        let raw = location.coordinate
        guard let last = lastSmoothedCoordinate else {
            lastSmoothedCoordinate = raw
            return raw
        }
        let lat = smoothingAlpha * raw.latitude + (1 - smoothingAlpha) * last.latitude
        let lon = smoothingAlpha * raw.longitude + (1 - smoothingAlpha) * last.longitude
        let smoothed = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        lastSmoothedCoordinate = smoothed
        return smoothed
    }

    private func processNewLocations(_ locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for location in locations {
                let coord = self.smoothedCoordinate(from: location)
                self.liveTrackCoordinates.append(coord)
                if self.liveTrackCoordinates.count > 500 {
                    self.liveTrackCoordinates.removeFirst(100)
                }
                if let prev = self.lastLocationForStats {
                    let dist = location.distance(from: prev)
                    self.totalDistanceMeters += dist
                    let altDiff = location.altitude - prev.altitude
                    if altDiff > 0 { self.elevationGainMeters += altDiff }
                }
                self.lastLocationForStats = location
            }
        }
    }
}

extension RouteFollowingNavigationState: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        processNewLocations(locations)
    }
}
