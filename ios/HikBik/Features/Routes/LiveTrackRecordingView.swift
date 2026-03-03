// Record Live Track – CoreLocation foreground tracking, auto-waypoints, save as draft
import SwiftUI
import MapKit
import CoreLocation

// MARK: - Live Track Recording View
struct LiveTrackRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var tracker = LiveTrackLocationTracker()

    var body: some View {
        ZStack(alignment: .top) {
            liveTrackMap
            liveTrackStatsOverlay
            liveTrackControls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0B121F"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(Color(hex: "9CA3AF"))
            }
        }
        .onAppear {
            tracker.requestAuthorization()
        }
        .preferredColorScheme(.dark)
    }

    private var liveTrackMap: some View {
        Map(initialPosition: .region(tracker.mapRegion), interactionModes: .all) {
            if let polyline = tracker.routePolyline {
                MapPolyline(coordinates: polyline)
                    .stroke(Color(hex: "10B981"), lineWidth: 4)
            }
            ForEach(Array(tracker.waypoints.enumerated()), id: \.offset) { idx, pt in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: pt.latitude, longitude: pt.longitude)) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(idx == 0 ? Color(hex: "10B981") : Color(hex: "FF8C42"))
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(.container)
    }

    private var liveTrackStatsOverlay: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                statCard(icon: "clock.fill", value: tracker.elapsedTimeFormatted, label: "Elapsed")
                statCard(icon: "arrow.triangle.swap", value: tracker.distanceFormatted, label: "Distance")
                statCard(icon: "arrow.up.right", value: tracker.elevationFormatted, label: "Elevation")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 16)
            .padding(.horizontal, 20)
            Spacer()
        }
    }

    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "10B981"))
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity)
    }

    private var liveTrackControls: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                if tracker.isRecording {
                    Button {
                        tracker.stopRecording()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "stop.fill")
                            Text("Stop")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "EF4444"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                } else {
                    Button {
                        tracker.startRecording()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "record.circle")
                            Text("Start Recording")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "10B981"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .overlay(alignment: .bottom) {
            if tracker.hasRecordedTrack, !tracker.isRecording {
                NavigationLink(destination: CustomRouteBuilderView(liveTrackDraft: tracker.buildDraft())) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save as Draft")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "FF8C42"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Live Track Location Tracker
private final class LiveTrackLocationTracker: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)] = []
    @Published var totalDistanceMeters: Double = 0
    @Published var currentElevation: Double = 0
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    private let locationManager = CLLocationManager()
    private var recordingStartDate: Date?
    private var lastLocation: CLLocation?
    private var lastWaypointLocation: CLLocation?
    private var lastWaypointTime: Date?
    private var timer: Timer?
    private let autoWaypointDistanceMeters: Double = 500
    private let autoWaypointStopDurationSeconds: TimeInterval = 120

    var elapsedTimeFormatted: String {
        let mins = Int(elapsedSeconds) / 60
        let secs = Int(elapsedSeconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    var distanceFormatted: String {
        if totalDistanceMeters < 1000 {
            return String(format: "%.0f m", totalDistanceMeters)
        }
        return String(format: "%.2f km", totalDistanceMeters / 1000)
    }

    var elevationFormatted: String {
        if currentElevation > 0 {
            return String(format: "%.0f m", currentElevation)
        }
        return "—"
    }

    var routePolyline: [CLLocationCoordinate2D]? {
        guard waypoints.count >= 2 else { return nil }
        return waypoints.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    var hasRecordedTrack: Bool { !waypoints.isEmpty }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.allowsBackgroundLocationUpdates = false
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startRecording() {
        guard !isRecording else { return }
        waypoints = []
        totalDistanceMeters = 0
        currentElevation = 0
        elapsedSeconds = 0
        lastLocation = nil
        lastWaypointLocation = nil
        lastWaypointTime = nil
        recordingStartDate = Date()
        isRecording = true
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }

    func buildDraft() -> LiveTrackDraft {
        LiveTrackDraft(waypoints: waypoints)
    }

    private func tick() {
        guard let start = recordingStartDate else { return }
        elapsedSeconds = Date().timeIntervalSince(start)
    }

    private func addWaypoint(from location: CLLocation) {
        let pt = (
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            elevation: location.altitude,
            timestamp: Date()
        )
        waypoints.append(pt)
        lastWaypointLocation = location
        lastWaypointTime = Date()
        updateMapRegion()
    }

    private func updateMapRegion() {
        guard !waypoints.isEmpty else { return }
        let lats = waypoints.map(\.latitude)
        let lons = waypoints.map(\.longitude)
        let minLat = lats.min() ?? 0
        let maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0
        let maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.5 + 0.005),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.5 + 0.005)
        )
        mapRegion = MKCoordinateRegion(center: center, span: span)
    }

    private func processLocation(_ location: CLLocation) {
        currentElevation = location.altitude

        if waypoints.isEmpty {
            addWaypoint(from: location)
            lastLocation = location
            return
        }

        if let last = lastLocation {
            totalDistanceMeters += location.distance(from: last)
        }
        lastLocation = location

        // Auto-waypoint: every 500m
        if let lastWp = lastWaypointLocation {
            let distFromLastWp = location.distance(from: lastWp)
            if distFromLastWp >= autoWaypointDistanceMeters {
                addWaypoint(from: location)
                return
            }
        }

        // Auto-waypoint: stopped 2+ mins (speed < 0.5 m/s for 2 mins)
        let speed = location.speed >= 0 ? location.speed : 0
        if speed < 0.5 {
            if let lastTime = lastWaypointTime {
                if Date().timeIntervalSince(lastTime) >= autoWaypointStopDurationSeconds {
                    addWaypoint(from: location)
                }
            } else {
                lastWaypointTime = Date()
            }
        } else {
            lastWaypointTime = nil
        }
    }
}

extension LiveTrackLocationTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isRecording, let location = locations.last, location.horizontalAccuracy >= 0 else { return }
        DispatchQueue.main.async { [weak self] in
            self?.processLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
