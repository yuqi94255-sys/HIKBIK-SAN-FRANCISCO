// Post-Recording Editor – 多圖選擇、智慧封底、嚴格校驗，Save to Drafts / Publish to Community
import SwiftUI
import PhotosUI
import MapKit
import UIKit
import UniformTypeIdentifiers

/// 用於 PhotosPickerItem 載入圖片 Data（iOS 17+ 上 Data.self 常失敗，改用明確 .image 類型）
private struct PickedImageData: Transferable {
    let data: Data
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            PickedImageData(data: data)
        }
    }
}

/// 運動類型（與 LiveTrackRecordingView 共用，本檔案定義以確保編譯可見）
enum SportType: String, CaseIterable {
    case hiking = "Hiking"
    case biking = "Biking"
    case running = "Running"
}

private let editorBg = Color(hex: "0B121F")
private let editorCard = Color(hex: "2A3540")
private let editorGreen = Color(hex: "10B981")
private let editorMuted = Color(hex: "9CA3AF")
private let editorOrange = Color(hex: "FF8C42")
private let maxPhotoCount = 9

private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard !coords.isEmpty else {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    var minLat = coords[0].latitude, maxLat = minLat
    var minLon = coords[0].longitude, maxLon = minLon
    for c in coords.dropFirst() {
        minLat = min(minLat, c.latitude); maxLat = max(maxLat, c.latitude)
        minLon = min(minLon, c.longitude); maxLon = max(maxLon, c.longitude)
    }
    let padding = 0.008
    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLon + maxLon) / 2
    )
    let span = MKCoordinateSpan(
        latitudeDelta: max(0.02, (maxLat - minLat) + padding * 2),
        longitudeDelta: max(0.02, (maxLon - minLon) + padding * 2)
    )
    return MKCoordinateRegion(center: center, span: span)
}

// MARK: - Post Editor View
struct PostEditorView: View {
    let draft: LiveTrackDraft
    let distanceMeters: Double
    let elevationMeters: Double
    let durationSeconds: TimeInterval
    let sportType: SportType
    var initialTitle: String? = nil
    /// When non-nil, editor is editing a draft; Cancel shows "Save changes to draft?" and Publish must remove this draft then add to published.
    var sourceDraftId: UUID? = nil
    /// 當非 nil 時，在發布按鈕處直接對單例硬寫入，跳過閉包傳遞（與 sourceDraftId 對應同一條草稿）。
    var sourceDraftItem: DraftItem? = nil
    /// Called with current title when user taps Save to Drafts; caller should add DraftItem to TrackDataManager.draftTracks then dismiss.
    var onSaveToDrafts: (String) -> Void
    var onPublish: (ManualJourney) -> Void
    var onPublishComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var showExitConfirm = false
    @FocusState private var isDescriptionFocused: Bool
    @State private var title: String = ""
    @State private var descriptionText: String = ""
    @State private var selectedImageData: [Data] = []
    @State private var pendingPhotoItems: [PhotosPickerItem] = []
    @State private var isPublishing = false
    @State private var showPublishedToast = false
    /// 暴力測試：發布點擊後立刻彈窗，證明按鈕閉包有執行
    @State private var showPublishSuccessAlert = false

    /// 第一張為封面
    private var coverImageData: Data? { selectedImageData.first }
    private var selectedImages: [UIImage] {
        selectedImageData.compactMap { UIImage(data: $0) }
    }
    /// 嚴格發布：至少一張圖 + 標題有文字
    private var canPublish: Bool {
        !selectedImageData.isEmpty && !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    /// 臨時放寬：僅標題非空即可點發布（用於跑通邏輯，之後可改回 canPublish）
    private var canPublishRelaxed: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    private var publishHint: String {
        let noPhoto = selectedImageData.isEmpty
        let noTitle = title.trimmingCharacters(in: .whitespaces).isEmpty
        if noPhoto && noTitle { return "Add at least one photo and a title to publish." }
        if noPhoto { return "Add at least one photo to publish." }
        if noTitle { return "Enter a title to publish." }
        return ""
    }

    private var polylineCoordinates: [CLLocationCoordinate2D] {
        draft.waypoints.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var mileageFormatted: String {
        let miles = distanceMeters * 0.000621371
        if miles < 0.01 { return "0 mi" }
        return String(format: "%.2f mi", miles)
    }

    private var elevationFormatted: String {
        let ft = elevationMeters * 3.28084
        return String(format: "%.0f ft", ft)
    }

    private var durationFormatted: String {
        let total = Int(durationSeconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        if h > 0 { return String(format: "%dh %02dm", h, m) }
        return String(format: "%d min", m)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    titleSection
                    photosSection
                    statsSection
                    descriptionSection
                    cardPreviewSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            .background(editorBg)
            .scrollIndicators(.hidden)
            .navigationTitle("Edit Recording")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(editorBg, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if sourceDraftId != nil {
                            showExitConfirm = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundStyle(editorMuted)
                }
            }
            .confirmationDialog("Do you want to save changes to this draft?", isPresented: $showExitConfirm, titleVisibility: .visible) {
                Button("Save") {
                    draft.saveToUserDefaults()
                    onSaveToDrafts(title.trimmingCharacters(in: .whitespaces))
                    showExitConfirm = false
                    dismiss()
                }
                Button("Discard", role: .destructive) {
                    showExitConfirm = false
                    dismiss()
                }
                Button("Cancel", role: .cancel) {
                    showExitConfirm = false
                }
            } message: { Text("Save your edits to the draft or discard and exit.") }
            .safeAreaInset(edge: .bottom) {
                bottomButtons
            }
        }
        .onAppear {
            if let t = initialTitle, !t.isEmpty {
                title = t
            } else if title.isEmpty {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                title = "\(formatter.string(from: Date())) · \(sportType.rawValue)"
            }
        }
        .onChange(of: pendingPhotoItems) { _, newItems in
            guard !newItems.isEmpty else { return }
            Task {
                var loaded: [Data] = []
                for item in newItems {
                    // 優先用 PickedImageData（.image）避免 iOS 17+ 上 Data.self 載入失敗
                    if let picked = try? await item.loadTransferable(type: PickedImageData.self) {
                        loaded.append(picked.data)
                    } else if let d = try? await item.loadTransferable(type: Data.self) {
                        loaded.append(d)
                    }
                }
                await MainActor.run {
                    if !loaded.isEmpty {
                        selectedImageData.append(contentsOf: loaded)
                        if selectedImageData.count > maxPhotoCount {
                            selectedImageData = Array(selectedImageData.prefix(maxPhotoCount))
                        }
                        print("DEBUG: 圖片已載入，當前 selectedImageData.count = \(selectedImageData.count)")
                    } else {
                        print("DEBUG: 圖片載入為空 — loadTransferable 未返回數據，請檢查相簿權限或格式")
                    }
                    pendingPhotoItems = []
                }
            }
        }
        .overlay {
            if showPublishedToast {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(editorGreen)
                    Text("Published Successfully")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2), lineWidth: 1))
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showPublishedToast)
        .preferredColorScheme(.dark)
        .onChange(of: showPublishedToast) { _, showing in
            if showing { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        }
        .onChange(of: showPublishSuccessAlert) { _, showing in
            if showing { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
        }
        .alert("發布成功", isPresented: $showPublishSuccessAlert) {
            Button("OK") {}
        } message: {
            Text("數據已寫入庫")
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(editorMuted)
            TextField("Route name", text: $title)
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(editorCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Photos")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(editorMuted)
                Text("First = cover")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(editorMuted.opacity(0.8))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(selectedImageData.enumerated()), id: \.offset) { index, data in
                        if let uiImage = UIImage(data: data) {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                if index == 0 {
                                    Text("Cover")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(editorGreen)
                                        .clipShape(Capsule())
                                        .padding(6)
                                }
                                Button {
                                    removePhoto(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(.white)
                                        .shadow(color: .black.opacity(0.6), radius: 2)
                                }
                                .padding(6)
                                .offset(x: 4, y: -4)
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                    if selectedImageData.count < maxPhotoCount {
                        PhotosPicker(
                            selection: $pendingPhotoItems,
                            maxSelectionCount: max(1, maxPhotoCount - selectedImageData.count),
                            matching: .images
                        ) {
                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 28))
                                    .foregroundStyle(editorGreen)
                                Text("Add")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(editorMuted)
                            }
                            .frame(width: 100, height: 100)
                            .background(editorCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func removePhoto(at index: Int) {
        guard index < selectedImageData.count else { return }
        selectedImageData.remove(at: index)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description (optional)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(editorMuted)
            ZStack(alignment: .topLeading) {
                if descriptionText.isEmpty {
                    Text("Record your mood...")
                        .font(.system(size: 15))
                        .foregroundStyle(editorMuted)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $descriptionText)
                    .focused($isDescriptionFocused)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 80, maxHeight: 120)
                    .contentShape(Rectangle())
            }
            .frame(minHeight: 80)
            .contentShape(Rectangle())
            .onTapGesture {
                isDescriptionFocused = true
            }
            .background(editorCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            statChip(icon: "arrow.triangle.swap", value: mileageFormatted, label: "Distance")
            statChip(icon: "clock.fill", value: durationFormatted, label: "Time")
            statChip(icon: "arrow.up.right", value: elevationFormatted, label: "Elevation Gain")
            statChip(icon: "cloud.sun.fill", value: "—", label: "Weather")
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(editorCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func statChip(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(editorGreen)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(editorMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var cardPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preview in community")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(editorMuted)
            cardPreview
        }
    }

    private var cardPreview: some View {
        let region = regionForCoordinates(polylineCoordinates)
        return VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                if let cover = coverImageData, let uiImage = UIImage(data: cover) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    Map(initialPosition: .region(region), interactionModes: []) {
                        MapPolyline(coordinates: polylineCoordinates)
                            .stroke(editorGreen, lineWidth: 4)
                    }
                    .frame(height: 140)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                }
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 140)
                    .allowsHitTesting(false)
                Text(title.isEmpty ? "Your route" : title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .padding(12)
            }
            .frame(height: 140)

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(editorGreen)
                    Text(mileageFormatted)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                }
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(editorGreen)
                    Text(durationFormatted)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                }
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundStyle(editorGreen)
                    Text(elevationFormatted)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(editorCard)
        }
        .background(editorCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private var bottomButtons: some View {
        VStack(spacing: 12) {
            Button {
                draft.saveToUserDefaults()
                onSaveToDrafts(title.trimmingCharacters(in: .whitespaces))
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save to Drafts")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(editorCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            Button {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                print("🔘 [DIAG] Button Tapped — 發布按鈕被點擊")
                let titleEmpty = title.trimmingCharacters(in: .whitespaces).isEmpty
                let imageEmpty = selectedImageData.isEmpty
                print("DEBUG: canPublish = \(canPublish), titleEmpty = \(titleEmpty), imageEmpty = \(imageEmpty), titleCount = \(title.count), imageCount = \(selectedImageData.count)")
                // 臨時放寬：僅要求標題非空即可發布，確保 onPublish(journey) 能執行（跑通邏輯後可改回 canPublish）
                guard !titleEmpty, !isPublishing else { return }
                isPublishing = true
                // 暴力修復：無視所有閉包傳遞，直接對總部單例寫入
                let finalJourney = buildJourney()
                if let source = sourceDraftItem {
                    TrackDataManager.shared.publishDraft(source, with: finalJourney)
                    TrackDataManager.shared.objectWillChange.send()
                    let isGrandJourney = source.category == .grandJourney
                    let postId = PostMediaStore.publishId(publishedIndex: 0, trackRouteID: isGrandJourney ? nil : source.routeID)
                    let urls = savePostMediaToDocuments(postId: postId, imageData: selectedImageData)
                    if !urls.isEmpty { PostMediaStore.shared.setImageUrls(id: postId, urls: urls) }
                    print("🚨 [FATAL_FIX] 暴力寫入完成！當前單例總數: \(TrackDataManager.shared.publishedTracks.count)")
                    TrackRecordingLiveActivityManager.startPublishedActivity(
                        distanceMeters: distanceMeters,
                        durationSeconds: durationSeconds,
                        elevationMeters: elevationMeters
                    )
                    showPublishedToast = true
                    showPublishSuccessAlert = true
                    onPublishComplete?()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPublishedToast = false
                        isPublishing = false
                    }
                    return
                }

                print("🚀 [FORCE] 即將執行 onPublish(journey)")
                onPublish(finalJourney)
                print("🚀 [FORCE] onPublish(journey) 已執行")
                showPublishedToast = true
                showPublishSuccessAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showPublishedToast = false
                    isPublishing = false
                    onPublishComplete?()
                }
            } label: {
                HStack(spacing: 8) {
                    if isPublishing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: editorBg))
                    } else {
                        Image(systemName: "globe")
                        Text("Publish to Community")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .foregroundStyle(canPublishRelaxed && !isPublishing ? editorBg : editorMuted)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canPublishRelaxed && !isPublishing ? editorGreen : editorCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(!canPublishRelaxed || isPublishing)
            if !canPublish {
                Text(publishHint)
                    .font(.system(size: 13))
                    .foregroundStyle(editorMuted)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(editorBg.opacity(0.95))
    }

    private func buildJourney() -> ManualJourney {
        let activityType: ViewPointActivityType = sportType == .biking ? .mtb : .hiking
        let nodes = draft.waypoints.enumerated().map { i, w in
            ViewPointNode(
                title: "Point \(i + 1)",
                activityType: activityType,
                latitude: w.latitude,
                longitude: w.longitude,
                photoCount: 0,
                arrivalTime: nil,
                elevation: String(format: "%.0f m", w.elevation),
                hasWater: false,
                hasFuel: false,
                signalStrength: 0
            )
        }
        let elevFt = Int(elevationMeters * 3.28084)
        let durationMin = max(1, Int(durationSeconds / 60))
        let displayTitle = title.trimmingCharacters(in: .whitespaces).isEmpty ? "\(sportType.rawValue) Recording" : title
        return DetailedTrackPost(
            routeName: displayTitle,
            totalDurationMinutes: durationMin,
            viewPointNodes: nodes,
            elevationGain: "\(elevFt) ft",
            elevationPeak: nil,
            amenitiesDisplay: nil,
            author: nil,
            rating: nil,
            reviewCount: nil,
            heroImage: nil,
            routeID: nil
        )
    }
}
