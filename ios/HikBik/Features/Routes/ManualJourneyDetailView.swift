// Manual Journey Detail – 沉浸式全屏模版（Layer 0 全屏地圖 + Layer 1 懸浮控制 + Layer 2 可滑動抽屜）
import SwiftUI
import MapKit

/// 表單輸出的行程數據，對應 DetailedTrackPost（route_meta / path_data / itinerary）
typealias ManualJourney = DetailedTrackPost

// MARK: - 六大行政區主題與差異化邏輯（land_management）
enum LandManagementTheme {
    case nationalPark
    case nationalForest
    case nationalGrassland
    case stateForest
    case statePark
    case nationalRecreationArea

    var accentColor: Color {
        switch self {
        case .nationalPark: return Color(hex: "2D5A27")
        case .nationalForest: return Color(hex: "4A6741")
        case .nationalGrassland: return Color(hex: "C2B280")
        case .stateForest: return Color(hex: "556B2F")
        case .statePark: return Color(hex: "8B4513")
        case .nationalRecreationArea: return Color(hex: "0077BE")
        }
    }

    /// NRA 使用藍色漸變發光按鈕
    var useGradientButton: Bool {
        if case .nationalRecreationArea = self { return true }
        return false
    }

    /// 草原區縮小海拔、突出風/天氣
    var isElevationCompact: Bool {
        if case .nationalGrassland = self { return true }
        return false
    }

    /// 草原區 Sheet 微弱金黃反光
    var backgroundTint: Color? {
        if case .nationalGrassland = self { return Color(hex: "C2B280").opacity(0.06) }
        return nil
    }

    static func from(_ category: DetailedTrackCategory?) -> LandManagementTheme {
        guard let cat = category else { return .nationalPark }
        switch cat {
        case .nationalPark: return .nationalPark
        case .nationalForest: return .nationalForest
        case .nationalGrassland: return .nationalGrassland
        case .stateForest: return .stateForest
        case .statePark: return .statePark
        case .nationalRecreationArea: return .nationalRecreationArea
        }
    }
}

// MARK: - Manual Journey Detail View（僅 UI 渲染，邏輯在 RouteDetailViewModel）
struct ManualJourneyDetailView: View {
    @StateObject private var viewModel: RouteDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var currentUser: CurrentUser

    @State private var toastMessage: String? = nil
    @State private var showReviewsSheet = false
    @State private var showNavigationView = false
    @State private var showCommentsSheet = false
    @State private var showRouteShareSheet = false

    /// 與 Profile Saved/Liked 同步的 Track ID（track_routeID）
    private var trackId: String { "track_\(viewModel.effectiveRouteID)" }
    private var isLiked: Bool { currentUser.isLiked(postId: trackId) }
    private var isSaved: Bool { currentUser.isSaved(postId: trackId) }
    /// 即時跳變：詳情頁點贊後 likeCount 立即 +1/-1，與 Community/Profile 同步（CurrentUser 已發送 .socialStatusChanged）
    private var likesCount: Int { (journey.reviewCount ?? 0) + (currentUser.isLiked(postId: trackId) ? 1 : 0) }
    private var commentsCount: Int { journey.reviewCount ?? 0 }

    init(journey: ManualJourney) {
        _viewModel = StateObject(wrappedValue: RouteDetailViewModel(journey: journey))
    }

    private var journey: ManualJourney { viewModel.journey }
    private var theme: LandManagementTheme { viewModel.theme }
    private var accentColor: Color { viewModel.accentColor }

    private var hasAnyWater: Bool { journey.viewPointNodes.contains(where: \.hasWater) }
    private var hasAnyFuel: Bool { journey.viewPointNodes.contains(where: \.hasFuel) }
    private var hasAnySignal: Bool { journey.viewPointNodes.contains(where: { $0.signalStrength > 0 }) }

    var body: some View {
        ZStack(alignment: .top) {
            fullScreenMapLayer
                .blur(radius: viewModel.isSheetFullyExpanded ? 1.2 : 0)
            if viewModel.isLoadingRoutes {
                // 僅在角落顯示 loading，不覆蓋全屏黑層
                VStack {
                    HStack { Spacer() }
                    Spacer()
                    ProgressView().tint(.white)
                        .padding(24)
                        .background(.ultraThinMaterial, in: Circle())
                    Spacer().frame(height: 120)
                }
                .allowsHitTesting(false)
            }
            floatingControlsLayer
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onChange(of: viewModel.sheetDetent) { _, _ in viewModel.onSheetDetentChange() }
        .onChange(of: viewModel.selectedViewPointIndex) { _, newIndex in
            viewModel.onSelectedViewPointChange(index: newIndex)
        }
        .fullScreenCover(isPresented: $showNavigationView) {
            RouteFollowingNavigationView(journey: journey, onDismiss: { showNavigationView = false })
        }
        .sheet(isPresented: $viewModel.showSheet) {
            interactiveSheetContent
                .presentationDetents([.fraction(0.4), .large], selection: $viewModel.sheetDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(32)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Layer 0: 全屏地圖
    private var fullScreenMapLayer: some View {
        Group {
            if viewModel.routeCoordinates.isEmpty {
                Map(position: .constant(.automatic), interactionModes: .all)
                    .mapStyle(.imagery(elevation: .realistic))
            } else {
                Map(position: $viewModel.mapPosition, interactionModes: .all) {
                    if !viewModel.routeSegments.isEmpty {
                        ForEach(Array(viewModel.routeSegments.enumerated()), id: \.offset) { _, segmentCoords in
                            MapPolyline(coordinates: segmentCoords)
                                .stroke(accentColor.opacity(0.42), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            MapPolyline(coordinates: segmentCoords)
                                .stroke(routeLineBright, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        }
                    } else {
                        MapPolyline(coordinates: viewModel.routeCoordinates)
                            .stroke(accentColor.opacity(0.42), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        MapPolyline(coordinates: viewModel.routeCoordinates)
                            .stroke(routeLineBright, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    }
                    ForEach(Array(viewModel.routeCoordinates.enumerated()), id: \.offset) { index, coord in
                        Annotation("", coordinate: coord) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 28, height: 28)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                Path { p in
                                    p.move(to: CGPoint(x: 14, y: 0))
                                    p.addLine(to: CGPoint(x: 14, y: 10))
                                }
                                .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 1.2, dash: [3, 3]))
                                .frame(width: 28, height: 10)
                            }
                        }
                    }
                }
                .mapStyle(.imagery(elevation: .realistic))
            }
        }
        .ignoresSafeArea(edges: .all)
    }

    /// 路徑主線更亮（在發光底層之上），深色地圖上對比更強
    private var routeLineBright: Color {
        accentColor.opacity(1.0)
    }

    // MARK: - Layer 1: 頂部懸浮按鈕（僅一組、安全區內、40x40 磨砂圓形）
    private var floatingControlsLayer: some View {
        VStack {
            HStack {
                backButton
                Spacer()
                HStack(spacing: 12) {
                    shareButton
                    favoriteButton
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            Spacer()
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }

    private var shareButton: some View {
        Button {
            AuthGuard.run(message: AuthGuardMessages.exportRoute) {
                showRouteShareSheet = true
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }

    private var favoriteButton: some View {
        Button {
            AuthGuard.run(message: AuthGuardMessages.likePost) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                currentUser.toggleLike(postId: trackId)
                viewModel.setFavoriteFromCurrentUser(currentUser.isLiked(postId: trackId))
            }
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 16))
                .foregroundStyle(isLiked ? accentColor : .white)
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Layer 2: 互動抽屜內容（封面圖 > 標題 > 社交/評分 > 天氣 > 操作按鈕）
    private var interactiveSheetContent: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 20) {
                    sheetHeroBlock
                    sheetTitleBlock
                    sheetSocialHeaderBlock
                    sheetInteractionBar
                    sheetSwipeHint
                    sheetStatsCapsule
                    sheetCategorySpecificBlock
                    WeatherOverviewView(
                        snapshot: viewModel.weatherSnapshot ?? .placeholder,
                        category: journey.category,
                        accentColor: accentColor
                    )
                    .padding(.vertical, 4)
                    sheetStartButton
                    sheetReviewsBlock
                    sheetAmenitiesBlock
                    sheetElevationAreaChart
                    sheetTimelineBlock
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                if let tint = theme.backgroundTint {
                    VStack { LinearGradient(colors: [tint, .clear], startPoint: .top, endPoint: .bottom).frame(height: 200); Spacer() }
                        .allowsHitTesting(false)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .overlay(toastOverlay)
        .sheet(isPresented: $showReviewsSheet) { sheetReviewsContent }
        .sheet(isPresented: $showCommentsSheet) { sheetCommentsContent }
        .sheet(isPresented: $showRouteShareSheet) {
            ShareSheet(activityItems: [viewModel.shareMessage])
        }
        }
    }

    /// Convert DetailedTrackAuthor to CommunityAuthor for UserProfileView (stable id from name)
    private func communityAuthor(from author: DetailedTrackAuthor) -> CommunityAuthor {
        let id = "dt_\(author.name.replacingOccurrences(of: " ", with: "_").filter { $0.isLetter || $0.isNumber || $0 == "_" }.lowercased().prefix(40))"
        return CommunityAuthor(id: String(id), displayName: author.name, avatarURL: author.avatarUrl)
    }

    @ViewBuilder
    private var toastOverlay: some View {
        if let message = toastMessage {
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .allowsHitTesting(false)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { toastMessage = nil }
                }
        }
    }

    /// 頂部封面圖：與 Grand Journey 一致，優先 PostMediaStore(trackId) 再 journey.heroImages/heroImage；多圖用 MediaCarouselView，單圖靜態；依 Sheet 檔位展開/淡出
    @ViewBuilder
    private var sheetHeroBlock: some View {
        let heroHeight: CGFloat = {
            switch viewModel.sheetDetent {
            case .large: return 200
            case .medium: return 100
            default: return 56
            }
        }()
        let heroOpacity: Double = viewModel.sheetDetent == .large ? 1 : (viewModel.sheetDetent == .medium ? 0.7 : 0.4)
        let heroScale: CGFloat = viewModel.sheetDetent == .large ? 1 : (viewModel.sheetDetent == .medium ? 0.98 : 0.96)
        let urls: [String] = {
            if let stored = PostMediaStore.shared.imageUrls(for: trackId), !stored.isEmpty { return stored }
            if let h = journey.heroImages, !h.isEmpty { return h }
            if let single = journey.heroImage, !single.isEmpty { return [single] }
            return []
        }()
        if !urls.isEmpty {
            MediaCarouselView(urls: urls, cornerRadius: 16, aspectRatio: 16/10, fixedHeight: heroHeight)
                .frame(height: heroHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(heroOpacity)
                .scaleEffect(heroScale)
                .animation(.easeInOut(duration: 0.3), value: viewModel.sheetDetent)
        }
    }

    private func heroAsyncImage(urlString: String) -> some View {
        Group {
            if let url = URL(string: urlString), !urlString.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Rectangle().fill(Color.white.opacity(0.08))
                    case .empty: Rectangle().fill(Color.white.opacity(0.06))
                    @unknown default: Rectangle().fill(Color.white.opacity(0.06))
                    }
                }
            } else {
                Rectangle().fill(Color.white.opacity(0.06))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    /// Author header: avatar + name; tap navigates to UserProfileView
    @ViewBuilder
    private var sheetSocialHeaderBlock: some View {
        let showAuthor = journey.author != nil
        let showRating = journey.rating != nil || (journey.reviewCount ?? 0) > 0
        if showAuthor || showRating {
            HStack(alignment: .center, spacing: 12) {
                if let author = journey.author, !author.name.isEmpty {
                    NavigationLink(destination: UserProfileView(user: communityAuthor(from: author), subtitle: nil)) {
                        HStack(spacing: 8) {
                            if let avatarUrl = author.avatarUrl, let url = URL(string: avatarUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                                    default: Circle().fill(Color.white.opacity(0.2))
                                    }
                                }
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                    .overlay(Image(systemName: "person.fill").font(.system(size: 12)).foregroundStyle(.secondary))
                            }
                            Text(author.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                            if author.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(accentColor)
                            }
                        }
                    }
                    .buttonStyle(AuthorHeaderButtonStyle())
                }
                if showRating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "F59E0B"))
                        if let r = journey.rating {
                            Text(String(format: "%.1f", r))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        if let c = journey.reviewCount, c > 0 {
                            Text("(\(c))")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { showReviewsSheet = true }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var sheetTitleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                Text(journey.routeName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                if journey.category == .nationalPark {
                    Text("Official Access")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accentColor)
                        .clipShape(Capsule())
                }
            }
            HStack(spacing: 8) {
                if let tier = journey.trackTier {
                    Text(tier == .nature ? "🌲 Nature" : "🏙️ Urban")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(tier == .nature ? Color(hex: "16A34A") : Color(hex: "2563EB"))
                        .clipShape(Capsule())
                }
                if let catDisplay = journey.displayCategory, !catDisplay.isEmpty {
                    Text(catDisplay)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(accentColor)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 六大分區專屬數據欄（Boat Ramp / Wind / Shuttle / Fire Risk / Gate Time）
    @ViewBuilder
    private var sheetCategorySpecificBlock: some View {
        switch journey.category {
        case .nationalRecreationArea:
            HStack(spacing: 12) {
                categoryChip(icon: "water.waves", label: "Boat Ramp")
                categoryChip(icon: "figure.pool.swim", label: "Swimming")
                categoryChip(icon: "dollarsign.circle", label: "Day Use Fee")
            }
        case .nationalGrassland:
            EmptyView()
        case .nationalPark:
            HStack(spacing: 8) {
                Image(systemName: "bus.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(accentColor)
                Text("Shuttle Service")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondary)
            }
        case .nationalForest, .stateForest:
            fireRiskGaugeView
        case .statePark:
            HStack(spacing: 8) {
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 14))
                    .foregroundStyle(accentColor)
                Text("Gate closing 6:00 PM")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondary)
            }
        case .none:
            EmptyView()
        }
    }

    private func categoryChip(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(accentColor)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.white.opacity(0.08)))
        .overlay(Capsule().strokeBorder(accentColor.opacity(0.3), lineWidth: 1))
    }

    /// 評論區：reviewCount == 0 時顯示 EmptyStateView，否則顯示條數與入口
    @ViewBuilder
    private var sheetReviewsBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reviews")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.secondary)
            let count = journey.reviewCount ?? 0
            if count == 0 {
                ReviewsEmptyStateView(accentColor: accentColor)
            } else {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "F59E0B"))
                    Text("\(journey.rating.map { String(format: "%.1f", $0) } ?? "—") · \(count) reviews")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Tap above to view")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(accentColor)
                }
                .padding(.vertical, 8)
            }
        }
    }

    /// 評論半屏：無評論時顯示 EmptyStateView，避免空白或報錯
    private var sheetReviewsContent: some View {
        NavigationStack {
            Group {
                if (journey.reviewCount ?? 0) == 0 {
                    ReviewsEmptyStateView(accentColor: accentColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("\(journey.reviewCount ?? 0) reviews")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showReviewsSheet = false }
                }
            }
        }
    }

    private var sheetCommentsContent: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("\(commentsCount) comments")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                Text("View and add comments — coming soon")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showCommentsSheet = false }
                }
            }
        }
    }

    private var fireRiskGaugeView: some View {
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 14))
                .foregroundStyle(accentColor)
            Text("Fire Risk")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.secondary)
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i == 0 ? accentColor : Color.white.opacity(0.2))
                        .frame(width: 20, height: 6)
                }
            }
            Text("Low")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
    }

    // MARK: - 交互工具欄（Like / Comment / Save，與 CurrentUser 雙向同步）
    private var sheetInteractionBar: some View {
        HStack(spacing: 0) {
            Button {
                AuthGuard.run(message: AuthGuardMessages.likePost) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentUser.toggleLike(postId: trackId)
                    viewModel.setFavoriteFromCurrentUser(currentUser.isLiked(postId: trackId))
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundStyle(isLiked ? accentColor : .white)
                    Text("\(likesCount)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showCommentsSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                    Text("\(commentsCount)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                AuthGuard.run(message: AuthGuardMessages.collectRoute) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    let wasSaved = isSaved
                    if wasSaved {
                        currentUser.toggleSave(postId: trackId)
                        SocialDataManager.shared.removeTrackJourney(id: trackId)
                        toastMessage = "Removed from Saved"
                    } else {
                        currentUser.toggleSave(postId: trackId)
                        if let data = try? JSONEncoder().encode(journey) {
                            SocialDataManager.shared.saveTrackJourney(id: trackId, journeyData: data)
                        }
                        toastMessage = "Saved to Profile"
                    }
                }
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18))
                    .foregroundStyle(isSaved ? accentColor : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    /// 收縮時提示（輔助文字 → .secondary）
    private var sheetSwipeHint: some View {
        HStack(spacing: 6) {
            Image(systemName: "chevron.up")
                .font(.system(size: 12, weight: .medium))
            Text("Swipe up for details")
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundStyle(Color.secondary)
    }

    /// 數據膠囊：Distance · Elevation Gain · View Points · Duration（Hiking 優化，無 SUV/2-3 Days）
    private var sheetStatsCapsule: some View {
        HStack(spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "point.topleft.down.to.point.bottomright.curvedpath")
                    .font(.system(size: 13))
                    .foregroundStyle(accentColor)
                Text(viewModel.totalDistanceFormatted)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            if let gain = journey.elevationGain, !gain.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(accentColor)
                    Text(gain)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(accentColor)
                Text("\(viewModel.viewPointCount) View Points")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.secondary)
                Text(durationDisplay)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Capsule().fill(Color.white.opacity(0.1)))
        .overlay(Capsule().strokeBorder(accentColor.opacity(0.35), lineWidth: 1))
    }

    private var sheetAmenitiesBlock: some View {
        let items = resolvedAmenityItems
        if items.isEmpty { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                Text("Survival & Amenities")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(items, id: \.label) { item in
                            amenityCard(icon: item.icon, label: item.label, color: item.color)
                        }
                    }
                }
            }
        )
    }

    /// 海拔圖：草原區縮小佔比，其餘正常高度
    private var sheetElevationAreaChart: some View {
        Group {
            if journey.elevationGain != nil || journey.elevationPeak != nil {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Elevation")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.secondary)
                    elevationAreaPath
                        .frame(height: theme.isElevationCompact ? 36 : 56)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    /// 模擬爬升曲線：Path + 漸變填充
    private var elevationAreaPath: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let points: [CGFloat] = (0..<24).map { i in
                let x = CGFloat(i) / 23
                let y = 0.2 + 0.6 * sin(x * .pi) + 0.1 * sin(x * .pi * 3)
                return y
            }
            Path { path in
                path.move(to: CGPoint(x: 0, y: h))
                for (i, p) in points.enumerated() {
                    let x = (CGFloat(i) / 23) * w
                    let y = h * (1 - p)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine(to: CGPoint(x: w, y: h))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [accentColor.opacity(0.55), accentColor.opacity(0.12)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            Path { path in
                path.move(to: CGPoint(x: 0, y: h * (1 - points[0])))
                for (i, p) in points.enumerated().dropFirst() {
                    let x = (CGFloat(i) / 23) * w
                    let y = h * (1 - p)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }

    private var sheetTimelineBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Itinerary")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.secondary)
                .padding(.bottom, 12)
            HStack(alignment: .top, spacing: 0) {
                sheetTimelineLine
                VStack(spacing: 0) {
                    ForEach(Array(journey.viewPointNodes.enumerated()), id: \.element.id) { index, node in
                        timelineRow(node: node, index: index, isLast: index == journey.viewPointNodes.count - 1)
                    }
                }
                .padding(.leading, 12)
            }
        }
    }

    /// 時間軸：垂直線白色 20% 透明度，節點為分區 accent 實心點
    private var sheetTimelineLine: some View {
        let count = journey.viewPointNodes.count
        return VStack(spacing: 0) {
            ForEach(0..<max(0, count), id: \.self) { i in
                Circle()
                    .fill(accentColor)
                    .frame(width: 10, height: 10)
                if i < count - 1 {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 2)
                        .frame(height: 52)
                }
            }
        }
        .padding(.top, 8)
    }

    /// Start Navigation button: enter real-time route-following mode
    private var sheetStartButton: some View {
        Button {
            AuthGuard.run(message: AuthGuardMessages.startNavigation) {
                showNavigationView = true
            }
        } label: {
            Text("Start Navigation")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Group {
                        if theme.useGradientButton {
                            LinearGradient(
                                colors: [Color(hex: "0077BE"), Color(hex: "005A9E")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.black
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(accentColor.opacity(0.45), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                .shadow(color: accentColor.opacity(0.4), radius: theme.useGradientButton ? 14 : 10, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }

    /// 優先顯示校準時長（首尾站時間差），無效時 fallback 至用戶輸入的 totalDurationMinutes
    private var durationDisplay: String {
        if let real = journey.calculatedRealDuration { return real }
        let m = journey.totalDurationMinutes
        if m < 60 { return "\(m)min" }
        let h = m / 60
        let r = m % 60
        return r > 0 ? "\(h)hr \(r)min" : "\(h)hr"
    }

    private struct AmenityItem { let icon: String; let label: String; let color: Color }

    private var resolvedAmenityItems: [AmenityItem] {
        if let display = journey.amenitiesDisplay, !display.isEmpty {
            return display.compactMap { label -> AmenityItem? in
                if label.lowercased().contains("water") { return AmenityItem(icon: "drop.fill", label: "Water", color: Color(hex: "3B82F6")) }
                if label.lowercased().contains("signal") || label.lowercased().contains("cell") { return AmenityItem(icon: "antenna.radiowaves.left.and.right", label: "Signal", color: ManualJourneyColors.textMuted) }
                if label.lowercased().contains("first aid") || label.lowercased().contains("aid") || label.lowercased().contains("hospital") { return AmenityItem(icon: "cross.case.fill", label: "First Aid", color: Color(hex: "EF4444")) }
                if label.lowercased().contains("fuel") { return AmenityItem(icon: "fuelpump.fill", label: "Fuel", color: Color(hex: "F59E0B")) }
                if label.lowercased().contains("fire") { return AmenityItem(icon: "flame.fill", label: "Fire", color: Color(hex: "F97316")) }
                if label.lowercased().contains("toilet") { return AmenityItem(icon: "toilet", label: "Toilet", color: ManualJourneyColors.textMuted) }
                return nil
            }
        }
        var list: [AmenityItem] = []
        if hasAnyWater { list.append(AmenityItem(icon: "drop.fill", label: "Water", color: Color(hex: "3B82F6"))) }
        if hasAnyFuel { list.append(AmenityItem(icon: "fuelpump.fill", label: "Fuel", color: Color(hex: "F59E0B"))) }
        if hasAnySignal { list.append(AmenityItem(icon: "antenna.radiowaves.left.and.right", label: "Signal", color: ManualJourneyColors.textMuted)) }
        return list
    }

    private func amenityCard(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(color.opacity(0.5), lineWidth: 1))
    }

    private func timelineRow(node: ViewPointNode, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if let time = node.arrivalTime, !time.isEmpty {
                Text(time)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.secondary)
                    .frame(width: 70, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(node.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Image(systemName: activityIcon(for: node.activityType))
                        .font(.system(size: 12))
                        .foregroundStyle(accentColor)
                    Text(node.activityType.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.secondary)
                }
                if let elev = node.elevation, !elev.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10))
                            .foregroundStyle(accentColor)
                        Text(elev)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.secondary)
                    }
                }
                if node.hasWater || node.hasFuel || node.signalStrength > 0 {
                    HStack(spacing: 8) {
                        if node.hasWater {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "3B82F6"))
                        }
                        if node.hasFuel {
                            Image(systemName: "fuelpump.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "F59E0B"))
                        }
                        if node.signalStrength > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(ManualJourneyColors.textMuted)
                                Text("\(node.signalStrength)/5")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
                if let urls = node.imageUrls, !urls.isEmpty {
                    viewPointPhotoBlock(urls: urls)
                } else if node.photoCount > 0 {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(ManualJourneyColors.textMuted.opacity(0.8))
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 52)
        .padding(.vertical, 4)
        .padding(.bottom, isLast ? 0 : 4)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectedViewPointIndex = index
        }
    }

    /// ViewPoint 專屬照片：從 imageUrls 加載，fill + 圓角 12
    private func viewPointPhotoBlock(urls: [String]) -> some View {
        Group {
            if urls.count == 1, let first = urls.first, let url = URL(string: first) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure, .empty: Rectangle().fill(Color.white.opacity(0.08))
                    @unknown default: Rectangle().fill(Color.white.opacity(0.08))
                    }
                }
                .frame(height: 120)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(urls.indices, id: \.self) { i in
                            if let u = URL(string: urls[i]) {
                                AsyncImage(url: u) { phase in
                                    switch phase {
                                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                                    case .failure, .empty: Rectangle().fill(Color.white.opacity(0.08))
                                    @unknown default: Rectangle().fill(Color.white.opacity(0.08))
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .frame(height: 120)
            }
        }
    }

    private func activityIcon(for activity: ViewPointActivityType) -> String {
        switch activity {
        case .hiking: return "figure.hiking"
        case .biking: return "bicycle"
        case .climbing: return "figure.climbing"
        case .summit: return "mountain.2.fill"
        case .mtb: return "bicycle"
        case .overlanding: return "car.fill"
        case .camping: return "tent.fill"
        case .paddling: return "water.waves"
        case .fishing: return "figure.fishing"
        case .boating: return "sailboat.fill"
        }
    }

}

// MARK: - 評論空狀態（reviewCount == 0 時顯示，不報錯不空白）
private struct ReviewsEmptyStateView: View {
    var accentColor: Color
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 36))
                .foregroundStyle(accentColor.opacity(0.8))
            Text("Be the first to leave a review")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.06)))
    }
}

// MARK: - Author header tap style: slight scale + opacity on press
private struct AuthorHeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Colors（深色主題，與全域模版一致）
private enum ManualJourneyColors {
    static let background = Color(hex: "0B121F")
    static let cardBg = Color(hex: "2A3540")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "9CA3AF")
}

// MARK: - Preview
#Preview("Angel's Landing - Zion") {
    NavigationStack {
        ManualJourneyDetailView(journey: ManualJourney(
            category: .nationalPark,
            routeName: "Angel's Landing Trail - Zion",
            totalDurationMinutes: 30,
            viewPointNodes: [
                ViewPointNode(title: "The Grotto Trailhead", activityType: .hiking, latitude: 37.2591, longitude: -112.9501, arrivalTime: "09:00 AM", hasWater: true, hasFuel: false, signalStrength: 3),
                ViewPointNode(title: "Walter's Wiggles", activityType: .climbing, latitude: 37.2635, longitude: -112.9472, arrivalTime: "10:15 AM", hasWater: false, hasFuel: false, signalStrength: 1),
                ViewPointNode(title: "Angel's Landing Summit", activityType: .summit, latitude: 37.2662, longitude: -112.9468, arrivalTime: "11:30 AM", hasWater: false, hasFuel: false, signalStrength: 0)
            ],
            elevationGain: "1,488 ft",
            elevationPeak: "5,790 ft",
            amenitiesDisplay: ["Water Refill", "Cell Signal", "First Aid"],
            author: DetailedTrackAuthor(name: "Jessica Martinez", avatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200", isVerified: true),
            rating: 4.9,
            reviewCount: 24,
            heroImage: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
            routeID: "zion-angels-landing-001"
        ))
    }
}
