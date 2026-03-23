// MARK: - User Profile — 點擊卡片作者頭像/名字跳轉的個人主頁
import SwiftUI

/// 作者名片頁：接收作者 ID 與基本資料（或 CommunityAuthor），用於從 Community 卡片跳轉；數據來自當前點擊的 post.author。
struct UserProfileView: View {
    let authorId: String
    let displayName: String
    let avatarURL: String?
    let subtitle: String?

    @EnvironmentObject private var socialManager: SocialManager

    private let accentOrange = Color(hex: "FF8C42")

    init(authorId: String, displayName: String, avatarURL: String? = nil, subtitle: String? = nil) {
        self.authorId = authorId
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.subtitle = subtitle
    }

    init(user: CommunityAuthor, subtitle: String? = nil) {
        self.authorId = user.id
        self.displayName = user.displayName
        self.avatarURL = user.avatarURL
        self.subtitle = subtitle
    }

    private let bg = Color(hex: "0B121F")
    private let card = Color(hex: "1A2332")
    private let textPrimary = Color.white
    private let textMuted = Color(hex: "9CA3AF")

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let urlString = avatarURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let img = phase.image { img.resizable().scaledToFill() }
                        else { Image(systemName: "person.circle.fill").font(.system(size: 80)).foregroundStyle(textMuted) }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(textMuted)
                }
                Text(displayName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(textPrimary)
                // 粉絲數優先從 SocialManager 讀取，才能隨 Follow 即時跳動
                let followersCount = socialManager.users[authorId]?.followersCount
                let fallbackSubtitle = subtitle ?? ""
                if let count = followersCount {
                    Text("\(count) followers")
                        .font(.system(size: 14))
                        .foregroundStyle(textMuted)
                        .contentTransition(.numericText())
                } else if !fallbackSubtitle.isEmpty {
                    Text(fallbackSubtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(textMuted)
                }
                if authorId != socialManager.currentUserId {
                    let isFollowing = socialManager.users[authorId]?.isFollowing ?? false
                    Button {
                        AuthGuard.run(message: AuthGuardMessages.followUser) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            socialManager.toggleFollow(for: authorId, currentUserId: socialManager.currentUserId)
                        }
                    } label: {
                        Text(isFollowing ? "Following" : "Follow")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isFollowing ? textMuted : .white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(isFollowing ? Color.white.opacity(0.2) : accentOrange)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFollowing)
                    .padding(.top, 8)
                }
                Text("Posts & liked journeys will show here.")
                    .font(.system(size: 14))
                    .foregroundStyle(textMuted)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bg)
        .navigationTitle(displayName)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            if socialManager.users[authorId] == nil {
                let initialFollowers = subtitle.flatMap { s in Int(s.split(separator: " ").first ?? Substring("")) } ?? 0
                socialManager.ensureUser(id: authorId, username: displayName, initialFollowersCount: initialFollowers)
            }
        }
    }
}
