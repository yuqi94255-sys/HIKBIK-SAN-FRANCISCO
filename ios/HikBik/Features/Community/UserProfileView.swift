// MARK: - User Profile — 點擊卡片作者頭像/名字跳轉的個人主頁
import SwiftUI

/// 作者名片頁：接收作者 ID 與基本資料（或 CommunityAuthor），用於從 Community 卡片跳轉；數據來自當前點擊的 post.author。
struct UserProfileView: View {
    let authorId: String
    let displayName: String
    let avatarURL: String?
    let subtitle: String?

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
                if let sub = subtitle, !sub.isEmpty {
                    Text(sub)
                        .font(.system(size: 14))
                        .foregroundStyle(textMuted)
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
    }
}
