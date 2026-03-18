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

struct ProfileView: View {
    @EnvironmentObject private var userState: UserState
    @EnvironmentObject private var currentUser: CurrentUser
    @EnvironmentObject private var communityViewModel: CommunityViewModel
    @EnvironmentObject private var trackDataManager: TrackDataManager
    @State private var userName: String = UserDefaults.standard.string(forKey: "hikbik_user_name") ?? ""
    @State private var isLoggedIn: Bool = (UserDefaults.standard.data(forKey: "hikbik_user") != nil)
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

    private let followingCount = 12
    private let followersCount = 48
    private let bio = "Peak hunter based in Zurich | 🏔️ 30+ Summits"

    /// Display name: registered → "Adventurer"; else stored name or "Explorer"
    private var displayName: String {
        userState.isRegistered ? "Adventurer" : (userName.isEmpty ? "Explorer" : userName)
    }

    var body: some View {
        NavigationStack {
            Group {
                if userState.isGuest {
                    guestJoinHIKBIKContent
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            socialHeaderSection
                            ProStatsDashboardCard()
                            threeTabSection
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
                loadData()
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
                FollowListSheet(mode: followListMode)
            }
            .navigationDestination(for: DraftItem.self) { draft in
                if trackDataManager.publishedTracks.contains(where: { $0.id == draft.id }) {
                    ManualJourneyDetailView(journey: draft.toManualJourney())
                } else if draft.isEditable {
                    CustomRouteBuilderView(liveTrackDraft: LiveTrackDraft.from(draftItem: draft))
                } else {
                    LiveTrackDetailView(draft: draft)
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
                    if userState.isGuest {
                        Button("Sign In") {
                            userState.showLandingFromApp = true
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(ProfileTheme.accent)
                    } else if isLoggedIn {
                        Button("Sign Out") {
                            UserDefaults.standard.removeObject(forKey: "hikbik_user")
                            UserDefaults.standard.removeObject(forKey: "hikbik_user_name")
                            isLoggedIn = false
                            userName = ""
                        }
                        .font(.system(size: 15))
                        .foregroundStyle(ProfileTheme.textMuted)
                    } else {
                        Button("Sign In") {
                            userState.showLandingFromApp = true
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(ProfileTheme.accent)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "hikbik_user"),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let name = json["name"] as? String {
            userName = name
            isLoggedIn = true
        }
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
                    userState.showLandingFromApp = true
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
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(ProfileTheme.textMuted.opacity(0.9))
            }

            Text(userState.isGuest ? "Guest" : displayName)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(ProfileTheme.textPrimary)

            HStack(spacing: 24) {
                Button {
                    followListMode = .following
                    showFollowList = true
                } label: {
                    VStack(spacing: 2) {
                        Text("\(followingCount)")
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
                        Text("\(followersCount)")
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

            Text(bio)
                .font(.system(size: 14))
                .foregroundStyle(ProfileTheme.textMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

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
                        Text(tab.label)
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
        let posts = trackDataManager.publishedTracks
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
                        profilePostRow(draft: draft)
                    }
                }
                .id(trackDataManager.publishedTracks.count)
                .padding(.horizontal, 20)
            }
        }
    }

    @ViewBuilder
    private func profilePostRow(draft: DraftItem) -> some View {
        switch draft.category {
        case .grandJourney:
            NavigationLink {
                CommunityMacroDetailView(
                    journey: draft.communityJourneyForMacroDetail(),
                    journeyId: draft.id.uuidString,
                    coverImageData: draft.coverImageData
                )
            } label: {
                ProfileGrandJourneyCard(draft: draft)
            }
            .buttonStyle(.plain)
        case .detailedTrack:
            NavigationLink {
                ManualJourneyDetailView(journey: draft.toManualJourney())
            } label: {
                ProfileDetailedTrackCard(draft: draft)
            }
            .buttonStyle(.plain)
        case .livelyActivity:
            NavigationLink {
                ActivityDetailView(draft: draft)
            } label: {
                ProfileLivelyActivityCard(draft: draft)
            }
            .buttonStyle(.plain)
        }
    }

    /// Saved 標籤：先顯示「已收藏貼文」（來自 CurrentUser.savedPostIds），再顯示「收藏夾」
    private var savedTabContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            savedPostsSection
            savedCollectionsSection
        }
    }

    /// 已收藏貼文：id "1" = Sarah Utah，published_* = 我發布的；綁定 currentUser.savedPostIds，即時刷新
    private var savedPostsSection: some View {
        let items: [SavedPostItem] = currentUser.savedPostIds.compactMap { id in
            if let journey = CommunityViewModel.journey(forPostId: id) {
                return SavedPostItem(id: id, journey: journey)
            }
            guard id.hasPrefix("published_"),
                  let idx = Int(id.replacingOccurrences(of: "published_", with: "")),
                  idx >= 0, idx < communityViewModel.publishedPosts.count else { return nil }
            return SavedPostItem(id: id, journey: communityViewModel.publishedPosts[idx])
        }
        return Group {
            if !items.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Saved posts")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(ProfileTheme.textPrimary)
                        .padding(.horizontal, 20)
                    LazyVStack(spacing: 12) {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                HStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ProfileTheme.cardBg)
                                        .frame(width: 56, height: 56)
                                        .overlay(Image(systemName: "bookmark.fill").foregroundStyle(ProfileTheme.accent))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.journey.journeyName)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(ProfileTheme.textPrimary)
                                            .lineLimit(1)
                                        Text(item.journey.author?.displayName ?? "Community")
                                            .font(.system(size: 13))
                                            .foregroundStyle(ProfileTheme.textMuted)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(ProfileTheme.textMuted)
                                }
                                .padding(14)
                                .background(ProfileTheme.cardBg)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                        }
                    }
                    .scrollDisabled(true)
                }
            }
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

    /// Liked: resolve CurrentUser.likedPostIds；id "1" = Sarah Utah，published_* = 我發布的貼文；點擊 Push 至 CommunityMacroDetailView。
    private var likedPostsSection: some View {
        let items: [LikedPostItem] = currentUser.likedPostIds.compactMap { id in
            if let journey = CommunityViewModel.journey(forPostId: id) {
                return LikedPostItem(id: id, journey: journey)
            }
            guard id.hasPrefix("published_"),
                  let idx = Int(id.replacingOccurrences(of: "published_", with: "")),
                  idx >= 0, idx < communityViewModel.publishedPosts.count else { return nil }
            return LikedPostItem(id: id, journey: communityViewModel.publishedPosts[idx])
        }
        return Group {
            if items.isEmpty {
                Text("No liked journeys yet. Like posts in Community to see them here.")
                    .font(.system(size: 15))
                    .foregroundStyle(ProfileTheme.textMuted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
                    .padding(.horizontal, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ProfileTheme.cardBg)
                                    .frame(width: 56, height: 56)
                                    .overlay(Image(systemName: "map.fill").foregroundStyle(ProfileTheme.textMuted))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.journey.journeyName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(ProfileTheme.textPrimary)
                                        .lineLimit(1)
                                    Text(item.journey.author?.displayName ?? "Community")
                                        .font(.system(size: 13))
                                        .foregroundStyle(ProfileTheme.textMuted)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(ProfileTheme.textMuted)
                            }
                            .padding(14)
                            .background(ProfileTheme.cardBg)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                }
                .scrollDisabled(true)
            }
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

// MARK: - Profile 微觀卡片（精簡專業，與宏觀區分）
struct ProfileDetailedTrackCard: View {
    let draft: DraftItem
    private var mileageFormatted: String {
        let km = draft.totalDistanceMeters / 1000
        return km < 0.01 ? "—" : String(format: "%.1f km", km)
    }
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "1E3A5F").opacity(0.6))
                if let coverData = draft.coverImageData, let ui = UIImage(data: coverData) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProfileMiniCardThumbnail(draft: draft)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color(hex: "3B82F6").opacity(0.5), lineWidth: 1))
            VStack(alignment: .leading, spacing: 6) {
                Text("DETAILED TRACK")
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(Color(hex: "60A5FA"))
                Text(draft.title.isEmpty ? "Micro route" : draft.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(ProfileTheme.textPrimary)
                    .lineLimit(2)
                Text(mileageFormatted)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
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
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: "3B82F6").opacity(0.15), lineWidth: 1))
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
    @Environment(\.dismiss) private var dismiss

    private static let mockUsers: [(name: String, handle: String)] = [
        ("Alex Trail", "@alex_trail"), ("Jordan Peak", "@jordan_peak"), ("Sam Ridge", "@sam_ridge"),
        ("Casey Summit", "@casey_summit"), ("Morgan Woods", "@morgan_woods"), ("Riley Creek", "@riley_creek"),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(Self.mockUsers.enumerated()), id: \.offset) { _, u in
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(ProfileTheme.textMuted.opacity(0.8))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(u.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(ProfileTheme.textPrimary)
                            Text(u.handle)
                                .font(.system(size: 13))
                                .foregroundStyle(ProfileTheme.textMuted)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(ProfileTheme.cardBg)
                }
            }
            .scrollContentBackground(.hidden)
            .background(ProfileTheme.background)
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

#Preview { ProfileView().environmentObject(UserState()).environmentObject(CurrentUser()).environmentObject(CommunityViewModel()).environmentObject(TrackDataManager.shared) }
