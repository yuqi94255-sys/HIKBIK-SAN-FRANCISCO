// MARK: - DataManager — single source of truth; 內存 + 持久化存儲。
import SwiftUI
import Foundation

/// Track type used for both drafts and published (DraftItem).
typealias Track = DraftItem

/// Global data hub. Community binds to publishedTracks; Profile Drafts bind to draftTracks.
/// publishedTracks 持久化到本地文件，重啟 App 不丟失。
final class TrackDataManager: ObservableObject {
    static let shared = TrackDataManager()

    @Published var publishedTracks: [Track] = []
    @Published var draftTracks: [Track] = []

    private let publishedTracksFileName = "publishedTracks.json"

    private var publishedTracksFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(publishedTracksFileName)
    }

    /// 僅在單例創建時調用一次，不會因 View 刷新而執行；不在此處寫 publishedTracks = []，避免覆蓋數據。
    private init() {
        loadPublishedTracksFromStore()
    }

    /// 測試數據 ID 前綴：重啟後從 publishedTracks 物理刪除，保持數據庫乾淨。
    private static let testDataIDPrefixesToRemove: [String] = ["F22D8A37", "F46F184C"]

    /// 從持久化存儲讀取 publishedTracks，重啟 App 後不丟失。載入後執行大掃除：刪除測試 ID 的數據並寫回。
    private func loadPublishedTracksFromStore() {
        let url = publishedTracksFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            publishedTracks = []
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var loaded = try decoder.decode([Track].self, from: data)
            let before = loaded.count
            loaded.removeAll { track in
                let idStr = track.id.uuidString.uppercased()
                return Self.testDataIDPrefixesToRemove.contains { idStr.hasPrefix($0) }
            }
            if loaded.count != before {
                publishedTracks = loaded
                savePublishedTracksToStore()
                print("TrackDataManager: 已刪除 \(before - loaded.count) 條測試數據並寫回存儲")
            } else {
                publishedTracks = loaded
            }
        } catch {
            publishedTracks = []
            print("TrackDataManager: load publishedTracks failed — \(error.localizedDescription)")
        }
    }

    /// 供外部硬連線寫入後調用，強制持久化（避免重啟丟失）。
    func persistPublishedTracks() {
        savePublishedTracksToStore()
    }

    /// 強制將 publishedTracks 寫入本地文件。
    private func savePublishedTracksToStore() {
        let url = publishedTracksFileURL
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(publishedTracks)
            try data.write(to: url)
        } catch {
            print("TrackDataManager: save publishedTracks failed — \(error.localizedDescription)")
        }
    }

    /// Publish path: insert at 0, then dismiss to Community。
    func addPublished(_ item: Track) {
        var item = item
        if item.ownerUserId == nil {
            item.ownerUserId = UserProfileViewModel.shared.profile?.id
        }
        publishedTracks.insert(item, at: 0)
        savePublishedTracksToStore()
        objectWillChange.send()
    }

    /// Save Draft path: insert at 0, then dismiss to previous page.
    func addDraft(_ item: Track) {
        draftTracks.insert(item, at: 0)
        objectWillChange.send()
    }

    func removeDraft(id: UUID) {
        draftTracks.removeAll { $0.id == id }
        objectWillChange.send()
    }

    /// 刪除已發布項：從列表移除、持久化、清理 PostMedia 文件與緩存、廣播 PostDeleted 供 Community 同步刷新
    func removePublished(id: UUID) {
        guard let index = publishedTracks.firstIndex(where: { $0.id == id }) else { return }
        let draft = publishedTracks[index]
        let postId = draft.category == .detailedTrack
            ? PostMediaStore.publishId(publishedIndex: index, trackRouteID: draft.id.uuidString)
            : PostMediaStore.publishId(publishedIndex: index, trackRouteID: nil)
        publishedTracks.removeAll { $0.id == id }
        savePublishedTracksToStore()
        PostMediaStore.shared.destroyAllMedia(for: postId)
        NotificationCenter.default.post(name: .postDeleted, object: nil, userInfo: ["id": postId])
        objectWillChange.send()
    }

    /// 邏輯解綁：不依賴草稿箱是否存在該 ID，先塞發布箱再嘗試清草稿；直接錄製並發布也生效。依來源自動打 category 投遞到對應社區板塊。
    func publishDraft(_ draft: DraftItem, with journey: DetailedTrackPost, category overrideCategory: PostCategory? = nil, currentWeather: String? = nil, nearbyFacilities: [String]? = nil) {
        print("🚨 [CRITICAL] 發布函數被觸發了！正在處理 ID: \(draft.id)")

        // 第一步：直接創建發布對象（不查草稿箱），並按來源打 category
        var newPost = draft
        if newPost.ownerUserId == nil {
            newPost.ownerUserId = UserProfileViewModel.shared.profile?.id
        }
        newPost.category = overrideCategory ?? DraftItem.category(from: draft.source)
        newPost.title = journey.routeName.trimmingCharacters(in: .whitespaces).isEmpty ? draft.title : journey.routeName
        newPost.currentWeather = currentWeather ?? draft.currentWeather
        newPost.nearbyFacilities = nearbyFacilities ?? draft.nearbyFacilities

        let performWrite = {
            // 第二步：直接塞進發布數組（不管 draft 是否在草稿箱）
            self.publishedTracks.insert(newPost, at: 0)
            // 第三步：嘗試從草稿箱移除（如果有的話，沒有也無所謂）
            self.draftTracks.removeAll { $0.id == draft.id }
            self.savePublishedTracksToStore()
            self.publishedTracks = Array(self.publishedTracks)
            self.objectWillChange.send()
            print("✅ [FIXED] 數據已強行進入發布箱！總數: \(self.publishedTracks.count)")
        }

        if Thread.isMainThread {
            performWrite()
        } else {
            DispatchQueue.main.sync(execute: performWrite)
        }
    }

    /// All tracks (drafts + published) for stats/legacy.
    var allTracks: [Track] {
        publishedTracks + draftTracks
    }

    func reloadFromStore() {
        loadPublishedTracksFromStore()
        objectWillChange.send()
    }
}
