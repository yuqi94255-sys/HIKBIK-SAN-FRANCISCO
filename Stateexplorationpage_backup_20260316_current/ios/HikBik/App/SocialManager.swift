// MARK: - Social Manager — 全局社交狀態（用戶、關注數、關注關係），模擬 API 延遲
import SwiftUI
import Combine

// MARK: - User 模型
/// 用戶數據：用於 SocialManager 的存儲與關注邏輯。isFollowing 表示「當前登錄用戶是否關注了該用戶」。
struct User: Identifiable, Equatable {
    let id: String
    var username: String
    var followersCount: Int
    var followingCount: Int
    var isFollowing: Bool
}

// MARK: - Social Manager
/// 全局社交狀態管理：存儲所有用戶，並提供模擬的關注/取關邏輯（0.5s 延遲）。
final class SocialManager: ObservableObject {
    @Published var users: [String: User] = [:]

    /// 當前登錄用戶的 ID，用於 toggleFollow(for:currentUserId:)。
    let currentUserId: String = "current_user"

    init() {
        // Mock：當前用戶 + 社區作者，方便 UI 讀取初始狀態與測試
        let current = User(
            id: currentUserId,
            username: "Guest",
            followersCount: 0,
            followingCount: 0,
            isFollowing: false
        )
        let mockAuthors: [(id: String, name: String, followers: Int)] = [
            ("sarah-chen", "Sarah Chen", 339),
            ("emma-wilson", "Emma Wilson", 542),
            ("mike-rodriguez", "Mike Rodriguez", 0),
            ("alex-turner", "Alex Turner", 0),
            ("tom-wilson", "Tom Wilson", 234),
            ("jessica-martinez", "Jessica Martinez", 427),
            ("david-kim", "David Kim", 0),
            ("lauren-hughes", "Lauren Hughes", 0),
            ("chris-anderson", "Chris Anderson", 0),
            ("guest", "Guest", 0),
            ("alex", "Alex Explorer", 0),
        ]
        users[currentUserId] = current
        for a in mockAuthors {
            users[a.id] = User(
                id: a.id,
                username: a.name,
                followersCount: a.followers,
                followingCount: 0,
                isFollowing: false
            )
        }
    }

    /// 若 users 中尚無該 id，則寫入一筆 User（用於詳情/個人頁 onAppear 時補齊作者）。
    func ensureUser(id: String, username: String, initialFollowersCount: Int = 0) {
        guard users[id] == nil else { return }
        users[id] = User(
            id: id,
            username: username,
            followersCount: initialFollowersCount,
            followingCount: 0,
            isFollowing: false
        )
    }

    /// 列表/卡片 onAppear 時註冊作者，確保 socialManager.users 中有該用戶（便於後續動態顯示粉絲數與關注狀態）。
    func register(author: CommunityAuthor, initialFollowersCount: Int = 0) {
        ensureUser(id: author.id, username: author.displayName, initialFollowersCount: initialFollowersCount)
    }

    /// 模擬關注/取關：0.5 秒延遲後更新目標用戶的 followersCount、當前用戶的 followingCount、目標的 isFollowing。
    /// - Parameters:
    ///   - targetUserId: 被關注/取關的用戶 ID（與 CommunityAuthor.id 一致）
    ///   - currentUserId: 當前登錄用戶 ID
    func toggleFollow(for targetUserId: String, currentUserId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            guard var targetUser = self.users[targetUserId],
                  var currentUser = self.users[currentUserId] else { return }

            if targetUser.isFollowing {
                // 已關注 → 取關
                targetUser.followersCount = max(0, targetUser.followersCount - 1)
                currentUser.followingCount = max(0, currentUser.followingCount - 1)
                targetUser.isFollowing = false
            } else {
                // 未關注 → 關注
                targetUser.followersCount += 1
                currentUser.followingCount += 1
                targetUser.isFollowing = true
            }

            self.users[targetUserId] = targetUser
            self.users[currentUserId] = currentUser
        }
    }
}
