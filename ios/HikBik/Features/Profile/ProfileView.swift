// Profile – Komoot-style + U.S. achievements, glassmorphism, Magic Path, social
import SwiftUI
import MapKit
import CoreLocation
import PhotosUI
import Photos

// MARK: - Profile theme (Deep Space Blue: expansive, inviting)
fileprivate enum ProfileTheme {
    static let background = Color(hex: "050A18")
    static let cardBg = Color(hex: "161C2C")
    static let cardBgWithBlur = Color(hex: "161C2C").opacity(0.8)
    static let borderStroke = Color(hex: "2A354F")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "8E8E93")
    static let accent = Color(hex: "3FFD98")
    static let accentSecondary = Color(hex: "3B82F6")
    /// Blue-to-Green gradient for primary buttons
    static let primaryButtonGradient = LinearGradient(
        colors: [Color(hex: "2563EB"), Color(hex: "3FFD98")],
        startPoint: .leading,
        endPoint: .trailing
    )
}

/// 與 Community mock Detailed Track 對齊的 mock 數據，供 Profile Saved/Liked 解析 track_zion-angels-landing-001
fileprivate enum ProfileMockData {
    static let zionAngelsLandingTrack: DetailedTrackPost = DetailedTrackPost(
        category: .nationalPark,
        routeName: "Angel's Landing Trail - Zion",
        totalDurationMinutes: 30,
        viewPointNodes: [
            ViewPointNode(title: "The Grotto Trailhead", activityType: .hiking, latitude: 37.2591, longitude: -112.9501, photoCount: 1, arrivalTime: "09:00 AM", hasWater: true, hasFuel: false, signalStrength: 3),
            ViewPointNode(title: "Walter's Wiggles", activityType: .climbing, latitude: 37.2635, longitude: -112.9472, photoCount: 1, arrivalTime: "10:15 AM", hasWater: false, hasFuel: false, signalStrength: 1),
            ViewPointNode(title: "Angel's Landing Summit", activityType: .summit, latitude: 37.2662, longitude: -112.9468, photoCount: 1, arrivalTime: "11:30 AM", hasWater: false, hasFuel: false, signalStrength: 0)
        ],
        elevationGain: "1488 ft",
        heroImage: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
        heroImages: [
            "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
            "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800",
            "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
        ],
        routeID: "zion-angels-landing-001"
    )
}

// MARK: - 5-Tab navigation: Posts, My Trip, Saved, Liked, Medals
fileprivate enum ProfileGridTab: String, CaseIterable {
    case grid = "square.grid.3x3.fill"
    case myTrip = "map.fill"
    case folder = "folder.fill"
    case liked = "heart.fill"
    case medals = "medal.fill"
    var label: String {
        switch self {
        case .grid: return "Posts"
        case .myTrip: return "My Trip"
        case .folder: return "Saved"
        case .liked: return "Liked"
        case .medals: return "Medals"
        }
    }
}

fileprivate let tabActiveColor = Color(hex: "3FFD98")
fileprivate let tabInactiveColor = Color(hex: "8E8E93")

/// 按壓縮小反饋，用於收藏/點贊卡片
fileprivate struct ScaleOnPressCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Follow list mode (fileprivate so sheet can use it)
fileprivate enum FollowListMode {
    case following, followers
}

/// 用於 Profile Liked 分頁的導航：id + journey
fileprivate struct LikedPostItem: Identifiable, Hashable {
    let id: String
    let journey: CommunityJourney
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: LikedPostItem, r: LikedPostItem) -> Bool { l.id == r.id }
}

/// 用於 Profile Saved 分頁的導航：id + journey（與 Liked 同結構，跳轉 CommunityMacroDetailView）
fileprivate struct SavedPostItem: Identifiable, Hashable {
    let id: String
    let journey: CommunityJourney
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: SavedPostItem, r: SavedPostItem) -> Bool { l.id == r.id }
}

/// 用於 Profile Saved 的 Detailed Track：id 為 track_routeID，跳轉 ManualJourneyDetailView，標籤 TRACK
fileprivate struct SavedTrackItem: Identifiable, Hashable {
    let id: String
    let journey: DetailedTrackPost
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (l: SavedTrackItem, r: SavedTrackItem) -> Bool { l.id == r.id }
}

/// Saved 網格統一行類型：Journey 或 Track，以便同一個 LazyVGrid + navigationDestination
fileprivate enum ProfileSavedRow: Identifiable, Hashable {
    case journey(SavedPostItem)
    case track(SavedTrackItem)
    var id: String {
        switch self {
        case .journey(let s): return s.id
        case .track(let t): return t.id
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var userState: UserState
    @ObservedObject private var authManager = AuthManager.shared
    /// 與 `ContentView` 注入的 `UserProfileViewModel.shared` 同一實例；**禁止**在此使用 `StateObject(UserProfileViewModel())` 以免資料不共享。
    @EnvironmentObject private var userProfileVM: UserProfileViewModel
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var communityViewModel: CommunityViewModel
    @EnvironmentObject private var trackDataManager: TrackDataManager
    @State private var selectedGridTab: ProfileGridTab = .grid
    @State private var collections: [ProfileCollection] = []
    /// Drafts list bound to DataManager.draftTracks (single source of truth; no local copy to avoid list shaking).
    private var drafts: [DraftItem] { trackDataManager.draftTracks }
    @State private var showShareSheet = false
    @State private var showCreateCollection = false
    @State private var newCollectionName = ""
    @State private var showFollowList = false
    @State private var followListMode: FollowListMode = .followers
    @State private var newCollectionCoverId: String? = nil
    @State private var selectedDraftForReel: DraftItem? = nil
    @State private var selectedAchievementForModal: Achievement? = nil
    @State private var showSignOutAlert = false
    @State private var draftToDelete: DraftItem? = nil
    /// 點擊卡片跳轉詳情：由 onTapGesture 設置，避免 NavigationLink 與按鈕點擊錯位
    @State private var selectedDraftForDetail: DraftItem? = nil
    @State private var showEditProfile = false
    @State private var avatarPickerItem: PhotosPickerItem?
    @State private var isUploadingAvatar = false

    /// Posts 僅顯示當前 MongoDB 用戶 id 與 `ownerUserId` 一致的已發布內容（新用戶無 id 時列表為空，不混入他人）。
    private var myPublishedPostsForCurrentUser: [DraftItem] {
        let all = trackDataManager.publishedTracks
        guard let uid = userProfileVM.profile?.id, !uid.isEmpty else { return [] }
        return all.filter { $0.ownerUserId == uid }
    }

    private var profileBioDisplay: String {
        let raw = userProfileVM.profile?.bio?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return raw.isEmpty ? "No bio added yet" : raw
    }

    var body: some View {
        NavigationStack {
            Group {
                if !authManager.isLoggedIn {
                    guestJoinHIKBIKContent
                } else if userProfileVM.profile == nil {
                    ProgressView()
                        .tint(ProfileTheme.accent)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            socialHeaderSection
                            ProStatsDashboardCard()
                            threeTabSection
                            localPublishDebugClearSection
                            gridOrFolderOrHeartContent
                            Color.clear.frame(height: 80)
                        }
                        .padding(.bottom, 80)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ProfileTheme.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                trackDataManager.reloadFromStore()
                userProfileVM.reloadFromStorage()
                loadData()
                Task { await userProfileVM.refreshFromServerIfLoggedIn() }
            }
            .onReceive(NotificationCenter.default.publisher(for: .unifiedDraftsDidChange)) { _ in
                loadData()
            }
            .sheet(isPresented: $showShareSheet) {
                ShareProfileSheet()
            }
            .sheet(isPresented: $showCreateCollection) {
                CreateCollectionSheet(name: $newCollectionName, coverIdentifier: $newCollectionCoverId) {
                    let c = ProfileCollection(
                        name: newCollectionName.isEmpty ? "New Collection" : newCollectionName,
                        coverImageIdentifier: newCollectionCoverId
                    )
                    ProfileCollectionsStore.append(c)
                    collections = ProfileCollectionsStore.loadAll()
                    newCollectionName = ""
                    newCollectionCoverId = nil
                    showCreateCollection = false
                } onCancel: {
                    newCollectionName = ""
                    newCollectionCoverId = nil
                    showCreateCollection = false
                }
            }
            .sheet(isPresented: $showFollowList) {
                FollowListSheet(
                    mode: followListMode,
                    userIds: followListMode == .followers
                        ? (userProfileVM.profile?.followers ?? [])
                        : (userProfileVM.profile?.following ?? [])
                )
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet()
                    .environmentObject(userProfileVM)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: showEditProfile) { _, isOpen in
                if !isOpen {
                    Task { await userProfileVM.refreshFromServerIfLoggedIn() }
                }
            }
            .navigationDestination(for: DraftItem.self) { draft in
                if trackDataManager.publishedTracks.contains(where: { $0.id == draft.id }) {
                    switch draft.category {
                    case .grandJourney:
                        CommunityMacroDetailView(
                            journey: draft.communityJourneyForMacroDetail(),
                            journeyId: draft.id.uuidString,
                            coverImageData: draft.coverImageData
                        )
                    case .detailedTrack:
                        ManualJourneyDetailView(journey: draft.toManualJourney())
                    case .livelyActivity:
                        ActivityDetailView(draft: draft)
                    }
                } else if draft.isEditable {
                    CustomRouteBuilderView(liveTrackDraft: LiveTrackDraft.from(draftItem: draft))
                } else {
                    LiveTrackDetailView(draft: draft)
                }
            }
            .navigationDestination(item: $selectedDraftForDetail) { draft in
                switch draft.category {
                case .grandJourney:
                    CommunityMacroDetailView(
                        journey: draft.communityJourneyForMacroDetail(),
                        journeyId: draft.id.uuidString,
                        coverImageData: draft.coverImageData
                    )
                case .detailedTrack:
                    ManualJourneyDetailView(journey: draft.toManualJourney())
                case .livelyActivity:
                    ActivityDetailView(draft: draft)
                }
            }
            .navigationDestination(for: ProfileCollection.self) { collection in
                CollectionDetailView(collection: collection)
            }
            .navigationDestination(for: HonorCenterDestination.self) { _ in
                AdventureStatsProView()
            }
            .navigationDestination(for: LikedPostItem.self) { item in
                CommunityMacroDetailView(journey: item.journey, journeyId: item.id)
            }
            .navigationDestination(for: SavedPostItem.self) { item in
                CommunityMacroDetailView(journey: item.journey, journeyId: item.id)
            }
            .navigationDestination(for: ProfileSavedRow.self) { row in
                switch row {
                case .journey(let s):
                    CommunityMacroDetailView(journey: s.journey, journeyId: s.id)
                case .track(let t):
                    ManualJourneyDetailView(journey: t.journey)
                }
            }
            .fullScreenCover(item: $selectedDraftForReel) { draft in
                PostReelFullScreenView(draft: draft) {
                    selectedDraftForReel = nil
                }
            }
            .sheet(item: $selectedAchievementForModal) { achievement in
                HonorBadgeFlipModal(achievement: achievement) {
                    selectedAchievementForModal = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !authManager.isLoggedIn {
                        Button("Sign In") {
                            userState.requestLandingForAuth()
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(ProfileTheme.accent)
                    } else {
                        Button("Sign Out") {
                            showSignOutAlert = true
                        }
                        .font(.system(size: 15))
                        .foregroundStyle(ProfileTheme.textMuted)
                    }
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm", role: .destructive) {
                    userState.userStatus = .guest
                    AuthManager.shared.logout()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .onReceive(NotificationCenter.default.publisher(for: .postDeleted)) { _ in
                trackDataManager.reloadFromStore()
            }
            .onChange(of: avatarPickerItem) { _, new in
                Task { await uploadAvatarIfPicked(new) }
            }
            .preferredColorScheme(.dark)
        }
    }

    private func loadData() {
        collections = ProfileCollectionsStore.loadAll()
        let draftList = trackDataManager.draftTracks
        ProfileAchievementsStore.updateFromDrafts(draftList)
        if draftList.contains(where: { $0.source == .imported }) {
            ProfileAchievementsStore.markGPXImported()
        }
        let totalMeters = draftList.reduce(0.0) { $0 + $1.totalDistanceMeters }
        AchievementStore.updateFromDrafts(totalDistanceMeters: totalMeters)
    }

    // MARK: - Guest: Join HIKBIK landing (benefits summary + Sign Up CTA)
    private var guestJoinHIKBIKContent: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 64))
                        .foregroundStyle(ProfileTheme.accent)
                    Text("Join HIKBIK")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                    Text("Create an account to unlock your adventure profile, stats, and more.")
                        .font(.system(size: 15))
                        .foregroundStyle(ProfileTheme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)

                VStack(alignment: .leading, spacing: 16) {
                    memberBenefitRow(icon: "chart.line.uptrend.xyaxis", title: "Pro Stats", subtitle: "Precision tracking for every trail.")
                    memberBenefitRow(icon: "medal.fill", title: "Digital Medals", subtitle: "Collect exclusive National Park badges.")
                    memberBenefitRow(icon: "lock.shield.fill", title: "Secure Sync", subtitle: "Your adventures, backed up in the cloud.")
                    memberBenefitRow(icon: "map.fill", title: "Record Treks", subtitle: "Record live tracks and save routes as drafts.")
                }
                .padding(.horizontal, 20)

                Button {
                    userState.requestLandingForAuth()
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ProfileTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.top, 8)

                Spacer(minLength: 60)
            }
        }
    }

    private func memberBenefitRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(ProfileTheme.accent)
                .frame(width: 32, alignment: .center)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(ProfileTheme.cardBg.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 1. Social identity (Magic Path + avatar, following/followers, share, BadgeShelf, bio, US Region)
    private var socialHeaderSection: some View {
        VStack(spacing: 16) {
            ZStack {
                MagicPathGlowGraphic()
                    .frame(width: 140, height: 140)
                    .blur(radius: 24)
                PhotosPicker(selection: $avatarPickerItem, matching: .images) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 88, height: 88)
                        profileAvatarImageContent
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                    }
                    .overlay(Circle().stroke(ProfileTheme.accent.opacity(0.45), lineWidth: 2))
                    .overlay {
                        if isUploadingAvatar {
                            ZStack {
                                Color.black.opacity(0.45)
                                ProgressView()
                                    .tint(ProfileTheme.accent)
                            }
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(isUploadingAvatar)
                .accessibilityLabel("Change profile photo")
            }

            Group {
                if !authManager.isLoggedIn {
                    Text("Guest")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                } else {
                    VStack(spacing: 10) {
                        Text(profileDisplayName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(ProfileTheme.textPrimary)
                        if let email = userProfileVM.profile?.email, !email.isEmpty {
                            Text(email)
                                .font(.system(size: 14))
                                .foregroundStyle(ProfileTheme.textMuted)
                        }
                        Button {
                            showEditProfile = true
                        } label: {
                            Text("Edit Profile")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(ProfileTheme.accent)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .multilineTextAlignment(.center)

            HStack(spacing: 24) {
                Button {
                    followListMode = .following
                    showFollowList = true
                } label: {
                    VStack(spacing: 2) {
                        Text("\(userProfileVM.profile?.displayFollowingCount ?? 0)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(ProfileTheme.textPrimary)
                        Text("Following")
                            .font(.system(size: 12))
                            .foregroundStyle(ProfileTheme.textMuted)
                    }
                }
                .buttonStyle(.plain)
                Button {
                    followListMode = .followers
                    showFollowList = true
                } label: {
                    VStack(spacing: 2) {
                        Text("\(userProfileVM.profile?.displayFollowersCount ?? 0)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(ProfileTheme.textPrimary)
                        Text("Followers")
                            .font(.system(size: 12))
                            .foregroundStyle(ProfileTheme.textMuted)
                    }
                }
                .buttonStyle(.plain)
            }

            Button {
                showShareSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share profile")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(ProfileTheme.primaryButtonGradient)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Text(profileBioDisplay)
                .id(userProfileVM.profile?.bio ?? "")
                .font(.system(size: 14))
                .foregroundStyle(ProfileTheme.textMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .onReceive(userProfileVM.$profile) { _ in
                    print("UI 刷新了")
                }

            if ProfileUSRegionHelper.distinctStateCount(from: drafts) > 3 {
                HStack(spacing: 6) {
                    Image(systemName: "star.circle.fill")
                        .foregroundStyle(ProfileTheme.accent)
                    Text("U.S. Region")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ProfileTheme.cardBg)
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var profileAvatarImageContent: some View {
        if let urlStr = userProfileVM.profile?.avatarUrl?.trimmingCharacters(in: .whitespacesAndNewlines),
           !urlStr.isEmpty,
           let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(ProfileTheme.textMuted)
                case .empty:
                    ProgressView()
                        .tint(ProfileTheme.accent)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 36))
                .foregroundStyle(ProfileTheme.textMuted)
        }
    }

    private func uploadAvatarIfPicked(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self), !data.isEmpty else { return }
        await MainActor.run { isUploadingAvatar = true }
        do {
            try await AuthService.uploadUserAvatar(imageData: data)
            await userProfileVM.refreshFromServerIfLoggedIn()
        } catch {
            print("ProfileView: avatar upload failed — \(error.localizedDescription)")
        }
        await MainActor.run {
            isUploadingAvatar = false
            avatarPickerItem = nil
        }
    }

    private var profileDisplayName: String {
        guard let p = userProfileVM.profile else { return "Member" }
        let first = p.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = p.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let full = [first, last].filter { !$0.isEmpty }.joined(separator: " ")
        if !full.isEmpty { return full }
        if !first.isEmpty { return first }
        // 兼容後端若用 nickname/displayName 字段映射失败的场景，至少不显示空白
        return "Member"
    }

    /// 標籤文字 + 數量（Liked/Saved 與 currentUser 實時同步）
    private func tabLabel(for tab: ProfileGridTab) -> String {
        switch tab {
        case .liked: return "Liked (\(currentUser.likedPostIds.count))"
        case .folder: return "Saved (\(currentUser.savedPostIds.count))"
        default: return tab.label
        }
    }

    // MARK: - 2. Four-tab bar (Posts, My Trip, Saved, Medals) with haptic on switch
    private var threeTabSection: some View {
        HStack(spacing: 0) {
            ForEach(ProfileGridTab.allCases, id: \.self) { tab in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedGridTab = tab
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20))
                        Text(tabLabel(for: tab))
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selectedGridTab == tab ? tabActiveColor : tabInactiveColor)
                    .shadow(color: selectedGridTab == tab ? tabActiveColor.opacity(0.6) : .clear, radius: 6)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
            }
        }
        .background(ProfileTheme.cardBgWithBlur)
        .background(.ultraThinMaterial.opacity(0.5))
    }

    /// 臨時：清空本地已發布列表，便於測試雲端 Feed。
    private var localPublishDebugClearSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("測試工具")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ProfileTheme.textMuted)
            Button {
                trackDataManager.clearLocalPublishedTracks()
                communityViewModel.clearPrependedPublishedPosts()
                TabSelectionManager.shared.switchToCommunity()
            } label: {
                Text("清理本地發布箱")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ProfileTheme.cardBgWithBlur)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - 3. Tab content (Posts | My Trip | Saved | Medals)
    private var gridOrFolderOrHeartContent: some View {
        Group {
            switch selectedGridTab {
            case .grid:
                myPostsGrid
            case .myTrip:
                myTripContent
            case .folder:
                savedTabContent
            case .liked:
                likedPostsSection
            case .medals:
                medalsContent
            }
        }
        .padding(.top, 16)
    }

    /// Profile Posts = published only。宏觀 / 微觀 / 實時 三種卡片與導航完全分流。
    private var myPostsGrid: some View {
        let posts = myPublishedPostsForCurrentUser
        return Group {
            if posts.isEmpty {
                Text("No posts yet. Publish a recording from Community to see it here.")
                    .font(.system(size: 15))
                    .foregroundStyle(ProfileTheme.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(posts, id: \.id) { draft in
                        profilePostRow(draft: draft, selectedDraftForDetail: $selectedDraftForDetail)
                    }
                }
                .id(posts.count)
                .padding(.horizontal, 20)
            }
        }
    }

    @ViewBuilder
    private func profilePostRow(draft: DraftItem, selectedDraftForDetail: Binding<DraftItem?>) -> some View {
        ZStack(alignment: .topTrailing) {
            // 卡片：僅用 onTapGesture 跳轉，不包在 NavigationLink 內，避免擋住右上角按鈕
            Group {
                switch draft.category {
                case .grandJourney: ProfileGrandJourneyCard(draft: draft)
                case .detailedTrack: ProfileDetailedTrackCard(draft: draft)
                case .livelyActivity: ProfileLivelyActivityCard(draft: draft)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedDraftForDetail.wrappedValue = draft
            }

            // 右上角「…」：固定 44pt 點擊區，優先於卡片點擊
            Menu {
                Button(role: .destructive) {
                    draftToDelete = draft
                } label: {
                    Label("Delete Post", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .highPriorityGesture(TapGesture())
            .zIndex(1)
        }
        .id(draft.id)
        .confirmationDialog("Are you sure you want to delete this journey?", isPresented: Binding(
            get: { draftToDelete?.id == draft.id },
            set: { if !$0 { draftToDelete = nil } }
        ), titleVisibility: .visible) {
            Button("Cancel", role: .cancel) {
                draftToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let d = draftToDelete, d.id == draft.id {
                    withAnimation(.easeOut(duration: 0.25)) {
                        trackDataManager.removePublished(id: d.id)
                    }
                    draftToDelete = nil
                }
            }
        } message: {
            Text("This action cannot be undone. All photos and itinerary data will be permanently removed.")
        }
    }

    /// Saved 標籤：先顯示「已收藏貼文」（來自 CurrentUser.savedPostIds），再顯示「收藏夾」
    private var savedTabContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            savedPostsSection
            savedCollectionsSection
        }
    }

    /// 根據 postId 推斷卡片分類（JOURNEY / TRACK / LIVE），便於後續擴展
    private func profileCardCategory(for postId: String) -> ProfileInsStyleCardCategory {
        let lower = postId.lowercased()
        if lower.hasPrefix("live_") || lower.contains("liveactivity") { return .live }
        if lower.hasPrefix("track_") || lower.contains("detailedtrack") { return .track }
        return .journey
    }

    /// 行程內圖片總數（用於多圖輪播標識）
    private func journeyImageCount(_ journey: CommunityJourney) -> Int {
        let total = journey.days.reduce(0) { acc, d in
            let urls = d.dayPhotos ?? d.images ?? []
            return acc + (urls.isEmpty ? (d.photoURL != nil ? 1 : 0) : urls.count)
        }
        return max(1, total)
    }

    /// 全局已發布 Grand Journey 列表（與 Community 一致，用於 published_N 解析）
    private var publishedGrandJourneys: [DraftItem] {
        trackDataManager.publishedTracks.filter { $0.category == .grandJourney }
    }

    /// 全局已發布 Detailed Track 列表（用於 track_routeID 解析）
    private var publishedDetailedTracks: [DraftItem] {
        trackDataManager.publishedTracks.filter { $0.category == .detailedTrack }
    }

    /// 依 postId 解析為 CommunityJourney（mock "1" 或 published_N 從 publishedGrandJourneys）
    private func resolveJourney(forPostId id: String) -> CommunityJourney? {
        if let journey = CommunityViewModel.journey(forPostId: id) { return journey }
        guard id.hasPrefix("published_"),
              let idx = Int(id.replacingOccurrences(of: "published_", with: "")),
              idx >= 0, idx < publishedGrandJourneys.count else { return nil }
        return publishedGrandJourneys[idx].communityJourneyForMacroDetail()
    }

    /// 依 postId (track_routeID) 解析為 DetailedTrackPost：publishedTracks → SocialDataManager → 已知 mock（如 Community 的 Angels Landing）
    private func resolveTrackJourney(forPostId id: String) -> DetailedTrackPost? {
        guard id.hasPrefix("track_") else { return nil }
        if let draft = publishedDetailedTracks.first(where: { "track_\($0.routeID)" == id }) {
            return draft.toManualJourney()
        }
        if let data = SocialDataManager.shared.getTrackJourneyData(id: id),
           let journey = try? JSONDecoder().decode(DetailedTrackPost.self, from: data) {
            return journey
        }
        if id == "track_zion-angels-landing-001" {
            return ProfileMockData.zionAngelsLandingTrack
        }
        return nil
    }

    /// 已收藏：從 currentUser.savedPostIds + 全局 publishedTracks 解析，全寬高級卡片 + 取消收藏
    private var savedPostsSection: some View {
        let journeyItems: [SavedPostItem] = currentUser.savedPostIds.compactMap { id in
            guard !id.hasPrefix("track_") else { return nil }
            guard let journey = resolveJourney(forPostId: id) else { return nil }
            return SavedPostItem(id: id, journey: journey)
        }
        let trackItems: [SavedTrackItem] = currentUser.savedPostIds.compactMap { id in
            guard id.hasPrefix("track_"), let journey = resolveTrackJourney(forPostId: id) else { return nil }
            return SavedTrackItem(id: id, journey: journey)
        }
        let rows: [ProfileSavedRow] = journeyItems.map { .journey($0) } + trackItems.map { .track($0) }
        return Group {
            if !rows.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Saved posts")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                        .padding(.horizontal, 20)
                    LazyVStack(spacing: 16) {
                        ForEach(rows) { row in
                            savedRowCardFullWidth(row)
                        }
                    }
                    .padding(.horizontal, 20)
                    .scrollDisabled(true)
                }
            }
        }
    }

    /// 全寬高級卡片（全屏背景圖 + 藍/橘標籤）+ 取消收藏按鈕；點擊卡片跳轉詳情
    @ViewBuilder
    private func savedRowCardFullWidth(_ row: ProfileSavedRow) -> some View {
        let postId = row.id
        ZStack(alignment: .topTrailing) {
            NavigationLink(value: row) {
                switch row {
                case .journey(let item):
                    ProfileFullWidthJourneyCard(
                        imageURL: item.journey.coverImageURL ?? item.journey.days.first?.photoURL,
                        title: item.journey.journeyName,
                        tagText: "JOURNEY",
                        tagColor: Color(hex: "FF8C42")
                    )
                case .track(let item):
                    ProfileFullWidthJourneyCard(
                        imageURL: item.journey.heroImage ?? item.journey.heroImages?.first,
                        title: item.journey.routeName,
                        tagText: "TRACK",
                        tagColor: Color(hex: "60A5FA")
                    )
                }
            }
            .buttonStyle(ScaleOnPressCardStyle())
            Button {
                AuthGuard.run(message: AuthGuardMessages.collectRoute) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentUser.toggleSave(postId: postId)
                }
            } label: {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.yellow)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .zIndex(1)
        }
    }

    @ViewBuilder
    private func savedRowCard(_ row: ProfileSavedRow) -> some View {
        switch row {
        case .journey(let item):
            ProfileInsStyleCard(
                imageURL: item.journey.coverImageURL ?? item.journey.days.first?.photoURL,
                title: item.journey.journeyName,
                iconKind: .bookmark,
                imageCount: journeyImageCount(item.journey),
                category: profileCardCategory(for: item.id)
            )
        case .track(let item):
            ProfileInsStyleCard(
                imageURL: item.journey.heroImage ?? item.journey.heroImages?.first,
                title: item.journey.routeName,
                iconKind: .bookmark,
                imageCount: max(1, item.journey.heroImages?.count ?? 0),
                category: .track
            )
        }
    }

    private var savedCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                showCreateCollection = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "folder.badge.plus")
                    Text("New collection")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(ProfileTheme.accent)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)

            if collections.isEmpty {
                Text("Save routes into collections like \"Bucket List\" or \"Weekend Trips\".")
                    .font(.system(size: 14))
                    .foregroundStyle(ProfileTheme.textMuted)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 32)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(collections) { collection in
                        NavigationLink(value: collection) {
                            SavedCollectionRow(collection: collection)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                }
                .scrollDisabled(true)
            }
        }
    }

    /// Liked: 從 currentUser.likedPostIds 解析 Journey + Track（與 Saved 一致），全寬卡片 + 取消點贊按鈕
    private var likedPostsSection: some View {
        let journeyItems: [SavedPostItem] = currentUser.likedPostIds.compactMap { id in
            guard !id.hasPrefix("track_"), let journey = resolveJourney(forPostId: id) else { return nil }
            return SavedPostItem(id: id, journey: journey)
        }
        let trackItems: [SavedTrackItem] = currentUser.likedPostIds.compactMap { id in
            guard id.hasPrefix("track_"), let journey = resolveTrackJourney(forPostId: id) else { return nil }
            return SavedTrackItem(id: id, journey: journey)
        }
        let rows: [ProfileSavedRow] = journeyItems.map { .journey($0) } + trackItems.map { .track($0) }
        return Group {
            if rows.isEmpty {
                Text("No liked posts yet. Like journeys or tracks in Community to see them here.")
                    .font(.system(size: 15))
                    .foregroundStyle(ProfileTheme.textMuted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
                    .padding(.horizontal, 20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Liked posts")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                        .padding(.horizontal, 20)
                    LazyVStack(spacing: 16) {
                        ForEach(rows) { row in
                            likedRowCardFullWidth(row)
                        }
                    }
                    .padding(.horizontal, 20)
                    .scrollDisabled(true)
                }
            }
        }
    }

    /// 全寬卡片 + 取消點贊（紅心按鈕），點擊卡片跳轉詳情；與 Saved 共用 ProfileSavedRow 導航
    @ViewBuilder
    private func likedRowCardFullWidth(_ row: ProfileSavedRow) -> some View {
        let postId = row.id
        ZStack(alignment: .topTrailing) {
            NavigationLink(value: row) {
                switch row {
                case .journey(let item):
                    ProfileFullWidthJourneyCard(
                        imageURL: item.journey.coverImageURL ?? item.journey.days.first?.photoURL,
                        title: item.journey.journeyName,
                        tagText: "JOURNEY",
                        tagColor: Color(hex: "FF8C42")
                    )
                case .track(let item):
                    ProfileFullWidthJourneyCard(
                        imageURL: item.journey.heroImage ?? item.journey.heroImages?.first,
                        title: item.journey.routeName,
                        tagText: "TRACK",
                        tagColor: Color(hex: "60A5FA")
                    )
                }
            }
            .buttonStyle(ScaleOnPressCardStyle())
            Button {
                AuthGuard.run(message: AuthGuardMessages.likePost) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    currentUser.toggleLike(postId: postId)
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.red)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .zIndex(1)
        }
    }

    /// My Trip: month-grouped vertical card list (Recorded + Imported only). Sticky section headers with monthly summary.
    private var myTripContent: some View {
        let groups = MyTripMonthGroup.groups(from: drafts)
        return Group {
            if groups.isEmpty {
                MyTripEmptyState()
            } else {
            List {
                    ForEach(groups, id: \.id) { group in
                Section {
                            ForEach(group.trips, id: \.id) { draft in
                                NavigationLink(value: draft) {
                                    MyTripCard(draft: draft)
                                }
                                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        } header: {
                            MyTripMonthHeader(
                                title: group.title,
                                totalDistanceMeters: group.totalDistanceMeters,
                                totalElevationMeters: group.totalElevationMeters,
                                tripCount: group.tripCount
                            )
                        }
                        .listSectionSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
        }
    }

    /// Medals: trophy case from Achievement system (Parks, Milestones, Technical)
    private var medalsContent: some View {
        let grouped = AchievementStore.achievementsByCategory()
        return VStack(alignment: .leading, spacing: 20) {
            NavigationLink(value: HonorCenterDestination()) {
                HStack(spacing: 8) {
                    Text("View full Honor Center")
                        .font(.system(size: 15, weight: .semibold))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(tabActiveColor)
            }
            .padding(.horizontal, 20)

            ForEach(Array(grouped.enumerated()), id: \.offset) { _, pair in
                VStack(alignment: .leading, spacing: 12) {
                    Text(pair.section)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(ProfileTheme.textMuted)
                        .padding(.horizontal, 20)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 16)], spacing: 16) {
                        ForEach(pair.achievements) { achievement in
                            Medal3DBadgeCell(achievement: achievement) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                selectedAchievementForModal = achievement
                            }
                        }
                    }
                    .scrollDisabled(true)
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Pro Stats Dashboard entry card (premium glassmorphism, 1px glow border, SF Mono, pulse radar)
fileprivate let proStatsNeon = Color(hex: "3FFD98")
private struct HonorCenterDestination: Hashable {}
struct ProStatsDashboardCard: View {
    private var miles: Double { AchievementStore.cumulativeMiles }
    private var elevation: Double {
        TrackDataManager.shared.allTracks
            .filter { $0.source == .liveRecorded || $0.source == .imported }
            .reduce(0.0) { $0 + $1.elevationGainMeters }
    }
    private var peaks: Int { AchievementStore.unlockedIds.filter { $0.hasPrefix("park_") }.count }
    private var radarValues: [Double] { AdventureStatsService.radarValues() }

    var body: some View {
        NavigationLink(value: HonorCenterDestination()) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pro Stats")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(ProfileTheme.textMuted)
                    HStack(spacing: 16) {
                        statBlock("\(String(format: "%.0f", miles))", unit: "mi")
                        statBlock("\(Int(elevation))", unit: "m")
                        statBlock("\(peaks)", unit: "peaks")
                    }
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                Spacer(minLength: 8)
                MiniRadarView(values: radarValues)
                    .frame(width: 56, height: 56)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.7))
            }
            .padding(16)
            .background(proStatsCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(proStatsCardBorder)
            .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var proStatsCardBackground: some View {
        ZStack {
            Color(hex: "161C2C").opacity(0.8)
            Rectangle().fill(.ultraThinMaterial)
        }
    }

    private var proStatsCardBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(ProfileTheme.borderStroke, lineWidth: 1)
            .shadow(color: proStatsNeon.opacity(0.25), radius: 3)
    }

    private func statBlock(_ value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(value)
                .foregroundStyle(proStatsNeon)
                .shadow(color: proStatsNeon.opacity(0.8), radius: 4)
            Text(unit)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(ProfileTheme.textMuted.opacity(0.6))
        }
    }
}

// MARK: - Mini radar (semi-transparent fill, pulsating vertex points)
struct MiniRadarView: View {
    let values: [Double]
    private let sides = 5
    @State private var pulseOpacity: Double = 0.2
    @State private var vertexScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 4
            ZStack {
                ForEach(0..<sides, id: \.self) { i in
                    Path { p in
                        p.move(to: center)
                        p.addLine(to: point(center: center, radius: radius, i: i))
                    }
                    .stroke(ProfileTheme.textMuted.opacity(0.3), lineWidth: 0.8)
                }
                if values.count >= sides {
                    radarPath(center: center, radius: radius)
                        .fill(proStatsNeon.opacity(pulseOpacity))
                    radarPath(center: center, radius: radius)
                        .stroke(proStatsNeon, lineWidth: 1.2)
                    ForEach(0..<sides, id: \.self) { i in
                        let v = max(0, min(1, values[i]))
                        let r = radius * CGFloat(v)
                        let pt = point(center: center, radius: r, i: i)
                        Circle()
                            .fill(proStatsNeon)
                            .frame(width: 4, height: 4)
                            .scaleEffect(vertexScale)
                            .position(pt)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulseOpacity = 0.35
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                vertexScale = 1.4
            }
        }
    }

    private func angle(_ i: Int) -> Double {
        -.pi / 2 + (Double(i) / Double(sides)) * 2 * .pi
    }
    private func point(center: CGPoint, radius: CGFloat, i: Int) -> CGPoint {
        CGPoint(x: center.x + radius * CGFloat(cos(angle(i))), y: center.y + radius * CGFloat(sin(angle(i))))
    }
    private func radarPath(center: CGPoint, radius: CGFloat) -> Path {
        var p = Path()
        for i in 0..<sides {
            let v = max(0, min(1, values[i]))
            let pt = point(center: center, radius: radius * CGFloat(v), i: i)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

// MARK: - Profile 宏觀卡片（大圖封面 + 高級感，僅 Posts 列表用）
private let profileGrandCorner: CGFloat = 20
struct ProfileGrandJourneyCard: View {
    let draft: DraftItem
    private var dayCount: Int {
        if let j = draft.macroJourneyJSON, let d = j.data(using: .utf8),
           let p = try? JSONDecoder().decode(MacroJourneyPost.self, from: d) {
            return max(1, p.days.count)
        }
        return max(1, draft.waypoints.count)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let data = draft.coverImageData, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ProfileMiniCardThumbnail(draft: draft)
                            .scaleEffect(1.2)
                    }
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 200)
                    .allowsHitTesting(false)
                VStack(alignment: .leading, spacing: 6) {
                    Text("GRAND JOURNEY")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "FF8C42"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.5))
                        .clipShape(Capsule())
                    Text(draft.title.isEmpty ? "Macro Journey" : draft.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text("\(dayCount) day\(dayCount == 1 ? "" : "s") · Itinerary")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding(16)
            }
            .clipShape(RoundedRectangle(cornerRadius: profileGrandCorner))
            .overlay(RoundedRectangle(cornerRadius: profileGrandCorner).strokeBorder(Color.white.opacity(0.08), lineWidth: 1))
        }
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: profileGrandCorner))
    }
}

private func profileActivityIcon(for activity: ViewPointActivityType) -> String {
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

// MARK: - Profile 微觀卡片（與 GrandJourney 同款全屏背景圖佈局，藍色 [ActivityType] · DETAILED TRACK 標籤）
struct ProfileDetailedTrackCard: View {
    let draft: DraftItem
    private var mileageFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "—" : String(format: "%.1f km", km)
    }
    private var subtitleLine: String {
        let dur = draft.resolvedDurationDisplay ?? "—"
        return "\(mileageFormatted) · \(dur)"
    }
    private var badgeText: String {
        let activity = draft.detailedTrackPrimaryActivityType?.rawValue.uppercased() ?? "TRACK"
        return "\(activity) · DETAILED TRACK"
    }
    private var badgeIcon: String {
        profileActivityIcon(for: draft.detailedTrackPrimaryActivityType ?? .hiking)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let data = draft.coverImageData, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ProfileMiniCardThumbnail(draft: draft)
                            .scaleEffect(1.2)
                    }
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 200)
                    .allowsHitTesting(false)
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: badgeIcon)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color(hex: "60A5FA"))
                        Text(badgeText)
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "60A5FA"))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.5))
                    .clipShape(Capsule())
                    Text(draft.title.isEmpty ? "Micro route" : draft.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(subtitleLine)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding(16)
            }
            .clipShape(RoundedRectangle(cornerRadius: profileGrandCorner))
            .overlay(RoundedRectangle(cornerRadius: profileGrandCorner).strokeBorder(Color.white.opacity(0.08), lineWidth: 1))
        }
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: profileGrandCorner))
    }
}

// MARK: - Profile 實時紀錄卡片（紅色動態標識）
struct ProfileLivelyActivityCard: View {
    let draft: DraftItem
    private var mileageFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "—" : String(format: "%.1f km", km)
    }
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "EF4444"))
                .frame(width: 4)
                .frame(maxHeight: .infinity)
            ZStack {
                if let coverData = draft.coverImageData, let ui = UIImage(data: coverData) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProfileMiniCardThumbnail(draft: draft)
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: "EF4444"))
                        .frame(width: 8, height: 8)
                    Text("LIVELY · 紀錄")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(Color(hex: "F87171"))
                }
                Text(draft.title.isEmpty ? "Live activity" : draft.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textPrimary)
                    .lineLimit(2)
                Text(mileageFormatted)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .foregroundStyle(ProfileTheme.textMuted)
        }
        .padding(.vertical, 10)
        .padding(.trailing, 14)
        .padding(.leading, 10)
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: "EF4444").opacity(0.2), lineWidth: 1))
    }
}

// MARK: - ProfileMiniCardView (Template B: 水平佈局，左正方形縮略圖，右標題+總里程，極簡)
struct ProfileMiniCardView: View {
    let draft: DraftItem

    private var mileageFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.1f km", km)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                if let coverData = draft.coverImageData, let uiImage = UIImage(data: coverData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipped()
                } else {
                    ProfileMiniCardThumbnail(draft: draft)
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(draft.title.isEmpty ? "Route" : draft.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textPrimary)
                    .lineLimit(2)
                Text(mileageFormatted)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(ProfileTheme.textMuted)
        }
        .padding(14)
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct ProfileMiniCardThumbnail: View {
    let draft: DraftItem
    var body: some View {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        Group {
            if coords.count >= 2 {
                Map(initialPosition: .region(region), interactionModes: []) {
                    MapPolyline(coordinates: coords)
                        .stroke(ProfileTheme.accent, lineWidth: 3)
                }
                .mapStyle(.standard(elevation: .flat))
            } else {
                Rectangle()
                    .fill(ProfileTheme.background)
                Image(systemName: "map")
                    .font(.system(size: 24))
                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.5))
            }
        }
    }
    private var region: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let center = CLLocationCoordinate2D(latitude: (lats.min()! + lats.max()!) / 2, longitude: (lons.min()! + lons.max()!) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max(0.02, (lats.max()! - lats.min()!) * 1.8), longitudeDelta: max(0.02, (lons.max()! - lons.min()!) * 1.8))
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - PostGridCell (legacy / reel 等仍用)
struct PostGridCell: View {
    let draft: DraftItem
    var onTap: () -> Void

    private var mileageFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "0 km" : String(format: "%.1f km", km)
    }
    private static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    PostGridCellBackground(draft: draft)
                    Image(systemName: "map.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(6)
                    LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                        .frame(height: geo.size.height * 0.55)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(draft.title.isEmpty ? "Route" : draft.title)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        HStack(spacing: 6) {
                            Text(Self.dateFormatter.string(from: draft.createdAt))
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.85))
                            Text("·")
                                .foregroundStyle(.white.opacity(0.6))
                            Text(mileageFormatted)
                                .font(.system(size: 9, weight: .medium, design: .monospaced))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()
        }
        .buttonStyle(.plain)
    }
}

struct PostGridCellBackground: View {
    let draft: DraftItem

    var body: some View {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        Group {
            if coords.count >= 2 {
                Map(initialPosition: .region(region), interactionModes: []) {
                    MapPolyline(coordinates: coords)
                        .stroke(ProfileTheme.accent, lineWidth: 3)
                }
                .mapStyle(.standard(elevation: .flat))
            } else {
                LinearGradient(colors: [Color(hex: "161C2C"), ProfileTheme.background], startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: "map")
                    .font(.system(size: 28))
                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.5))
            }
        }
    }

    private var region: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let center = CLLocationCoordinate2D(latitude: (lats.min()! + lats.max()!) / 2, longitude: (lons.min()! + lons.max()!) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max(0.02, (lats.max()! - lats.min()!) * 1.8), longitudeDelta: max(0.02, (lons.max()! - lons.min()!) * 1.8))
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - 全寬高級卡片（全屏背景圖 + 藍/橘標籤，Liked/Saved 列表用）
fileprivate struct ProfileFullWidthJourneyCard: View {
    let imageURL: String?
    let title: String
    let tagText: String
    let tagColor: Color
    private let cornerRadius: CGFloat = 20
    private static let fallbackURL = "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageURL ?? Self.fallbackURL)) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                case .failure, .empty:
                    AsyncImage(url: URL(string: Self.fallbackURL)) { p in
                        if let i = p.image { i.resizable().scaledToFill() }
                        else { Rectangle().fill(ProfileTheme.cardBg) }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                @unknown default:
                    Rectangle().fill(ProfileTheme.cardBg)
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 6) {
                Text(tagText)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundStyle(tagColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.5))
                    .clipShape(Capsule())
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(Color.white.opacity(0.08), lineWidth: 1))
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - 卡片分類標籤（JOURNEY / TRACK / LIVE，與右上角圖標水平對齊）
fileprivate enum ProfileInsStyleCardCategory {
    case journey  // Grand Journey → 社區詳情
    case track    // Detailed Track → 軌跡導航
    case live     // Live Activity → 紅色/小紅點

    var tagText: String {
        switch self {
        case .journey: return "JOURNEY"
        case .track: return "TRACK"
        case .live: return "LIVE"
        }
    }

    var isLive: Bool { self == .live }
}

// MARK: - Ins 風格畫廊卡片（滿格圖、圓角陰影、底部漸層+白字標題、角標、多圖輪播標識、左上角分類標籤）
fileprivate struct ProfileInsStyleCard: View {
    let imageURL: String?
    let title: String
    let iconKind: IconKind
    /// 圖片數量 > 1 時右上角顯示 square.on.square 輪播標識
    var imageCount: Int = 1
    /// 分類標籤：JOURNEY / TRACK / LIVE，左上角膠囊顯示
    var category: ProfileInsStyleCardCategory = .journey

    enum IconKind {
        case heart
        case bookmark
    }

    private let cornerRadius: CGFloat = 12
    /// 無圖時使用預設露營風景，禁止死黑
    private static let fallbackURL = "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800"

    var body: some View {
        GeometryReader { geo in
            let gradientHeight = geo.size.height * 0.40
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: imageURL ?? Self.fallbackURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        AsyncImage(url: URL(string: Self.fallbackURL)) { fallbackPhase in
                            if let img = fallbackPhase.image {
                                img.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle()
                                    .fill(ProfileTheme.cardBg)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    @unknown default:
                        Rectangle()
                            .fill(ProfileTheme.cardBg)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.35), .black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: gradientHeight)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .padding(.trailing, 32)

                // 頂行：左上角分類標籤 + 右側多圖標識與 Like/Save 圖標（水平對齊）
                VStack {
                    HStack(alignment: .center, spacing: 6) {
                        Text(category.tagText)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(category.isLive ? Color(hex: "EF4444") : .white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        Spacer(minLength: 0)
                        if imageCount > 1 {
                            Image(systemName: "square.on.square")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.35), radius: 1, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
                        }
                        Image(systemName: iconKind == .heart ? "heart.fill" : "bookmark.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(ProfileTheme.accent.opacity(0.8))
                            .padding(6)
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    Spacer()
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(ProfileTheme.borderStroke.opacity(0.5), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Saved collection row (blurred cover)
struct SavedCollectionRow: View {
    let collection: ProfileCollection

    var body: some View {
        ZStack(alignment: .leading) {
            CollectionCoverThumbnail(coverImageIdentifier: collection.coverImageIdentifier)
                .frame(height: 88)
                .blur(radius: 12)
                .overlay(Color.black.opacity(0.5))
            HStack(spacing: 14) {
                CollectionCoverThumbnail(coverImageIdentifier: collection.coverImageIdentifier)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text(collection.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                    Text("\(collection.draftIds.count) routes")
                        .font(.system(size: 13))
                        .foregroundStyle(ProfileTheme.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Month grouping for My Trip (Year-Month, descending; English locale)
struct MyTripMonthGroup: Identifiable {
    let id: String
    let title: String
    let trips: [DraftItem]
    let totalDistanceMeters: Double
    let totalElevationMeters: Double
    var tripCount: Int { trips.count }

    static func groups(from drafts: [DraftItem]) -> [MyTripMonthGroup] {
        let completed = drafts.filter { $0.source == .liveRecorded || $0.source == .imported }
        guard !completed.isEmpty else { return [] }
        let cal = Calendar.current
        var byMonth: [String: [DraftItem]] = [:]
        for draft in completed {
            let comps = cal.dateComponents([.year, .month], from: draft.createdAt)
            let key = "\(comps.year ?? 0)-\(comps.month ?? 0)"
            byMonth[key, default: []].append(draft)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return byMonth
            .map { key, list in
                let sorted = list.sorted { $0.createdAt > $1.createdAt }
                let totalDist = sorted.reduce(0.0) { $0 + $1.totalDistanceMeters }
                let totalElev = sorted.reduce(0.0) { $0 + $1.elevationGainMeters }
                let first = sorted.first?.createdAt ?? Date()
                let title = formatter.string(from: first)
                return MyTripMonthGroup(id: key, title: title, trips: sorted, totalDistanceMeters: totalDist, totalElevationMeters: totalElev)
            }
            .sorted { $0.id > $1.id }
    }
}

// MARK: - Sticky section header: [Month] [Year] + Total Miles | Total Elevation | Count of Trips
struct MyTripMonthHeader: View {
    let title: String
    let totalDistanceMeters: Double
    let totalElevationMeters: Double
    let tripCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(ProfileTheme.textPrimary)
                Text(summaryText)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ProfileTheme.cardBg.opacity(0.85))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(ProfileTheme.textMuted.opacity(0.2))
                .frame(height: 1)
        }
    }

    private var summaryText: String {
        let mi = totalDistanceMeters / 1609.34
        let miStr = String(format: "%.1f mi", mi)
        let ft = totalElevationMeters * 3.28084
        let ftStr = String(format: "%.0f ft", ft)
        let countStr = tripCount == 1 ? "1 Trip" : "\(tripCount) Trips"
        return "\(miStr) | \(ftStr) | \(countStr)"
    }
}

// MARK: - My Trip card: route polyline/photo background, stats (Distance · Gain · Duration), source badge
struct MyTripCard: View {
    let draft: DraftItem

    private var sourceLabel: String {
        switch draft.source {
        case .liveRecorded: return "App Record"
        case .imported: return "Imported GPX"
        default: return draft.source.tagLabel
        }
    }

    private var sourceIcon: String {
        switch draft.source {
        case .liveRecorded: return "iphone"
        case .imported: return "square.and.arrow.down.fill"
        default: return "map.fill"
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ProfileFeedCardBackground(draft: draft)
                .frame(height: 200)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                .frame(height: 200)

            VStack(alignment: .leading, spacing: 8) {
                Text(draft.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 14) {
                    Label(formattedDate(draft.createdAt), systemImage: "calendar")
                    Label(formatDistanceMiles(draft.totalDistanceMeters), systemImage: "location.fill")
                    Label(formatElevationFeet(draft.elevationGainMeters), systemImage: "arrow.up.right")
                    if let dur = formattedDuration(draft.durationSeconds) {
                        Label(dur, systemImage: "clock")
                    }
                }
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.95))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)

            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: sourceIcon)
                            .font(.system(size: 10))
                        Text(sourceLabel)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial.opacity(0.8), in: Capsule())
                    .padding(12)
                }
                Spacer()
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    private func formattedDate(_ date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }

    private func formattedDuration(_ seconds: Double?) -> String? {
        guard let sec = seconds, sec >= 0 else { return nil }
        let total = Int(sec)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        if minutes > 0 { return "\(minutes)m" }
        return "\(total)s"
    }

    private func formatDistanceMiles(_ meters: Double) -> String {
        let miles = meters / 1609.34
        if miles < 0.1 { return String(format: "%.0f ft", meters * 3.28084) }
        if miles < 1 { return String(format: "%.2f mi", miles) }
        return String(format: "%.1f mi", miles)
    }

    private func formatElevationFeet(_ meters: Double) -> String {
        let feet = meters * 3.28084
        return String(format: "%.0f ft", feet)
    }
}

// MARK: - My Trip empty state: professional placeholder (no big Record button)
struct MyTripEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Your expedition history is empty.")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(ProfileTheme.textPrimary)
                .multilineTextAlignment(.center)
            Text("Complete a route to see your stats here.")
                .font(.system(size: 15))
                .foregroundStyle(ProfileTheme.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 56)
        .padding(.horizontal, 28)
    }
}

// MARK: - Liked grid cell (kept for possible reuse elsewhere)
struct LikedGridCell: View {
    let item: LikedRouteItem
    let draft: DraftItem?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let d = draft {
                PostGridCellBackground(draft: d)
            } else if let url = item.imageUrl, let u = URL(string: url) {
                AsyncImage(url: u) { phase in
                    if let img = phase.image {
                        img.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(ProfileTheme.cardBg)
                        Image(systemName: "heart.fill")
                            .foregroundStyle(ProfileTheme.textMuted.opacity(0.5))
                    }
                }
            } else {
                Rectangle().fill(ProfileTheme.cardBg)
                Image(systemName: "heart.fill")
                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.5))
            }
            Image(systemName: "heart.fill")
                .font(.system(size: 12))
                .foregroundStyle(ProfileTheme.accent)
                .padding(6)
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }
}

// MARK: - Full-screen Reel/Post (IG-style: map, photos, comments)
struct PostReelFullScreenView: View {
    let draft: DraftItem
    let onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    mapSection
                    photosSection
                    commentsSection
                }
            }
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 4)
            }
            .padding(20)
        }
        .preferredColorScheme(.dark)
    }

    private var mapSection: some View {
        ZStack(alignment: .bottomLeading) {
            ProfileFeedCardBackground(draft: draft)
                .frame(height: 280)
            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .frame(height: 280)
            VStack(alignment: .leading, spacing: 6) {
                Text(draft.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                HStack(spacing: 16) {
                    Label("\(formatMi(draft.totalDistanceMeters)) mi", systemImage: "location.fill")
                    Label("\(Int(draft.elevationGainMeters)) m", systemImage: "arrow.up.right")
                }
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.white.opacity(0.95))
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Photos")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ProfileTheme.textPrimary)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ProfileTheme.cardBg)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "photo.stack")
                                .font(.system(size: 32))
                                .foregroundStyle(ProfileTheme.textMuted.opacity(0.5))
                        )
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 8)
        }
    }

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Community")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ProfileTheme.textPrimary)
            VStack(alignment: .leading, spacing: 8) {
                mockComment("Nice route! Where did you start?")
                mockComment("That elevation gain 💪")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }

    private func mockComment(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(ProfileTheme.textMuted)
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(ProfileTheme.textPrimary)
            Spacer()
        }
        .padding(12)
        .background(ProfileTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func formatMi(_ meters: Double) -> String {
        let mi = meters / 1609.34
        return String(format: "%.1f", mi)
    }
}

// MARK: - Feed card (large image-style background + floating stats)
struct ProfileFeedCard: View {
    let draft: DraftItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background: map or gradient (route as “prettiest” visual)
            ProfileFeedCardBackground(draft: draft)
                .frame(height: 200)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                .frame(height: 200)

            VStack(alignment: .leading, spacing: 8) {
                Text(draft.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                        Text(formatDistanceMiles(draft.totalDistanceMeters))
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                    }
                    .foregroundStyle(.white.opacity(0.95))
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                        Text(formatElevationFeet(draft.elevationGainMeters))
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                    }
                    .foregroundStyle(.white.opacity(0.95))
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "2D3033").opacity(0.5), lineWidth: 1)
        )
    }

    private func formatDistanceMiles(_ meters: Double) -> String {
        let miles = meters / 1609.34
        if miles < 0.1 { return String(format: "%.0f ft", meters * 3.28084) }
        if miles < 1 { return String(format: "%.2f mi", miles) }
        return String(format: "%.1f mi", miles)
    }

    private func formatElevationFeet(_ meters: Double) -> String {
        let feet = meters * 3.28084
        return String(format: "%.0f ft", feet)
    }
}

// MARK: - Card background (map with route polyline or gradient fallback)
struct ProfileFeedCardBackground: View {
    let draft: DraftItem

    var body: some View {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        Group {
            if coords.count >= 2 {
                Map(initialPosition: .region(region), interactionModes: []) {
                    MapPolyline(coordinates: coords)
                        .stroke(ProfileTheme.accent, lineWidth: 4)
                }
                .mapStyle(.standard)
            } else {
                LinearGradient(
                    colors: [Color(hex: "161C2C"), Color(hex: "050A18")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "map.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white.opacity(0.3))
            }
        }
    }

    private var region: MKCoordinateRegion {
        let coords = draft.polyline2D ?? draft.coordinate2DPoints
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.5), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        let lats = coords.map(\.latitude)
        let lons = coords.map(\.longitude)
        let center = CLLocationCoordinate2D(latitude: (lats.min()! + lats.max()!) / 2, longitude: (lons.min()! + lons.max()!) / 2)
        let span = MKCoordinateSpan(latitudeDelta: max(0.02, (lats.max()! - lats.min()!) * 1.6), longitudeDelta: max(0.02, (lons.max()! - lons.min()!) * 1.6))
        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - Magic Path glow (faint graphic behind avatar)
struct MagicPathGlowGraphic: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [ProfileTheme.accent.opacity(0.4), ProfileTheme.accent.opacity(0.1), .clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 70
                    )
                )
            Path { p in
                let r: CGFloat = 50
                p.addArc(center: CGPoint(x: 70, y: 70), radius: r, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: false)
                p.move(to: CGPoint(x: 70 + r, y: 70))
                p.addLine(to: CGPoint(x: 70 + r * 0.8, y: 70 - r * 0.3))
            }
            .stroke(ProfileTheme.accent.opacity(0.35), lineWidth: 4)
        }
    }
}

// MARK: - View Achievements entry card with progress ring → Honor Center (legacy)
struct ViewAchievementsCard: View {
    private var progress: (unlocked: Int, total: Int) { AchievementStore.progressCounts() }

    var body: some View {
        NavigationLink(value: HonorCenterDestination()) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(ProfileTheme.textMuted.opacity(0.3), lineWidth: 4)
                        .frame(width: 52, height: 52)
                    Circle()
                        .trim(from: 0, to: total > 0 ? CGFloat(unlocked) / CGFloat(total) : 0)
                        .stroke(ProfileTheme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 52, height: 52)
                        .rotationEffect(.degrees(-90))
                    Text("\(unlocked)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                }
                        VStack(alignment: .leading, spacing: 2) {
                    Text("View Achievements")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                    Text("\(unlocked) of \(total) unlocked")
                        .font(.system(size: 13))
                        .foregroundStyle(ProfileTheme.textMuted)
                        }
                        Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textMuted)
            }
            .padding(16)
            .background(ProfileTheme.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var unlocked: Int { progress.unlocked }
    private var total: Int { progress.total }
}

// MARK: - Achievement shelf (top 5, frosted glass, glowing border when unlocked) – kept for reference
struct AchievementShelfView: View {
    var onSelect: (Achievement) -> Void
    private var achievements: [Achievement] { AchievementStore.topFiveAchievements() }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    Button {
                        onSelect(achievement)
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 56, height: 56)
                                if achievement.isUnlocked {
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(
                                            LinearGradient(
                                                colors: [ProfileTheme.accent.opacity(0.9), ProfileTheme.accent.opacity(0.4)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                        .frame(width: 56, height: 56)
                                } else {
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(ProfileTheme.textMuted.opacity(0.4), lineWidth: 1)
                                        .frame(width: 56, height: 56)
                                }
                                Image(systemName: achievement.iconAssetName)
                                    .font(.system(size: 24))
                                    .foregroundStyle(achievement.isUnlocked ? ProfileTheme.accent : ProfileTheme.textMuted.opacity(0.7))
                            }
                            Text(achievement.title)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(ProfileTheme.textMuted)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: 72)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 92)
    }
}

// MARK: - Badge detail modal (details + share button)
struct BadgeDetailModal: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 100, height: 100)
                    if achievement.isUnlocked {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(ProfileTheme.accent.opacity(0.8), lineWidth: 2)
                            .frame(width: 100, height: 100)
                    }
                    Image(systemName: achievement.iconAssetName)
                        .font(.system(size: 44))
                        .foregroundStyle(achievement.isUnlocked ? ProfileTheme.accent : ProfileTheme.textMuted)
                }
                VStack(spacing: 8) {
                    Text(achievement.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                    Text(achievement.description)
                        .font(.system(size: 15))
                        .foregroundStyle(ProfileTheme.textMuted)
                        .multilineTextAlignment(.center)
                    if let date = achievement.unlockedDate {
                        Text("Unlocked \(date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(size: 13))
                            .foregroundStyle(ProfileTheme.accent)
                    } else {
                        Text("Locked")
                            .font(.system(size: 13))
                            .foregroundStyle(ProfileTheme.textMuted)
                    }
                }
                Button {
                    let text = achievement.isUnlocked
                        ? "I unlocked \"\(achievement.title)\" on HikBik!"
                        : "Check out the \"\(achievement.title)\" badge on HikBik."
                    UIPasteboard.general.string = text
                    dismiss()
                        } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share badge")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(ProfileTheme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ProfileTheme.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(ProfileTheme.background)
            .navigationTitle("Badge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(ProfileTheme.accent)
                }
            }
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Follow list sheet (Following / Followers with mini-avatars)
struct FollowListSheet: View {
    fileprivate let mode: FollowListMode
    let userIds: [String]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if userIds.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: mode == .followers ? "person.2.slash" : "person.crop.circle.badge.minus")
                            .font(.system(size: 40))
                            .foregroundStyle(ProfileTheme.textMuted.opacity(0.9))
                        Text(mode == .followers ? "No followers yet" : "Not following anyone yet")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(ProfileTheme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ProfileTheme.background)
                } else {
                    List {
                        ForEach(userIds, id: \.self) { userId in
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.8))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(userId)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(ProfileTheme.textPrimary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(ProfileTheme.cardBg)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(ProfileTheme.background)
                }
            }
            .navigationTitle(mode == .followers ? "Followers" : "Following")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(ProfileTheme.accent)
                }
            }
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Share profile sheet (placeholder: copy link / share to Instagram, WhatsApp)
struct ShareProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Share your profile to Instagram, WhatsApp, or copy link.")
                    .font(.system(size: 15))
                    .foregroundStyle(ProfileTheme.textMuted)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Copy profile link") {
                    UIPasteboard.general.string = "https://hikbik.app/profile"
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(ProfileTheme.accent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ProfileTheme.background)
            .navigationTitle("Share profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(ProfileTheme.accent)
                }
            }
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Collection cover thumbnail (from route photos / photo library)
struct CollectionCoverThumbnail: View {
    let coverImageIdentifier: String?
    @State private var loadedImage: UIImage?

    var body: some View {
        Group {
            if let img = loadedImage {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let id = coverImageIdentifier {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ProfileTheme.cardBg)
                    .onAppear { loadAsset(id) }
                } else {
                Image(systemName: "folder.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(ProfileTheme.accentSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ProfileTheme.cardBg)
            }
        }
    }

    private func loadAsset(_ localId: String) {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
        guard let asset = result.firstObject else { return }
        let size = CGSize(width: 168, height: 168)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { img, _ in
            DispatchQueue.main.async { loadedImage = img }
        }
    }
}

// MARK: - Create collection sheet (name + optional cover from photo library)
struct CreateCollectionSheet: View {
    @Binding var name: String
    @Binding var coverIdentifier: String?
    let onCreate: () -> Void
    let onCancel: () -> Void
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Folder name")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textMuted)
                TextField("e.g. 2026 Summer Canyoning", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                Text("Cover image (from your photos)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textMuted)
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    HStack(spacing: 10) {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text(selectedPhotoItem == nil ? "Choose cover from route photos" : "Cover selected")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundStyle(ProfileTheme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(ProfileTheme.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .onChange(of: selectedPhotoItem) { _, new in
                    if let id = new?.itemIdentifier { coverIdentifier = id } else { coverIdentifier = nil }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ProfileTheme.background)
            .navigationTitle("New collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                        .foregroundStyle(ProfileTheme.textMuted)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { onCreate() }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(ProfileTheme.accent)
                }
            }
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Collection detail (list of drafts in folder + add route)
struct CollectionDetailView: View {
    let collection: ProfileCollection
    @Environment(\.dismiss) private var dismiss
    @State private var drafts: [DraftItem] = []
    @State private var collectionDraftIds: [UUID] = []
    @State private var showAddRoute = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                        Button {
                    showAddRoute = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add route")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(ProfileTheme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(ProfileTheme.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                LazyVStack(spacing: 16) {
                    ForEach(drafts) { draft in
                        NavigationLink(value: draft) {
                            ProfileFeedCard(draft: draft)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ProfileTheme.background)
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") { dismiss() }
                    .foregroundStyle(ProfileTheme.textMuted)
            }
        }
        .toolbarBackground(ProfileTheme.background, for: .navigationBar)
        .onAppear { reloadDrafts() }
        .sheet(isPresented: $showAddRoute) {
            AddRouteToCollectionSheet(collectionId: collection.id, currentDraftIds: collectionDraftIds) {
                reloadDrafts()
                showAddRoute = false
            } onCancel: {
                showAddRoute = false
            }
        }
        .preferredColorScheme(.dark)
    }

    private func reloadDrafts() {
        collectionDraftIds = ProfileCollectionsStore.loadAll().first(where: { $0.id == collection.id })?.draftIds ?? []
        let all = TrackDataManager.shared.allTracks
        drafts = collectionDraftIds.compactMap { id in all.first { $0.id == id } }.sorted { $0.createdAt > $1.createdAt }
    }
}

// MARK: - Add route to collection (pick from all drafts)
struct AddRouteToCollectionSheet: View {
    let collectionId: UUID
    let currentDraftIds: [UUID]
    let onAdd: () -> Void
    let onCancel: () -> Void
    @State private var allDrafts: [DraftItem] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(allDrafts) { draft in
                    let isInCollection = currentDraftIds.contains(draft.id)
                    Button {
                        if isInCollection { return }
                        ProfileCollectionsStore.addDraft(draft.id, toCollectionId: collectionId)
                        onAdd()
                        } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(draft.title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(ProfileTheme.textPrimary)
                                Text(draft.source.tagLabel)
                                    .font(.system(size: 12))
                                    .foregroundStyle(ProfileTheme.textMuted)
                            }
                            Spacer()
                            if isInCollection {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(ProfileTheme.accent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .disabled(isInCollection)
                    .listRowBackground(ProfileTheme.cardBg)
                }
            }
            .scrollContentBackground(.hidden)
            .background(ProfileTheme.background)
            .navigationTitle("Add route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                        .foregroundStyle(ProfileTheme.textMuted)
                }
            }
            .toolbarBackground(ProfileTheme.background, for: .navigationBar)
            .onAppear { allDrafts = TrackDataManager.shared.allTracks.sorted { $0.createdAt > $1.createdAt } }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserState())
        .environmentObject(UserProfileViewModel.shared)
        .environmentObject(CurrentUser())
        .environmentObject(CommunityViewModel())
        .environmentObject(TrackDataManager.shared)
}
