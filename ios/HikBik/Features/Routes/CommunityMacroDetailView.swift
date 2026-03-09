// MARK: - Community Macro Detail — 社區版宏觀詳情模板，與 Official 完全隔離
// 數據：僅接收 CommunityJourney（或由 MacroJourneyPost 轉成）。欄位為空則對應區塊自動隱藏。
// 結構：Header（作者+關注+標題）→ Tag Cloud → Map（點對點+數字標註）→ Timeline（每日照片/筆記/Amenities/住宿）→ SocialInteractionBar

import SwiftUI
import MapKit
import UIKit

// MARK: - 主題（專業戶外深色 + 橘色強調）
private let bg = Color(hex: "0B121F")
private let card = Color(hex: "1A2332")
private let surface = Color(hex: "2A3540")
private let accent = Color(hex: "FF8C42")
private let textPrimary = Color.white
private let textMuted = Color(hex: "9CA3AF")
private let borderMuted = Color(hex: "374151")
private let mapLineColor = Color(hex: "FF8C42")
private let mapHeight: CGFloat = 220
private let pad: CGFloat = 20
private let heroCardHeight: CGFloat = 350
private let heroHorizontalPadding: CGFloat = 16
private let heroTextPadding: CGFloat = 20

/// 用於 Hero 視差：追蹤卡片在 ScrollView 中的 Y 偏移
private struct HeroScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

/// 單條評論（模擬發送用）
struct CommunityComment: Identifiable {
    let id = UUID()
    let authorName: String
    let text: String
    let date: Date
}

struct CommunityMacroDetailView: View {
    /// 僅接收一份行程數據（CommunityJourney 或經 CommunityJourney.from(MacroJourneyPost) 轉換）。
    let journey: CommunityJourney
    /// 行程 ID，用於打卡與「Been There」標記；從列表點擊傳入 item.id。
    var journeyId: String?
    @EnvironmentObject private var currentUser: CurrentUser
    @State private var isLiked: Bool
    @State private var isFavorited: Bool
    @State private var likeCount: Int
    @State private var isFollowing: Bool = false
    /// 緩存：真實道路路徑（N-1 段，每段 MKRoute.polyline），避免每次打開都重新請求。
    @State private var roadRouteSegments: [[CLLocationCoordinate2D]] = []
    @State private var isLoadingRoadRoutes = false
    /// 地圖視野：有道路段時為「所有 polyline 的 Union Bounding Box」，否則為 day 點範圍。
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    /// 評論區：半屏 sheet + 列表 + 輸入框
    @State private var comments: [CommunityComment] = []
    @State private var showCommentSheet = false
    @State private var commentDraft = ""
    /// 打卡：記錄到 Completed Journeys
    @State private var hasCheckedIn: Bool = false
    /// Hero 視差：卡片相對於 ScrollView 的 minY
    @State private var heroScrollOffset: CGFloat = 0
    /// 原生分享表單
    @State private var showShareSheet = false

    init(journey: CommunityJourney, journeyId: String? = nil) {
        self.journey = journey
        self.journeyId = journeyId
        _isLiked = State(initialValue: journey.isLiked)
        _isFavorited = State(initialValue: journey.isFavorited)
        _likeCount = State(initialValue: journey.likeCount)
    }

    private var effectivePostId: String { journeyId ?? "\(journey.author?.id ?? "guest")_\(journey.journeyName)" }
    private var effectiveJourneyId: String { journeyId ?? effectivePostId }

    private var routeCoordinates: [CLLocationCoordinate2D] {
        journey.days.compactMap { day -> CLLocationCoordinate2D? in
            guard let loc = day.location else { return nil }
            return CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        }
    }

    /// 封面圖 URL：優先使用模型內預處理過的 coverImageURL，否則首日 photoURL，最後 fallback
    private var coverImageURL: String {
        journey.coverImageURL
            ?? journey.days.first?.photoURL
            ?? "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=1200"
    }

    /// 封面比例，模型明確記錄 16/10 時使用，否則預設 16:10
    private var heroAspectRatio: CGFloat {
        guard let r = journey.aspectRatio, r > 0 else { return 16/10 }
        return CGFloat(r)
    }

    /// 仿官方評分展示（無真實評分時用 likeCount 推估）
    private var displayRating: String { "4.7 (\(max(likeCount, 1)))" }

    /// 分享內容：標題 + 描述 + 行程 ID / App 連結，供 UIActivityViewController 使用（微信 / WhatsApp / LINE / Message 等）
    private var shareActivityItems: [Any] {
        let location = journey.selectedStates.isEmpty ? "amazing spots" : journey.selectedStates.joined(separator: ", ")
        let title = "Join my Grand Journey: \(journey.journeyName)"
        let subtitle = "Check out this awesome route through \(location)!"
        let body = "\(title)\n\n\(subtitle)\n\nTrip ID: \(effectiveJourneyId)\n— Shared from HikBik"
        return [body]
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                heroCard
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: HeroScrollOffsetKey.self,
                                value: geo.frame(in: .named("scroll")).minY
                            )
                        }
                    )
                descriptionSection
                mapSection
                timelineSection
                inlineCheckInSection
                Spacer(minLength: 80)
            }
            .frame(maxWidth: CGFloat.infinity)
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(HeroScrollOffsetKey.self) { heroScrollOffset = $0 }
        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
        .background(bg)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            socialInteractionBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismissAction() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isFavorited.toggle()
                } label: {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            mapCameraPosition = .region(regionForCoordinates(routeCoordinates))
            fetchRoadRoutesIfNeeded()
            isLiked = currentUser.isLiked(postId: effectivePostId)
            hasCheckedIn = currentUser.hasCompleted(journeyId: effectiveJourneyId)
        }
        .sheet(isPresented: $showCommentSheet) {
            commentSheet
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: shareActivityItems)
        }
    }

    @Environment(\.dismiss) private var dismiss
    private func dismissAction() { dismiss() }

    // MARK: - Hero Card：頂部懸浮面板，容器 .padding(.horizontal, 16)，圖片自適應 + overlay 固定定位
    private var heroCard: some View {
        let author = journey.author.map { CommunityAuthor(id: $0.id, displayName: $0.displayName, avatarURL: $0.avatarURL) }
        let parallaxScale = heroScrollOffset > 0 ? 1 + (heroScrollOffset / heroCardHeight) * 0.15 : 1.0

        return VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                // 背景：封面圖（固定高度、寬度自適應容器），支持視差
                coverImageForHero
                    .scaleEffect(parallaxScale)
                    .frame(height: heroCardHeight)
                    .frame(maxWidth: CGFloat.infinity)
                    .clipped()
                    .overlay(alignment: .bottomLeading) {
                        // 底部漸變：純黑 → 透明，高度佔卡片 1/2
                        VStack(spacing: 0) {
                            Spacer()
                            LinearGradient(
                                colors: [.black, .black.opacity(0.6), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: heroCardHeight / 2)
                        }
                        .frame(maxWidth: CGFloat.infinity, maxHeight: heroCardHeight)
                        .allowsHitTesting(false)
                    }
                    .overlay(alignment: .bottomLeading) {
                        // 文字 Overlay：標籤、標題、作者，統一內邊距，不貼邊
                        VStack(alignment: .leading, spacing: 10) {
                            heroPillTags
                            Text(journey.journeyName)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            if let a = author {
                                NavigationLink(destination: UserProfileView(user: a, subtitle: nil)) {
                                    HStack(alignment: .center, spacing: 8) {
                                        smallAvatarView(url: a.avatarURL)
                                        Text("@" + a.displayName.replacingOccurrences(of: " ", with: "_").lowercased())
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.95))
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color(hex: "FBBF24"))
                                        Text(displayRating)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white.opacity(0.9))
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                HStack(alignment: .center, spacing: 8) {
                                    smallAvatarView(url: nil)
                                    Text("@community")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.95))
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color(hex: "FBBF24"))
                                    Text(displayRating)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], heroTextPadding)
                    }

                // 左上：圓形毛玻璃 Back（在 overlay 之上）
                Button { dismissAction() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .padding(.leading, heroHorizontalPadding)
                .padding(.top, 12)
            }
            .frame(height: heroCardHeight)
            .frame(maxWidth: CGFloat.infinity)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32,
                topTrailingRadius: 0
            ))
        }
        .padding(.horizontal, heroHorizontalPadding)
    }

    /// 鐵金剛渲染：上傳即 16:10 優化，渲染即完美。success → scaledToFill + clipped；failure → DefaultCoverView；empty → ShimmerPlaceholder
    private var coverImageForHero: some View {
        let url = URL(string: coverImageURL)
        return Group {
            if let u = url {
                AsyncImage(url: u) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    case .failure:
                        DefaultCoverView()
                    case .empty:
                        ShimmerPlaceholder()
                    @unknown default:
                        EmptyView()
                    }
                }
                .aspectRatio(16.0 / 10.0, contentMode: .fit)
            } else {
                DefaultCoverView()
                    .aspectRatio(16.0 / 10.0, contentMode: .fit)
            }
        }
    }

    private var heroPillTags: some View {
        let tags: [String] = {
            var t = journey.selectedStates
            if let d = journey.duration, !d.isEmpty { t.append(d) }
            if let v = journey.vehicle, !v.isEmpty { t.append(v) }
            if let p = journey.pace, !p.isEmpty { t.append(p) }
            return t
        }()
        return Group {
            if !tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(tags.prefix(5), id: \.self) { tag in
                        Text(tag.uppercased())
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            }
        }
    }

    private func smallAvatarView(url: String?) -> some View {
        Group {
            if let urlString = url, let u = URL(string: urlString) {
                AsyncImage(url: u) { phase in
                    if let img = phase.image { img.resizable().scaledToFill() }
                    else { Image(systemName: "person.circle.fill").font(.system(size: 20)).foregroundStyle(.white.opacity(0.7)) }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .frame(width: 24, height: 24)
        .clipShape(Circle())
    }

    private func avatarView(url: String?) -> some View {
        Group {
            if let urlString = url, let u = URL(string: urlString) {
                AsyncImage(url: u) { phase in
                    if let img = phase.image { img.resizable().scaledToFill() }
                    else { Image(systemName: "person.circle.fill").font(.system(size: 48)).foregroundStyle(textMuted) }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(textMuted)
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    /// 行程描述（首日筆記或佔位），緊接 Hero 下方
    private var descriptionSection: some View {
        let desc = journey.days.first?.notes ?? "A curated journey through iconic stops."
        return Text(desc)
            .font(.system(size: 15))
            .foregroundStyle(.white.opacity(0.9))
            .lineLimit(5)
            .padding(.horizontal, pad)
            .padding(.top, 24)
    }

    // MARK: - Tag Cloud：Pill 膠囊 + .ultraThinMaterial，白字，與官方「User Shared」一致
    private var tagCloudSection: some View {
        let tags: [String] = {
            var t: [String] = ["User Shared"]
            t.append(contentsOf: journey.selectedStates)
            if let d = journey.duration, !d.isEmpty { t.append(d) }
            if let v = journey.vehicle, !v.isEmpty { t.append(v) }
            if let p = journey.pace, !p.isEmpty { t.append(p) }
            return t
        }()
        return Group {
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.uppercased())
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                    }
                    .padding(.horizontal, pad)
                }
                .padding(.top, 16)
            }
        }
    }

    // MARK: - Map Section：半透明 + .ultraThinMaterial，白字高對比
    private var mapSection: some View {
        Group {
            if routeCoordinates.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.black.opacity(0.3))
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    Text("No route points")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
            } else {
                ZStack {
                    Map(position: $mapCameraPosition, interactionModes: .all) {
                        if !roadRouteSegments.isEmpty {
                            let roadStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                            ForEach(Array(roadRouteSegments.enumerated()), id: \.offset) { _, segmentCoords in
                                MapPolyline(coordinates: segmentCoords)
                                    .stroke(.black.opacity(0.35), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                                MapPolyline(coordinates: segmentCoords)
                                    .stroke(mapLineColor, style: roadStyle)
                            }
                        } else {
                            MapPolyline(coordinates: routeCoordinates)
                                .stroke(.black.opacity(0.3), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            MapPolyline(coordinates: routeCoordinates)
                                .stroke(mapLineColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        }
                        ForEach(Array(routeCoordinates.enumerated()), id: \.offset) { index, coord in
                            Annotation("", coordinate: coord) {
                                ZStack {
                                    Circle()
                                        .fill(accent)
                                        .frame(width: 28, height: 28)
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .mapStyle(.standard(elevation: .flat))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.black.opacity(0.3))
                            .allowsHitTesting(false)
                    }
                    .overlay {
                        if isLoadingRoadRoutes {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(ProgressView().tint(.white))
                        }
                    }
                }
            }
        }
        .frame(height: mapHeight)
        .frame(maxWidth: CGFloat.infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.white.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, pad)
        .padding(.top, 20)
    }

    /// 遍歷相鄰地點，MKDirections.Request(transportType: .automobile)，提取 MKRoute.polyline 並緩存。
    private func fetchRoadRoutesIfNeeded() {
        let coords = routeCoordinates
        guard coords.count >= 2, roadRouteSegments.isEmpty else { return }
        isLoadingRoadRoutes = true
        let count = coords.count - 1
        var segments: [[CLLocationCoordinate2D]?] = Array(repeating: nil, count: count)
        let lock = NSLock()
        let group = DispatchGroup()
        for i in 0..<count {
            group.enter()
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coords[i]))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coords[i + 1]))
            request.transportType = .automobile
            request.requestsAlternateRoutes = false
            MKDirections(request: request).calculate { response, _ in
                defer { group.leave() }
                guard let route = response?.routes.first else { return }
                let pts = route.polyline.points()
                var segmentCoords: [CLLocationCoordinate2D] = []
                for j in 0..<route.polyline.pointCount {
                    segmentCoords.append(pts[j].coordinate)
                }
                lock.lock()
                segments[i] = segmentCoords
                lock.unlock()
            }
        }
        group.notify(queue: .main) {
            roadRouteSegments = segments.compactMap { $0 }
            isLoadingRoadRoutes = false
            if !roadRouteSegments.isEmpty {
                let allPolylineCoords = roadRouteSegments.flatMap { $0 }
                mapCameraPosition = .region(regionForCoordinates(allPolylineCoords))
            }
        }
    }

    private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39, longitude: -98), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
        }
        let lats = coords.map(\.latitude), lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.08),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.08)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    // MARK: - Timeline Section：半透明 + .ultraThinMaterial，白字；Amenity 圖標白
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Itinerary")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, pad)
                .padding(.top, 28)
            ForEach(Array(journey.days.enumerated()), id: \.offset) { index, day in
                dayBlock(day: day, index: index)
            }
        }
        .padding(.bottom, 24)
    }

    private func dayBlock(day: CommunityJourneyDay, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                Text("Day \(day.dayNumber)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(accent)
                    .frame(width: 48, alignment: .center)
                Text(day.locationName ?? "Stop \(day.dayNumber)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, pad)

            if let urlString = day.photoURL, let url = URL(string: urlString), !urlString.isEmpty {
                AsyncImage(url: url) { phase in
                    if let img = phase.image {
                        img.resizable().scaledToFill()
                            .frame(height: 180)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black.opacity(0.3))
                            .frame(height: 120)
                            .overlay(ProgressView().tint(.white))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, pad)
            }

            if let notes = day.notes, !notes.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(notes)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(5...10)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.black.opacity(0.3))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal, pad)
            }

            if day.hasAnyAmenity {
                HStack(spacing: 12) {
                    if day.hasWater == true {
                        amenityCapsule(icon: "drop.fill", label: "Water")
                    }
                    if day.hasFuel == true {
                        amenityCapsule(icon: "fuelpump.fill", label: "Fuel")
                    }
                    if let sig = day.signalStrength, sig > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                            Text("Cell \(sig)/5")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                }
                .padding(.horizontal, pad)
            }

            if let stay = day.recommendedStay, !stay.trimmingCharacters(in: .whitespaces).isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(accent)
                    Text(stay)
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black.opacity(0.3))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, pad)
            }
        }
        .padding(.vertical, 16)
        .background(.black.opacity(0.3))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.white.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, pad)
    }

    private func amenityCapsule(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(label)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }

    // MARK: - 社交導航欄固定：.safeAreaInset(edge: .bottom)，位於 Main Tab Bar 正上方，.ultraThinMaterial 懸浮感
    private var socialInteractionBar: some View {
        HStack(spacing: 0) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                currentUser.toggleLike(postId: effectivePostId)
                isLiked.toggle()
                likeCount += isLiked ? 1 : -1
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                    Text("\(likeCount)")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(isLiked ? accent : textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                showCommentSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 20))
                    Text("\(journey.commentCount + comments.count)")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                isFavorited.toggle()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                    Text("Save")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(isFavorited ? accent : textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showShareSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                    Text("Share")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, pad)
        .background(.ultraThinMaterial)
    }

    // MARK: - 內聯 Check-in：放在 ScrollView 末尾、Itinerary 下方，上下約 40pt 儀式感
    private var inlineCheckInSection: some View {
        Button {
                if !hasCheckedIn {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentUser.checkIn(journeyId: effectiveJourneyId)
                    hasCheckedIn = true
                }
            } label: {
                HStack(spacing: 8) {
                    if hasCheckedIn {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                        Text("You've Checked in")
                            .font(.system(size: 17, weight: .semibold))
                    } else {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 22))
                        Text("I'm Here / Check-in")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: CGFloat.infinity)
                .frame(height: 56)
                .background(
                    Group {
                        if hasCheckedIn {
                            Color(hex: "16A34A")
                        } else {
                            LinearGradient(
                                colors: [accent, Color(hex: "E67A2E")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
            .disabled(hasCheckedIn)
            .padding(.horizontal, pad)
            .padding(.vertical, 40)
    }

    // MARK: - 評論半屏：列表 + 輸入框 + 發送（模擬 append 當前用戶名與時間）
    private var commentSheet: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(comments) { c in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(c.authorName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(textPrimary)
                            Text(c.text)
                                .font(.system(size: 15))
                                .foregroundStyle(textMuted)
                            Text(c.date, style: .time)
                                .font(.system(size: 11))
                                .foregroundStyle(textMuted.opacity(0.8))
                        }
                        .listRowBackground(card)
                    }
                }
                .listStyle(.plain)
                Divider().background(borderMuted)
                HStack(spacing: 12) {
                    TextField("Add a comment…", text: $commentDraft, axis: .vertical)
                        .textFieldStyle(.plain)
                        .lineLimit(1...4)
                        .padding(10)
                        .background(surface)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button {
                        let text = commentDraft.trimmingCharacters(in: .whitespaces)
                        guard !text.isEmpty else { return }
                        comments.append(CommunityComment(authorName: currentUser.displayName, text: text, date: Date()))
                        commentDraft = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(accent)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, pad)
                .padding(.vertical, 10)
                .background(bg)
            }
            .background(bg)
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - 默認 Grand Journey 封面（failure 或無 URL 時）
private struct DefaultCoverView: View {
    private let bg = Color(hex: "2A3540")
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(bg)
            Image(systemName: "photo.mountain.2.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color(hex: "4B5563"))
        }
    }
}

// MARK: - 載入中 Shimmer 骨架屏
private struct ShimmerPlaceholder: View {
    private let bg = Color(hex: "2A3540")
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(bg)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.08), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(RoundedRectangle(cornerRadius: 20))
            )
    }
}

// MARK: - 原生分享表單（UIActivityViewController），自動顯示微信 / WhatsApp / LINE / Message 等已安裝 App
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - 從 MacroJourneyPost 進入（單一參數）
extension CommunityMacroDetailView {
    init(macroPost: MacroJourneyPost, author: CommunityAuthor? = nil, likeCount: Int = 0, commentCount: Int = 0) {
        self.init(journey: .from(macroPost, author: author, likeCount: likeCount, commentCount: commentCount))
    }
}

#Preview("Community Macro Detail — Ultimate Utah Mighty 5") {
    NavigationStack {
        CommunityMacroDetailView(journey: CommunityJourney(
            journeyName: "Ultimate Utah Mighty 5 Loop",
            days: [
                CommunityJourneyDay(
                    dayNumber: 1,
                    location: CommunityGeoLocation(latitude: 38.7331, longitude: -109.5925),
                    locationName: "Arches National Park",
                    notes: "第一天從 Moab 出發。Delicate Arch 的落日絕對不能錯過，但記得帶頭燈，回程天黑很快。",
                    photoURL: "https://images.unsplash.com/photo-1504192010706-96946577af45",
                    recommendedStay: "Under Canvas Moab",
                    hasWater: true,
                    hasFuel: false,
                    signalStrength: 4
                ),
                CommunityJourneyDay(
                    dayNumber: 2,
                    location: CommunityGeoLocation(latitude: 38.4367, longitude: -109.8108),
                    locationName: "Canyonlands (Island in the Sky)",
                    notes: "壯闊的峽谷景觀。Shafer Trail 非常考驗駕駛技術，建議低速檔前進。",
                    photoURL: "https://images.unsplash.com/photo-1516939884455-1445c8652f83",
                    recommendedStay: "Willow Flat Campground",
                    hasWater: false,
                    hasFuel: false,
                    signalStrength: 1
                ),
                CommunityJourneyDay(
                    dayNumber: 3,
                    location: CommunityGeoLocation(latitude: 38.3670, longitude: -111.2615),
                    locationName: "Capitol Reef National Park",
                    notes: "穿過 UT-24 公路，風景像是在火星。這裡的派 (Pie) 很有名，一定要去 Gifford House 買一個！",
                    recommendedStay: "Capitol Reef Resort (Wagons)",
                    hasWater: true,
                    hasFuel: true,
                    signalStrength: 3
                )
            ],
            selectedStates: ["Utah"],
            duration: "7 Days",
            vehicle: "High Clearance 4WD",
            pace: "Moderate",
            author: CommunityAuthor(id: "alex", displayName: "Alex Explorer", avatarURL: "https://example.com/avatar.jpg"),
            likeCount: 1240,
            commentCount: 85
        ))
    }
}
