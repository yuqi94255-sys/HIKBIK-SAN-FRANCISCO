// MARK: - 後端 / MongoDB 同步的用戶資料（本地持久化）
import Foundation

/// 登入後由 `GET auth/me` 或註冊回傳更新；存入 UserDefaults。
struct UserProfile: Codable, Equatable {
    /// MongoDB user id（用於 Posts 歸屬過濾）
    var id: String?
    var firstName: String
    var lastName: String
    var email: String
    var bio: String?
    /// 頭像 URL（`GET /api/users/me`）
    var avatarUrl: String?
    /// 關注的用戶 id 列表（與後端一致時取 `count` 顯示）
    var following: [String]
    var followers: [String]
    /// 後端若只回數字而非陣列時使用（與 `followers` / `following` 二選一）
    var followersCount: Int?
    var followingCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case mongoId = "_id"
        case firstName
        case lastName
        case nickname
        case displayName
        case email
        case bio
        case avatar
        case avatarUrl
        case profileImageUrl = "profileImageUrl"
        case following
        case followers
        case followersCount
        case followingCount
    }

    init(
        id: String? = nil,
        firstName: String,
        lastName: String,
        email: String,
        bio: String? = nil,
        avatarUrl: String? = nil,
        following: [String] = [],
        followers: [String] = [],
        followersCount: Int? = nil,
        followingCount: Int? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.bio = bio
        self.avatarUrl = avatarUrl
        self.following = following
        self.followers = followers
        self.followersCount = followersCount
        self.followingCount = followingCount
    }

    /// 顯示用：優先後端給的數字，否則用陣列長度。
    var displayFollowersCount: Int {
        if let n = followersCount { return n }
        return followers.count
    }

    var displayFollowingCount: Int {
        if let n = followingCount { return n }
        return following.count
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let s = try c.decodeIfPresent(String.self, forKey: .id) {
            id = s
        } else if let m = try c.decodeIfPresent(String.self, forKey: .mongoId) {
            id = m
        } else {
            id = nil
        }
        let first = try c.decodeIfPresent(String.self, forKey: .firstName)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let last = try c.decodeIfPresent(String.self, forKey: .lastName)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !first.isEmpty || !last.isEmpty {
            firstName = first
            lastName = last
        } else {
            // 兼容後端使用 nickname / displayName 的場景
            let alt = (try c.decodeIfPresent(String.self, forKey: .nickname)
                ?? c.decodeIfPresent(String.self, forKey: .displayName)
                ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if alt.isEmpty {
                firstName = ""
                lastName = ""
            } else {
                let parts = alt.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                firstName = parts.first.map(String.init) ?? alt
                lastName = parts.count > 1 ? String(parts[1]) : ""
            }
        }
        email = try c.decodeIfPresent(String.self, forKey: .email) ?? ""
        bio = try c.decodeIfPresent(String.self, forKey: .bio)
        avatarUrl = try c.decodeIfPresent(String.self, forKey: .avatarUrl)
            ?? c.decodeIfPresent(String.self, forKey: .avatar)
            ?? c.decodeIfPresent(String.self, forKey: .profileImageUrl)

        followersCount = try c.decodeIfPresent(Int.self, forKey: .followersCount)
        followingCount = try c.decodeIfPresent(Int.self, forKey: .followingCount)

        if let arr = try? c.decode([String].self, forKey: .following) {
            following = arr
        } else if let n = try? c.decode(Int.self, forKey: .following) {
            following = []
            if followingCount == nil { followingCount = n }
        } else {
            following = []
        }

        if let arr = try? c.decode([String].self, forKey: .followers) {
            followers = arr
        } else if let n = try? c.decode(Int.self, forKey: .followers) {
            followers = []
            if followersCount == nil { followersCount = n }
        } else {
            followers = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(id, forKey: .id)
        // 不寫入 _id，避免與後端衝突
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(email, forKey: .email)
        try c.encodeIfPresent(bio, forKey: .bio)
        try c.encodeIfPresent(avatarUrl, forKey: .avatarUrl)
        try c.encode(following, forKey: .following)
        try c.encode(followers, forKey: .followers)
        try c.encodeIfPresent(followersCount, forKey: .followersCount)
        try c.encodeIfPresent(followingCount, forKey: .followingCount)
    }
}
