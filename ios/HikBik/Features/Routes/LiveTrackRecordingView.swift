// LiveTrackRecordingView – Record → Edit preview → Title/cover required → Publish only
import SwiftUI
import MapKit
import CoreLocation

private let neonGreen = Color(hex: "10B981")
private let bgDark = Color(hex: "0B121F")
private let cardBg = Color(hex: "2A3540")
private let textMuted = Color(hex: "9CA3AF")

private let defaultCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

private struct PostEditorSheetItem: Identifiable {
    let id = UUID()
    let draft: LiveTrackDraft
    let distanceMeters: Double
    let elevationMeters: Double
    let durationSeconds: TimeInterval
    let defaultTitle: String
}

// MARK: - Live Track Recording View
struct LiveTrackRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var trackDataManager = TrackDataManager.shared
    @ObservedObject private var engine = TrackRecorderEngine.shared

    @State private var mapRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .region(MKCoordinateRegion(center: defaultCenter, span: defaultSpan)))
    @State private var hasInitialFocus = false
    @State private var sportType: SportType = .hiking
    @State private var showSportPicker = false
    @State private var showFinishConfirm = false
    @State private var editorSheetItem: PostEditorSheetItem?
    @State private var finishedJourney: ManualJourney?
    @State private var navigateToDetail = false
    @State private var showCancelConfirm = false
    @State private var useSatelliteMap = false

    var body: some View {
        ZStack(alignment: .top) {
            mapView
            topStatsOverlay
            bottomControlBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgDark)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { showCancelConfirm = true }
                    .foregroundStyle(textMuted)
            }
        }
        .confirmationDialog("Exit recording?", isPresented: $showCancelConfirm, titleVisibility: .visible) {
            Button("Save to Draft") {
                saveRecordingToDraftAndExit()
            }
            Button("Discard", role: .destructive) {
                engine.stopRecording()
                showCancelConfirm = false
                dismiss()
            }
            Button("Resume", role: .cancel) {
                showCancelConfirm = false
            }
        } message: {
            Text("Save your current track to Draft Box (Live Recorded) to edit later, or discard and exit.")
        }
        .onAppear {
            engine.requestAuthorization()
            engine.startRecording()
            TrackRecordingLiveActivityManager.start(activityType: sportType.rawValue)
        }
        .onDisappear {
            if !engine.isRecording {
                engine.stopLocationUpdatesForDisplay()
            }
            TrackRecordingLiveActivityManager.endIfNeeded()
        }
        .onChange(of: engine.locations.count) { _, newCount in
            if !hasInitialFocus && newCount >= 1 {
                hasInitialFocus = true
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    position = .userLocation(followsHeading: false, fallback: .automatic)
                }
            }
        }
        .onChange(of: engine.distance) { _, _ in
            TrackRecordingLiveActivityManager.update(
                distanceMeters: engine.distance,
                durationSeconds: engine.elapsedSeconds,
                elevationMeters: engine.elevation,
                isPaused: engine.isPaused
            )
        }
        .onChange(of: engine.elapsedSeconds) { _, _ in
            TrackRecordingLiveActivityManager.update(
                distanceMeters: engine.distance,
                durationSeconds: engine.elapsedSeconds,
                elevationMeters: engine.elevation,
                isPaused: engine.isPaused
            )
        }
        .onChange(of: engine.elevation) { _, _ in
            TrackRecordingLiveActivityManager.update(
                distanceMeters: engine.distance,
                durationSeconds: engine.elapsedSeconds,
                elevationMeters: engine.elevation,
                isPaused: engine.isPaused
            )
        }
        .onChange(of: engine.isPaused) { _, _ in
            TrackRecordingLiveActivityManager.update(
                distanceMeters: engine.distance,
                durationSeconds: engine.elapsedSeconds,
                elevationMeters: engine.elevation,
                isPaused: engine.isPaused
            )
        }
        .confirmationDialog("Sport Type", isPresented: $showSportPicker, titleVisibility: .visible) {
            ForEach(SportType.allCases, id: \.self) { sport in
                Button(sport.rawValue) { sportType = sport }
            }
            Button("Cancel", role: .cancel) {}
        } message: { Text("Choose activity type.") }
        .confirmationDialog("Stop Recording", isPresented: $showFinishConfirm, titleVisibility: .visible) {
            Button("Resume") {
                showFinishConfirm = false
            }
            Button("Finish & Edit") {
                finishAndOpenEditor()
                showFinishConfirm = false
            }
            Button("Discard", role: .destructive) {
                TrackRecorderEngine.shared.forceResetRecording()
                TrackRecordingLiveActivityManager.endIfNeeded()
                showFinishConfirm = false
                dismiss()
            }
        } message: { Text("Resume to keep recording. Finish & Edit to open the editor. Discard to delete this recording and exit.") }
        .fullScreenCover(item: $editorSheetItem) { item in
            PostEditorView(
                draft: item.draft,
                distanceMeters: item.distanceMeters,
                elevationMeters: item.elevationMeters,
                durationSeconds: item.durationSeconds,
                sportType: sportType,
                initialTitle: item.defaultTitle.isEmpty ? nil : item.defaultTitle,
                onSaveToDrafts: { title in
                    let waypoints = item.draft.waypoints.map { (latitude: $0.latitude, longitude: $0.longitude, elevation: $0.elevation, timestamp: $0.timestamp) }
                    let polyline = item.draft.waypoints.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                    let draftItem = DraftItem.fromLiveTrack(waypoints: waypoints, polyline: polyline, durationSeconds: item.durationSeconds, title: title.isEmpty ? nil : title)
                    trackDataManager.addDraft(draftItem)
                    TrackRecorderEngine.shared.forceResetRecording()
                    editorSheetItem = nil
                    dismiss()
                },
                onPublish: { journey in
                    // 直接寫入 publishedTracks，不經草稿；全新 Draft 由 fromLiveTrack 組裝
                    let waypoints = engine.locations.map { (latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude, elevation: $0.altitude, timestamp: $0.timestamp) }
                    let start = waypoints.first
                    Task {
                        let locationName = await DraftItem.geocodeStartLocation(
                            latitude: start?.latitude ?? 0,
                            longitude: start?.longitude ?? 0
                        ) ?? "Trail Start"
                        let (weather, facilities) = DraftItem.injectContextForStart(
                            latitude: start?.latitude ?? 0,
                            longitude: start?.longitude ?? 0
                        )
                        var newPost = DraftItem.fromLiveTrack(
                            waypoints: waypoints,
                            polyline: engine.routePolyline,
                            durationSeconds: engine.elapsedSeconds,
                            title: journey.routeName,
                            locationName: locationName,
                            currentWeather: weather,
                            nearbyFacilities: facilities
                        )
                        if let enc = try? JSONEncoder().encode(journey),
                           let jsonStr = String(data: enc, encoding: .utf8) {
                            newPost.detailedTrackJSON = jsonStr
                        }
                        await MainActor.run {
                            printPublishPayloadsToConsole(newPost)
                            trackDataManager.addPublished(newPost)
                            trackDataManager.objectWillChange.send()
                            TrackRecordingLiveActivityManager.startPublishedActivity(
                                distanceMeters: newPost.totalDistanceMeters,
                                durationSeconds: newPost.durationSeconds ?? 0,
                                elevationMeters: newPost.elevationGainMeters
                            )
                            TrackRecorderEngine.shared.forceResetRecording()
                        }
                    }
                },
                onPublishComplete: {
                    TrackRecorderEngine.shared.forceResetRecording()
                    editorSheetItem = nil
                    dismiss()
                    DispatchQueue.main.async {
                        TabSelectionManager.shared.switchToCommunity()
                    }
                }
            )
            .environmentObject(trackDataManager)
        }
        .preferredColorScheme(.dark)
    }

    private var defaultJourney: ManualJourney {
        DetailedTrackPost(routeName: "", totalDurationMinutes: 0, viewPointNodes: [])
    }

    // MARK: - Map: live polyline, auto focus, location + map-type buttons
    private var mapView: some View {
        Map(position: $position, interactionModes: .all) {
            UserAnnotation()
            if !engine.locations.isEmpty {
                MapPolyline(coordinates: engine.routePolyline)
                    .stroke(neonGreen, lineWidth: 6)
                    .id(engine.locations.count)
            }
        }
        .mapStyle(useSatelliteMap ? .imagery(elevation: .realistic) : .standard(elevation: .realistic))
        .overlay(alignment: .topTrailing) {
            Button {
                useSatelliteMap.toggle()
            } label: {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.95))
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
                    Circle()
                        .stroke(neonGreen.opacity(0.4), lineWidth: 1)
                        .frame(width: 44, height: 44)
                    Image(systemName: "map.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(neonGreen)
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
            .padding(.top, 72)
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    position = .userLocation(followsHeading: false, fallback: .automatic)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.95))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    Circle()
                        .stroke(neonGreen.opacity(0.4), lineWidth: 1)
                        .frame(width: 52, height: 52)
                    Image(systemName: "location.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(neonGreen)
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
            .padding(.bottom, 130)
        }
        .overlay(alignment: .bottom) {
            if engine.authorizationStatus == .denied || engine.authorizationStatus == .restricted {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Enable location in Settings", systemImage: "location.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(neonGreen)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 100)
            } else if engine.locations.isEmpty && engine.isRecording {
                Text("Getting location…")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 100)
            }
        }
        .onReceive(engine.$locations) { locations in
            guard let last = locations.last else { return }
            mapRegion = MKCoordinateRegion(center: last.coordinate, span: mapRegion.span)
            position = .region(mapRegion)
        }
        .ignoresSafeArea(.container)
    }

    private var topStatsOverlay: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                if engine.isPaused {
                    Text("Paused")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "EF4444"))
                        .clipShape(Capsule())
                }
                statPill(icon: "arrow.triangle.swap", value: distanceFormatted, label: "Distance")
                statPill(icon: "clock.fill", value: timeFormatted, label: "Time")
                statPill(icon: "arrow.up.right", value: elevationFormatted, label: "Elevation Gain")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 16)
            .padding(.horizontal, 20)
            Spacer()
        }
    }

    private func statPill(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(neonGreen)
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var distanceFormatted: String {
        let miles = engine.distance * 0.000621371
        return miles < 0.01 ? "0 mi" : String(format: "%.2f mi", miles)
    }

    private var timeFormatted: String {
        let t = Int(engine.elapsedSeconds)
        let h = t / 3600, m = (t % 3600) / 60, s = t % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s) : String(format: "%d:%02d", m, s)
    }

    private var elevationFormatted: String {
        let ft = engine.elevation * 3.28084
        return ft < 1 ? "0 ft" : String(format: "%.0f ft", ft)
    }

    private var bottomControlBar: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 12) {
                if engine.isRecording {
                    Button { showFinishConfirm = true } label: {
                        Text("Stop")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(cardBg)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)

                    Button {
                        if engine.isPaused { engine.resumeRecording() } else { engine.pauseRecording() }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: engine.isPaused ? "play.fill" : "pause.fill")
                            Text(engine.isPaused ? "Resume" : "Pause")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(engine.isPaused ? neonGreen : Color(hex: "EF4444"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                } else {
                    Button { showSportPicker = true } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "figure.hiking")
                            Text("\(sportType.rawValue)")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(cardBg)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)

                    Button {
                        TrackRecordingLiveActivityManager.start(activityType: sportType.rawValue)
                        engine.startRecording()
                    } label: {
                        Text("Start")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(bgDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(neonGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }

    /// Save Draft path: add to draftTracks at 0, end Live Activity, dismiss to previous page.
    private func saveRecordingToDraftAndExit() {
        let draft = engine.buildDraft()
        let item = DraftItem.fromLiveTrack(
            waypoints: draft.waypoints,
            polyline: engine.routePolyline,
            durationSeconds: engine.elapsedSeconds
        )
        engine.stopRecording()
        TrackRecordingLiveActivityManager.endIfNeeded()
        trackDataManager.addDraft(item)
        showCancelConfirm = false
        dismiss()
    }

    /// Publish flow: stop engine, delay 0.2s then build data and present editor sheet.
    private func finishAndOpenEditor() {
        engine.stopRecording()
        showFinishConfirm = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let draft = engine.buildDraft()
            let distance = engine.distance
            let elevation = engine.elevation
            let duration = engine.elapsedSeconds
            Task {
                let title = await geocodeDefaultTitle(draft: draft)
                await MainActor.run {
                    editorSheetItem = PostEditorSheetItem(
                        draft: draft,
                        distanceMeters: distance,
                        elevationMeters: elevation,
                        durationSeconds: duration,
                        defaultTitle: title
                    )
                }
            }
        }
    }

    private func geocodeDefaultTitle(draft: LiveTrackDraft) async -> String {
        guard let lastPoint = draft.waypoints.last else {
            return "\(sportType.rawValue) · \(dateString)"
        }
        let loc = CLLocation(latitude: lastPoint.latitude, longitude: lastPoint.longitude)
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(loc)
            let name = placemarks.first?.locality ?? placemarks.first?.administrativeArea ?? placemarks.first?.name
            if let n = name, !n.isEmpty {
                return "\(n) · \(dateString) · \(sportType.rawValue)"
            }
        } catch {}
        return "\(dateString) · \(sportType.rawValue)"
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: Date())
    }
}
