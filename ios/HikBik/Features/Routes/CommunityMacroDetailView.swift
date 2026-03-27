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
/// 強制視圖寬度限制，禁止標題/頭像飛出屏幕。
private var screenWidth: CGFloat { UIScreen.main.bounds.width }
private let heroContentHorizontalPadding: CGFloat = 20
/// 地圖區域：標準卡片高度，禁止縮小。
private let mapHeight: CGFloat = 220
private let pad: CGFloat = 20
/// Hero 背景圖高度：屏幕 25%-30%，橫向 Banner 感，配合 .clipped() 中心裁切。
private var heroCardHeight: CGFloat {
    UIScreen.main.bounds.height * 0.28
}
private let heroHorizontalPadding: CGFloat = 16
private let heroTextPadding: CGFloat = 20
/// 標題區塊距卡片底部的額外間距，讓標題不貼照片邊緣（參考 Utah 範本）
private let heroTitleBottomPadding: CGFloat = 28

/// 用於 Hero 視差：追蹤卡片在 ScrollView 中的 Y 偏移
private struct HeroScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

/// 單條評論（含點讚，TikTok 風格）
struct CommunityComment: Identifiable {
    let id: UUID
    let authorName: String
    let text: String
    let date: Date
    var likeCount: Int
    var isLiked: Bool

    init(id: UUID = UUID(), authorName: String, text: String, date: Date, likeCount: Int = 0, isLiked: Bool = false) {
        self.id = id
        self.authorName = authorName
        self.text = text
        self.date = date
        self.likeCount = likeCount
        self.isLiked = isLiked
    }
}

/// 評論存儲：點讚切換與排序（Hot 優先，再按時間）
final class CommentStore: ObservableObject {
    @Published var comments: [CommunityComment] = []

    var sortedComments: [CommunityComment] {
        comments.sorted { c1, c2 in
            if c1.likeCount != c2.likeCount { return c1.likeCount > c2.likeCount }
            return c1.date > c2.date
        }
    }

    func addComment(authorName: String, text: String, date: Date = Date()) {
        comments.append(CommunityComment(authorName: authorName, text: text, date: date))
    }

    func toggleCommentLike(id: UUID) {
        guard let i = comments.firstIndex(where: { $0.id == id }) else { return }
        var c = comments[i]
        c.isLiked.toggle()
        c.likeCount += c.isLiked ? 1 : -1
        c.likeCount = max(0, c.likeCount)
        comments[i] = c
    }
}

/// 全局評論存儲：按 postId 存儲評論，卡片與詳情頁評論數 = comments.count，新增評論即時 +1
final class PostCommentStore: ObservableObject {
    static let shared = PostCommentStore()
    @Published private(set) var commentsByPostId: [String: [CommunityComment]] = [:]

    func comments(for postId: String) -> [CommunityComment] {
        commentsByPostId[postId] ?? []
    }

    func commentCount(for postId: String) -> Int {
        comments(for: postId).count
    }

    func addComment(postId: String, authorName: String, text: String, date: Date = Date()) {
        guard !postId.isEmpty else { return }
        var list = commentsByPostId[postId] ?? []
        list.append(CommunityComment(authorName: authorName, text: text, date: date))
        commentsByPostId[postId] = list
    }

    func sortedComments(for postId: String) -> [CommunityComment] {
        let list = comments(for: postId)
        return list.sorted { c1, c2 in
            if c1.likeCount != c2.likeCount { return c1.likeCount > c2.likeCount }
            return c1.date > c2.date
        }
    }

    func toggleCommentLike(postId: String, commentId: UUID) {
        guard var list = commentsByPostId[postId],
              let i = list.firstIndex(where: { $0.id == commentId }) else { return }
        var c = list[i]
        c.isLiked.toggle()
        c.likeCount += c.isLiked ? 1 : -1
        c.likeCount = max(0, c.likeCount)
        list[i] = c
        commentsByPostId[postId] = list
    }
}

struct CommunityMacroDetailView: View {
    /// 僅接收一份行程數據（CommunityJourney 或經 CommunityJourney.from(MacroJourneyPost) 轉換）。
    let journey: CommunityJourney
    /// 行程 ID，用於打卡與「Been There」標記；從列表點擊傳入 item.id。
    var journeyId: String?
    /// 用戶在 Builder 上傳的封面圖 Data；非 nil 時優先於 coverImageURL 顯示，避免錯誤的默認風景圖。
    var coverImageData: Data? = nil
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var socialManager: SocialManager
    @State private var isLiked: Bool
    @State private var isFavorited: Bool
    @State private var likeCount: Int
    /// 緩存：真實道路路徑（N-1 段，每段 MKRoute.polyline），避免每次打開都重新請求。
    @State private var roadRouteSegments: [[CLLocationCoordinate2D]] = []
    @State private var isLoadingRoadRoutes = false
    /// 地圖視野：有道路段時為「所有 polyline 的 Union Bounding Box」，否則為 day 點範圍。
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    /// 評論區：使用全局 PostCommentStore，評論數 = comments.count
    @EnvironmentObject private var postCommentStore: PostCommentStore
    @State private var showCommentSheet = false
    @State private var commentDraft = ""
    /// 打卡：記錄到 Completed Journeys
    @State private var hasCheckedIn: Bool = false
    /// Hero 視差：卡片相對於 ScrollView 的 minY
    @State private var heroScrollOffset: CGFloat = 0
    /// 原生分享表單
    @State private var showShareSheet = false
    /// 海報預覽彈窗（生成成功後先預覽，再決定是否打開系統分享）
    @State private var isShowingPreview = false
    /// Check-in 成功後顯示紙屑動畫
    @State private var showConfetti = false
    @State private var confettiStartTime = Date()
    /// 分享海報生成中（顯示 ProgressView）
    @State private var isGeneratingShareImage = false
    /// 已生成的海報圖，用於 ShareSheet
    @State private var generatedShareImage: UIImage?
    /// 媒體池更新時強制刷新 Hero 輪播（訂閱 .postMediaDidUpdate）
    @State private var mediaRefreshTrigger = UUID()

    init(journey: CommunityJourney, journeyId: String? = nil, coverImageData: Data? = nil) {
        self.journey = journey
        self.journeyId = journeyId
        self.coverImageData = coverImageData
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

    /// 分享內容：海報圖（若有）+ 推薦文字 + App 連結，供 UIActivityViewController 使用（微信 / WhatsApp / LINE / Instagram 等）
    private var shareActivityItems: [Any] {
        let location = journey.selectedStates.isEmpty ? "amazing spots" : journey.selectedStates.joined(separator: ", ")
        let title = "Join my Grand Journey: \(journey.journeyName)"
        let subtitle = "Check out this awesome route through \(location)!"
        let appLink = "https://apps.apple.com/app/hikbik" // 佔位，上線後替換為真實連結
        let body = "\(title)\n\n\(subtitle)\n\nTrip ID: \(effectiveJourneyId)\n\nDownload HikBik: \(appLink)\n— Shared from HikBik"
        var items: [Any] = [body]
        if let img = generatedShareImage {
            items.insert(img, at: 0)
        }
        return items
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                // 固定順序：標題/封面 -> 描述 -> 地圖 -> Itinerary（從任何入口進入一致）
                VStack(alignment: .leading, spacing: 20) {
                    heroCard(topSafeInset: geometry.safeAreaInsets.top)
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
                    Spacer(minLength: 40)
                }
                .frame(width: screenWidth)
                .padding(.bottom, 160)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(HeroScrollOffsetKey.self) { heroScrollOffset = $0 }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(bg)
            .ignoresSafeArea(.all, edges: .top)
            .scrollDismissesKeyboard(.immediately)
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                socialInteractionBar
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            mapCameraPosition = .region(regionForCoordinates(routeCoordinates))
            fetchRoadRoutesIfNeeded()
            isLiked = currentUser.isLiked(postId: effectivePostId)
            isFavorited = currentUser.isSaved(postId: effectivePostId)
            hasCheckedIn = currentUser.hasCompleted(journeyId: effectiveJourneyId)
            if let a = journey.author, socialManager.users[a.id] == nil {
                socialManager.ensureUser(id: a.id, username: a.displayName, initialFollowersCount: 0)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .postMediaDidUpdate)) { n in
            guard (n.userInfo?["id"] as? String) == effectivePostId else { return }
            mediaRefreshTrigger = UUID()
        }
        .sheet(isPresented: $showCommentSheet) {
            commentSheet
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: shareActivityItems)
        }
        .sheet(isPresented: $isShowingPreview) {
            SharePreviewSheet(
                image: generatedShareImage,
                onConfirmShare: {
                    isShowingPreview = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showShareSheet = true
                    }
                }
            )
        }
        .overlay {
            if isGeneratingShareImage {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    Text("Generating your poster...")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .overlay {
            if showConfetti {
                CheckInConfettiView(startTime: confettiStartTime)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }

    /// 後台載入封面圖 → 用 ImageRenderer 生成海報 → 先彈預覽，確認後再打開系統分享
    private func triggerSharePoster() {
        isGeneratingShareImage = true
        let startTime = Date()
        let journeyName = journey.journeyName
        let authorName = journey.author?.displayName ?? "Guest"
        let coverURLString = coverImageURL
        Task {
            let loadedImage = await loadImageFromURL(coverURLString)
            var resultImage: UIImage?
            await MainActor.run {
                let poster = SharePosterView(
                    coverImage: loadedImage,
                    title: journeyName,
                    authorUsername: authorName
                )
                let renderer = ImageRenderer(content: poster)
                renderer.scale = UIScreen.main.scale
                resultImage = renderer.uiImage
                if let img = resultImage {
                    print("海報生成成功：寬 \(img.size.width) 高 \(img.size.height)")
                } else {
                    print("海報生成失敗")
                }
            }
            let minDisplayDuration: TimeInterval = 0.8
            let elapsed = Date().timeIntervalSince(startTime)
            if elapsed < minDisplayDuration {
                try? await Task.sleep(nanoseconds: UInt64((minDisplayDuration - elapsed) * 1_000_000_000))
            }
            await MainActor.run {
                generatedShareImage = resultImage
                isGeneratingShareImage = false
                isShowingPreview = true
            }
        }
    }

    private func loadImageFromURL(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

    @Environment(\.dismiss) private var dismiss
    private func dismissAction() { dismiss() }

    // MARK: - Hero Card：頂部全屏沉浸（衝進 Safe Area），標題/標籤/作者壓底
    private func heroCard(topSafeInset: CGFloat = 0) -> some View {
        let author = journey.author.map { CommunityAuthor(id: $0.id, displayName: $0.displayName, avatarURL: $0.avatarURL) }
        let parallaxScale = heroScrollOffset > 0 ? 1 + (heroScrollOffset / heroCardHeight) * 0.15 : 1.0
        let totalHeroHeight = heroCardHeight + topSafeInset

        return VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                // 1. 背景圖 ZStack 最底層，衝進 Safe Area，禁止頂部黑邊（id 使媒體池更新時重繪）
                coverImageForHero
                    .id(mediaRefreshTrigger)
                    .scaleEffect(parallaxScale)
                    .frame(width: screenWidth, height: totalHeroHeight)
                    .clipped()
                    .ignoresSafeArea(.all, edges: .top)
                    .overlay(alignment: .bottomLeading) {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.5), .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .allowsHitTesting(false)
                    }
                    .overlay(alignment: .bottomLeading) {
                        // 2. 標題與標籤物理壓底：巨大 Spacer 推到 Hero 最底部（圖 1 雜誌級）
                        VStack(alignment: .leading, spacing: 8) {
                            Spacer()
                            heroPillTags
                                .frame(maxWidth: screenWidth - heroContentHorizontalPadding * 2, alignment: .leading)
                            Text(journey.journeyName)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: screenWidth - heroContentHorizontalPadding * 2, alignment: .leading)
                            if let a = author {
                                let isFollowing = socialManager.users[a.id]?.isFollowing ?? false
                                HStack(alignment: .center, spacing: 12) {
                                    NavigationLink(destination: UserProfileView(user: a, subtitle: nil)) {
                                        HStack(alignment: .center, spacing: 8) {
                                            smallAvatarView(url: a.avatarURL)
                                            Text("@" + a.displayName.replacingOccurrences(of: " ", with: "_").lowercased())
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundStyle(.white.opacity(0.95))
                                                .lineLimit(1)
                                                .fixedSize(horizontal: false, vertical: true)
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
                                    Spacer(minLength: 8)
                                    Button {
                                        AuthGuard.run(message: AuthGuardMessages.followUser) {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            socialManager.toggleFollow(for: a.id, currentUserId: socialManager.currentUserId)
                                        }
                                    } label: {
                                        Text(isFollowing ? "Following" : "Follow")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(isFollowing ? textMuted : .white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(isFollowing ? Color.white.opacity(0.2) : accent)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFollowing)
                                }
                                .frame(maxWidth: screenWidth - heroContentHorizontalPadding * 2)
                                .fixedSize(horizontal: false, vertical: true)
                            } else {
                                HStack(alignment: .center, spacing: 8) {
                                    smallAvatarView(url: nil)
                                    Text("@community")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.95))
                                        .fixedSize(horizontal: false, vertical: true)
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color(hex: "FBBF24"))
                                    Text(displayRating)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                .frame(maxWidth: screenWidth - heroContentHorizontalPadding * 2)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(width: screenWidth, alignment: .leading)
                        .padding(.horizontal, heroContentHorizontalPadding)
                        .padding(.bottom, heroTitleBottomPadding)
                    }

                // 返回鍵（左上，留出 Safe Area）
                VStack {
                    Button { dismissAction() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding(.leading, heroHorizontalPadding)
                .padding(.top, 16 + topSafeInset)
            }
            .frame(width: screenWidth, height: totalHeroHeight)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 32,
                bottomTrailingRadius: 32,
                topTrailingRadius: 0
            ))
        }
        .frame(width: screenWidth)
    }

    /// 輪播數據源：journey.imageUrls 或 PostMediaStore 同步的媒體池；無則用單圖 cover
    private var heroImageURLs: [String] {
        if let urls = journey.imageUrls, !urls.isEmpty { return urls }
        if let urls = PostMediaStore.shared.imageUrls(for: effectivePostId), !urls.isEmpty { return urls }
        return [coverImageURL]
    }

    /// 封面：多圖用 MediaCarouselView，單圖用原有邏輯；統一 .fill + .clipped()
    private var coverImageForHero: some View {
        Group {
            if heroImageURLs.count > 1 {
                MediaCarouselView(urls: heroImageURLs, cornerRadius: 0, fixedHeight: heroCardHeight + 20)
                    .frame(height: heroCardHeight + 20)
                    .clipped()
            } else if let data = coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if let first = heroImageURLs.first, let u = URL(string: first) {
                AsyncImage(url: u) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill).clipped()
                    case .failure: DefaultCoverView()
                    case .empty: ShimmerPlaceholder()
                    @unknown default: EmptyView()
                    }
                }
            } else {
                DefaultCoverView()
            }
        }
    }

    /// 首位標籤 = journey.state（JSON）；再拼 tags / 天數 / 載具（Utah 模板感）
    private var heroPillTags: some View {
        let tags: [String] = {
            var row: [String] = []
            let st = journey.state.trimmingCharacters(in: .whitespaces)
            if !st.isEmpty { row.append(st) }
            if let spec = journey.tags {
                for x in spec where !x.trimmingCharacters(in: .whitespaces).isEmpty && x != st && !row.contains(x) {
                    row.append(x)
                }
            }
            if row.count <= 1 {
                if let d = journey.duration, !d.isEmpty, !row.contains(d) { row.append(d) }
                if let v = journey.vehicle, !v.isEmpty, !row.contains(v) { row.append(v) }
                if let p = journey.pace, !p.isEmpty, !row.contains(p) { row.append(p) }
            }
            if row.isEmpty {
                row = journey.selectedStates
                if let d = journey.duration, !d.isEmpty { row.append(d) }
                if let v = journey.vehicle, !v.isEmpty { row.append(v) }
            }
            if row.isEmpty { row.append("Macro Journey") }
            return row
        }()
        return Group {
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.uppercased())
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    .padding(.horizontal, 2)
                }
                .frame(maxWidth: screenWidth - heroContentHorizontalPadding * 2, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
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

    /// 全線概覽：僅 `journey.overallDescription`（由 `MacroJourneyPost.overallDescription` 或 Feed `summary.description` 合併）；**禁止**使用 `days.first` 作為頂層簡介。
    @ViewBuilder
    private var descriptionSection: some View {
        let overview = journey.overallDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !overview.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Trip overview")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(textMuted)
                Text(overview)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, pad)
            .padding(.top, 24)
        }
    }

    // MARK: - Tag Cloud：Pill 膠囊 + .ultraThinMaterial，白字，與官方「User Shared」一致
    private var tagCloudSection: some View {
        let tags: [String] = {
            var t: [String] = ["User Shared"]
            let st = journey.state.trimmingCharacters(in: .whitespaces)
            if !st.isEmpty { t.append(st) }
            if let spec = journey.tags, !spec.isEmpty {
                for x in spec where !x.isEmpty && x != st && !t.contains(x) { t.append(x) }
            } else {
                for s in journey.selectedStates where s != st && !t.contains(s) { t.append(s) }
                if let d = journey.duration, !d.isEmpty, !t.contains(d) { t.append(d) }
                if let v = journey.vehicle, !v.isEmpty, !t.contains(v) { t.append(v) }
                if let p = journey.pace, !p.isEmpty, !t.contains(p) { t.append(p) }
                if let diff = journey.difficulty, !diff.isEmpty, !t.contains(diff) { t.append(diff) }
            }
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
                                .lineLimit(1)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial, in: Capsule())
                                .fixedSize(horizontal: true, vertical: false)
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
        .aspectRatio(16/9, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(.white.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, pad)
        .padding(.top, 24)
        .padding(.bottom, 20)
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

    // MARK: - Timeline Section：半透明 + .ultraThinMaterial，白字；Amenity 圖標白；days 為空時仍顯示區塊標題與佔位，保證從任何入口進入順序一致
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Itinerary")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, pad)
                .padding(.top, 28)
            if journey.days.isEmpty {
                Text("No itinerary data")
                    .font(.system(size: 15))
                    .foregroundStyle(textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, pad)
                    .padding(.vertical, 20)
                    .background(.black.opacity(0.2))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(Array(journey.days.enumerated()), id: \.offset) { index, day in
                    dayBlock(day: day, index: index)
                }
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
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, pad)

            // 每日照片牆：僅讀取當前 day 子集（days[index].images/dayPhotos），不讀頂層聚合圖集。
            dayPhotosRow(index: index)

            // 富文本介紹：規格 text → description → notes
            if let desc = day.text ?? day.description ?? day.notes, !desc.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(desc)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
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

            // 推薦卡片（含 link 時渲染為可點擊按鈕，如 Book on Airbnb）
            recommendationsRow(day: day)

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

    /// 當日照片牆：多圖用 MediaCarouselView 輪播，單圖靜態；無圖不顯示。支持 file:// 與 https。
    /// 嚴格限制數據源為 `journey.days[index]` 的子集字段（images/dayPhotos），不回退到頂層 `journey.imageUrls`。
    private func dayPhotosRow(index: Int) -> some View {
        guard index >= 0, index < journey.days.count else { return AnyView(EmptyView()) }
        let day = journey.days[index]
        let urls: [String] = {
            if let im = day.images, !im.isEmpty { return im }
            if let dp = day.dayPhotos, !dp.isEmpty { return dp }
            return []
        }()
        guard !urls.isEmpty else { return AnyView(EmptyView()) }
        let validUrls: [String] = urls.compactMap { s in
            guard !s.isEmpty else { return nil }
            if s.hasPrefix("/") { return URL(fileURLWithPath: s).absoluteString }
            return s
        }
        guard !validUrls.isEmpty else { return AnyView(EmptyView()) }
        return AnyView(
            MediaCarouselView(
                urls: validUrls,
                cornerRadius: 12,
                aspectRatio: 200/140,
                fixedHeight: 140
            )
            .padding(.horizontal, pad)
            .padding(.vertical, 4)
        )
    }

    /// 推薦卡片：airbnbLink 或 recommendations[].link
    private func recommendationsRow(day: CommunityJourneyDay) -> some View {
        let link = day.airbnbLink?.trimmingCharacters(in: .whitespaces) ?? ""
        let hasRecs = day.recommendations?.isEmpty == false
        if link.isEmpty && !hasRecs { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                if !link.isEmpty, let openURL = URL(string: link) {
                    Button { UIApplication.shared.open(openURL) } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "link")
                                .foregroundStyle(accent)
                            Text("Book on Airbnb")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundStyle(accent)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black.opacity(0.3))
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.2), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, pad)
                }
                if let recs = day.recommendations {
                ForEach(Array(recs.enumerated()), id: \.offset) { _, rec in
                    let title = (rec.title?.trimmingCharacters(in: .whitespaces)).flatMap { $0.isEmpty ? nil : $0 } ?? "Book on Airbnb"
                    let link = (rec.link?.trimmingCharacters(in: .whitespaces)).flatMap { $0.isEmpty ? nil : $0 }
                    if let link = link, let openURL = URL(string: link) {
                        Button {
                            UIApplication.shared.open(openURL)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "link")
                                    .font(.system(size: 16))
                                    .foregroundStyle(accent)
                                Text(title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(accent)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.black.opacity(0.3))
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.2), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, pad)
                    } else if !title.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(accent)
                            Text(title)
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
                }
            }
        )
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

    /// 工具欄物理隔離：置於 ScrollView 外、屏幕最下方，不透明背景禁止內容穿透，與 TabBar 分離。
    private var socialInteractionBar: some View {
        HStack(spacing: 0) {
            Button {
                AuthGuard.run(message: AuthGuardMessages.likePost) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentUser.toggleLike(postId: effectivePostId)
                    isLiked.toggle()
                    likeCount += isLiked ? 1 : -1
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .scaleEffect(isLiked ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
                    Text("\(likeCount)")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(isLiked ? Color.red : textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                showCommentSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 20))
                    Text("\(journey.commentCount + postCommentStore.commentCount(for: effectivePostId))")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                AuthGuard.run(message: AuthGuardMessages.collectRoute) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentUser.toggleSave(postId: effectivePostId)
                    isFavorited = currentUser.isSaved(postId: effectivePostId)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                    Text("Save")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(isFavorited ? Color.yellow : textMuted)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                triggerSharePoster()
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
            .disabled(isGeneratingShareImage)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, pad)
        .frame(maxWidth: .infinity)
        .background(bg)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.2))
                .frame(height: 1)
        }
    }

    // MARK: - 內聯 Check-in：放在 ScrollView 末尾、Itinerary 下方，儀式感（紙屑 + 彈簧 + ✓ Arrived）
    private var inlineCheckInSection: some View {
        Button {
            if !hasCheckedIn {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                currentUser.checkIn(journeyId: effectiveJourneyId)
                hasCheckedIn = true
                confettiStartTime = Date()
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showConfetti = false
                }
            }
        } label: {
            HStack(spacing: 8) {
                if hasCheckedIn {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                    Text("✓ Arrived")
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
            .scaleEffect(hasCheckedIn ? 1.02 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: hasCheckedIn)
        }
        .buttonStyle(.plain)
        .disabled(hasCheckedIn)
        .padding(.horizontal, pad)
        .padding(.vertical, 40)
    }

    // MARK: - 評論半屏（TikTok 風格）：頭像 + 用戶名/時間 + 內容 + 點讚，底部固定輸入框
    private var commentSheet: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(postCommentStore.sortedComments(for: effectivePostId)) { c in
                            CommentRowView(comment: c, accent: accent, onLike: {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                postCommentStore.toggleCommentLike(postId: effectivePostId, commentId: c.id)
                            })
                            .padding(.horizontal, pad)
                            .padding(.vertical, 12)
                        }
                    }
                    .padding(.bottom, 80)
                }
                .scrollContentBackground(.hidden)
                .background(.ultraThinMaterial)

                CommentInputBar(
                    draft: $commentDraft,
                    accent: accent,
                    textMuted: textMuted,
                    surface: surface,
                    onSubmit: {
                        let text = commentDraft.trimmingCharacters(in: .whitespaces)
                        guard !text.isEmpty else { return }
                        postCommentStore.addComment(postId: effectivePostId, authorName: currentUser.displayName, text: text, date: Date())
                        commentDraft = ""
                    }
                )
            }
            .background(bg.opacity(0.3))
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - 單條評論行（TikTok 風格：左頭像，右用戶名+時間+內容，右側愛心+數）
private struct CommentRowView: View {
    let comment: CommunityComment
    let accent: Color
    let onLike: () -> Void

    private var timeAgo: String {
        let s = Date().timeIntervalSince(comment.date)
        if s < 60 { return "now" }
        if s < 3600 { return "\(Int(s/60))m" }
        if s < 86400 { return "\(Int(s/3600))h" }
        return "\(Int(s/86400))d"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color(hex: "4B5563"))
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 6) {
                    Text(comment.authorName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.6))
                    Text(timeAgo)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.4))
                }
                Text(comment.text)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 4) {
                Button(action: onLike) {
                    Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 14))
                        .foregroundStyle(comment.isLiked ? Color(hex: "EF4444") : Color.white.opacity(0.5))
                        .scaleEffect(comment.isLiked ? 1.15 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: comment.isLiked)
                }
                .buttonStyle(.plain)
                Text("\(comment.likeCount)")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.white.opacity(0.5))
            }
            .frame(width: 36)
        }
    }
}

// MARK: - 底部固定輸入條（圓角背景，有字時發送按鈕橘色）
private struct CommentInputBar: View {
    @Binding var draft: String
    let accent: Color
    let textMuted: Color
    let surface: Color
    let onSubmit: () -> Void

    private var canSend: Bool { !draft.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        HStack(spacing: 12) {
            TextField("Add a comment…", text: $draft, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(surface)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Button(action: onSubmit) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? accent : textMuted.opacity(0.6))
            }
            .buttonStyle(.plain)
            .disabled(!canSend)
        }
        .padding(.horizontal, pad)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
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

// MARK: - 分享海報視圖（僅供 ImageRenderer 生成圖片，不顯示在 UI 中）
private struct SharePosterView: View {
    let coverImage: UIImage?
    let title: String
    let authorUsername: String

    private let posterWidth: CGFloat = 800
    private let posterHeight: CGFloat = 1000 // 4:5

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 背景：16:10 Hero 圖 scaledToFill
            Group {
                if let img = coverImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                } else {
                    LinearGradient(
                        colors: [Color(hex: "1A2332"), Color(hex: "0B121F")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .frame(width: posterWidth, height: posterHeight)
            .clipped()

            // 遮罩層：底部深色漸變，確保文字清晰
            LinearGradient(
                colors: [.clear, .black.opacity(0.3), .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: posterWidth, height: posterHeight)

            // 信息層：左下角標題 + @用戶名
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Text("@\(authorUsername.replacingOccurrences(of: " ", with: "_").lowercased())")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.leading, 24)
            .padding(.bottom, 80)

            // 品牌層：右下角 Grand Journey
            VStack(alignment: .trailing, spacing: 4) {
                Text("Grand Journey")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                Text("HikBik")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
        }
        .frame(width: posterWidth, height: posterHeight)
    }
}

// MARK: - Check-in 紙屑動畫（品牌色：橘、白、金），Canvas 粒子下落
private struct CheckInConfettiView: View {
    let startTime: Date
    private static let particleCount = 55
    private static let duration: Double = 2.5
    private static let colors: [Color] = [
        Color(hex: "FF8C42"),
        .white,
        Color(hex: "FBBF24")
    ]

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation(minimumInterval: 1/30)) { context in
                Canvas { ctx, size in
                    let t = context.date.timeIntervalSince(startTime)
                    let progress = min(1, t / CheckInConfettiView.duration)
                    for i in 0..<CheckInConfettiView.particleCount {
                        let seed = Double(i) * 0.137
                        let startX = (seed * 317).truncatingRemainder(dividingBy: Double(size.width))
                        let startY = -20 - (seed * 47).truncatingRemainder(dividingBy: 80)
                        let speed = 180 + (seed * 120).truncatingRemainder(dividingBy: 100)
                        let y = startY + t * speed
                        let opacity = 1.0 - progress
                        let colorIdx = Int((seed * 7).truncatingRemainder(dividingBy: 3))
                        let rect = CGRect(
                            x: startX - 4,
                            y: y - 4,
                            width: 8,
                            height: 8
                        )
                        ctx.fill(
                            Path(ellipseIn: rect),
                            with: .color(CheckInConfettiView.colors[colorIdx].opacity(opacity))
                        )
                    }
                }
            }
        }
    }
}

// MARK: - 海報預覽彈窗：顯示生成的海報圖 +「Confirm and Share」按鈕，確認後再打開系統分享
private struct SharePreviewSheet: View {
    let image: UIImage?
    let onConfirmShare: () -> Void

    private let accentOrange = Color(hex: "FF8C42")
    private let previewCorner: CGFloat = 16
    private let previewShadowRadius: CGFloat = 20

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(4/5, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: previewCorner))
                        .shadow(color: .black.opacity(0.35), radius: previewShadowRadius, x: 0, y: 8)
                        .padding(.horizontal, 24)
                } else {
                    RoundedRectangle(cornerRadius: previewCorner)
                        .fill(Color(hex: "1A2332"))
                        .aspectRatio(4/5, contentMode: .fit)
                        .overlay {
                            Text("Poster could not be generated")
                                .font(.system(size: 15))
                                .foregroundStyle(Color(hex: "9CA3AF"))
                        }
                        .padding(.horizontal, 24)
                }

                Button(action: onConfirmShare) {
                    Text("Confirm and Share")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(accentOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                .disabled(image == nil)
                .opacity(image == nil ? 0.6 : 1)
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "0B121F"))
            .navigationTitle("Share Poster")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
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
                    notes: "Day one from Moab. Don’t miss sunset at Delicate Arch—bring a headlamp; it gets dark fast on the way back.",
                    photoURL: "https://images.unsplash.com/photo-1504192010706-96946577af45",
                    recommendedStay: "Under Canvas Moab",
                    hasWater: true,
                    hasFuel: false,
                    signalStrength: 4,
                    dayPhotos: ["https://images.unsplash.com/photo-1504192010706-96946577af45"],
                    images: ["https://images.unsplash.com/photo-1504192010706-96946577af45"],
                    text: "Day one from Moab. Don’t miss sunset at Delicate Arch—bring a headlamp; it gets dark fast on the way back.",
                    airbnbLink: "https://www.airbnb.com/"
                ),
                CommunityJourneyDay(
                    dayNumber: 2,
                    location: CommunityGeoLocation(latitude: 38.4367, longitude: -109.8108),
                    locationName: "Canyonlands (Island in the Sky)",
                    notes: "Stunning canyon views. Shafer Trail is demanding—use low gear.",
                    photoURL: "https://images.unsplash.com/photo-1516939884455-1445c8652f83",
                    recommendedStay: "Willow Flat Campground",
                    hasWater: false,
                    hasFuel: false,
                    signalStrength: 1,
                    dayPhotos: ["https://images.unsplash.com/photo-1516939884455-1445c8652f83"],
                    images: ["https://images.unsplash.com/photo-1516939884455-1445c8652f83"],
                    text: "Stunning canyon views. Shafer Trail is demanding—use low gear."
                ),
                CommunityJourneyDay(
                    dayNumber: 3,
                    location: CommunityGeoLocation(latitude: 38.3670, longitude: -111.2615),
                    locationName: "Capitol Reef National Park",
                    notes: "Drive UT-24—scenery like Mars. The pie here is famous; grab one at Gifford House.",
                    recommendedStay: "Capitol Reef Resort (Wagons)",
                    hasWater: true,
                    hasFuel: true,
                    signalStrength: 3,
                    dayPhotos: ["https://images.unsplash.com/photo-1516939884455-1445c8652f83"],
                    images: ["https://images.unsplash.com/photo-1516939884455-1445c8652f83"],
                    text: "Drive UT-24—scenery like Mars. The pie here is famous; grab one at Gifford House."
                )
            ],
            selectedStates: ["Utah"],
            duration: "7 Days",
            vehicle: "High Clearance 4WD",
            pace: "Moderate",
            difficulty: "Moderate",
            tags: ["Utah", "7 Days", "High Clearance 4WD", "Moderate", "Difficulty · Moderate", "National Parks"],
            state: "Utah",
            author: CommunityAuthor(id: "alex", displayName: "Alex Explorer", avatarURL: "https://example.com/avatar.jpg"),
            likeCount: 1240,
            commentCount: 85
        ))
    }
}
