// MARK: - Current User — 喜歡、收藏、打卡、關注（模擬；接後端時替換為 API）
import SwiftUI

extension Notification.Name {
    /// 點讚或收藏變更後發送，userInfo: ["id": postId, "type": "like"|"save", "status": Bool]
    static let socialStatusChanged = Notification.Name("CurrentUser.socialStatusChanged")
}

private let currentUserLikedKey = "CurrentUser.likedPostIds"
private let currentUserSavedKey = "CurrentUser.savedPostIds"

/// 當前用戶的社交狀態：點讚、收藏、打卡、關注列表、顯示名稱。關注雙向同步由 mockFollowUser 模擬。點讚/收藏持久化到 UserDefaults。
final class CurrentUser: ObservableObject {
    @Published var likedPostIds: Set<String> = [] {
        didSet { persistLiked() }
    }
    @Published var savedPostIds: Set<String> = [] {
        didSet { persistSaved() }
    }
    @Published var completedJourneyIds: Set<String> = []
    @Published var displayName: String = "Guest"

    /// 我關注的人數（前端模擬，點 Follow 時 +1，Unfollow 時 -1）
    @Published var followingCount: Int = 0
    /// 我關注的用戶 ID 集合（用於 isFollowing、按鈕狀態）
    @Published var followingUserIds: Set<String> = []
    /// 模擬：被關注者的粉絲數 [targetUserId: count]，點 Follow 時目標 +1，Unfollow 時 -1
    @Published var mockFollowersCount: [String: Int] = [:]

    init() {
        loadLikedAndSaved()
    }

    private func loadLikedAndSaved() {
        if let arr = UserDefaults.standard.stringArray(forKey: currentUserLikedKey) {
            likedPostIds = Set(arr)
        }
        if let arr = UserDefaults.standard.stringArray(forKey: currentUserSavedKey) {
            savedPostIds = Set(arr)
        }
    }

    private func persistLiked() {
        UserDefaults.standard.set(Array(likedPostIds), forKey: currentUserLikedKey)
    }

    private func persistSaved() {
        UserDefaults.standard.set(Array(savedPostIds), forKey: currentUserSavedKey)
    }

    func toggleLike(postId: String) {
        if likedPostIds.contains(postId) {
            likedPostIds.remove(postId)
        } else {
            likedPostIds.insert(postId)
        }
        let nowLiked = likedPostIds.contains(postId)
        NotificationCenter.default.post(
            name: .socialStatusChanged,
            object: nil,
            userInfo: ["id": postId, "type": "like", "status": nowLiked]
        )
    }

    func isLiked(postId: String) -> Bool {
        likedPostIds.contains(postId)
    }

    func toggleSave(postId: String) {
        if savedPostIds.contains(postId) {
            savedPostIds.remove(postId)
        } else {
            savedPostIds.insert(postId)
        }
        let nowSaved = savedPostIds.contains(postId)
        NotificationCenter.default.post(
            name: .socialStatusChanged,
            object: nil,
            userInfo: ["id": postId, "type": "save", "status": nowSaved]
        )
    }

    func isSaved(postId: String) -> Bool {
        savedPostIds.contains(postId)
    }

    func checkIn(journeyId: String) {
        completedJourneyIds.insert(journeyId)
    }

    func hasCompleted(journeyId: String) -> Bool {
        completedJourneyIds.contains(journeyId)
    }

    /// 是否已關注該用戶
    func isFollowing(userId: String) -> Bool {
        followingUserIds.contains(userId)
    }

    /// 模擬關注/取關 API：0.5s 延遲後更新我的 followingCount、目標的 followersCount、isFollowing 狀態；UI 會變為 Following（淺灰、白字）。
    func toggleFollow(targetUserId: String) {
        guard !targetUserId.isEmpty else { return }
        let currentlyFollowing = followingUserIds.contains(targetUserId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if currentlyFollowing {
                self.followingUserIds.remove(targetUserId)
                self.followingCount = max(0, self.followingCount - 1)
                self.mockFollowersCount[targetUserId] = max(0, self.mockFollowersCount[targetUserId, default: 0] - 1)
            } else {
                self.followingUserIds.insert(targetUserId)
                self.followingCount += 1
                self.mockFollowersCount[targetUserId, default: 0] += 1
            }
        }
    }

    /// 模擬單向關注（僅在點擊 Follow 時調用，不切換）：0.5s 延遲後 followingCount +1、目標 followersCount +1、isFollowing = true。
    func mockFollowUser(targetUserId: String) {
        guard !targetUserId.isEmpty, !followingUserIds.contains(targetUserId) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.followingUserIds.insert(targetUserId)
            self.followingCount += 1
            self.mockFollowersCount[targetUserId, default: 0] += 1
        }
    }

    /// 模擬取關
    func mockUnfollowUser(targetUserId: String) {
        guard !targetUserId.isEmpty, followingUserIds.contains(targetUserId) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.followingUserIds.remove(targetUserId)
            self.followingCount = max(0, self.followingCount - 1)
            self.mockFollowersCount[targetUserId] = max(0, self.mockFollowersCount[targetUserId, default: 0] - 1)
        }
    }
}
