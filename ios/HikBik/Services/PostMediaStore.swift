// MARK: - Post Media Store — 發布後媒體 URL 池，key 為 journey_ / track_ / published_ 前綴的 post id
// 供 CommunityMacroDetailView、DetailedTrackCard、Profile 輪播與「所見即所得」同步。
import Foundation
import Combine

/// 將多圖 Data 寫入 Documents/PostMedia，返回可用的 file URL 字符串數組（供輪播加載）；供 PostEditorView、CustomRouteBuilderView 共用。
func savePostMediaToDocuments(postId: String, imageData: [Data]) -> [String] {
    guard !postId.isEmpty, !imageData.isEmpty else { return [] }
    guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
        .appendingPathComponent("PostMedia", isDirectory: true) else { return [] }
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let safeId = postId.replacingOccurrences(of: "/", with: "_")
    var urls: [String] = []
    for (i, data) in imageData.enumerated() {
        let name = "\(safeId)_\(i).jpg"
        let fileURL = dir.appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
            urls.append(fileURL.absoluteString)
        } catch {
            #if DEBUG
            print("PostMedia save failed \(name): \(error)")
            #endif
        }
    }
    return urls
}

extension Notification.Name {
    static let postMediaDidUpdate = Notification.Name("PostMediaStore.didUpdate")
    /// 刪除 Post 時廣播，Community 監聽以同步刷新列表
    static let postDeleted = Notification.Name("PostDeleted")
}

/// 全局單例：按 post id 存儲 [String] 圖片 URL，發布時寫入，詳情/列表讀取。
final class PostMediaStore: ObservableObject {
    static let shared = PostMediaStore()

    private let keyPrefix = "PostMediaStore_urls_"
    private let defaults = UserDefaults.standard

    private init() {}

    /// 寫入該 post 的圖片 URL 數組（發布或更新時調用）
    func setImageUrls(id: String, urls: [String]) {
        guard !id.isEmpty else { return }
        defaults.set(urls, forKey: keyPrefix + id)
        objectWillChange.send()
        NotificationCenter.default.post(name: .postMediaDidUpdate, object: nil, userInfo: ["id": id])
    }

    /// 讀取該 post 的圖片 URL 數組；無則返回 nil（詳情頁可回退 coverImageURL / heroImage）
    func imageUrls(for id: String) -> [String]? {
        guard !id.isEmpty, let list = defaults.stringArray(forKey: keyPrefix + id), !list.isEmpty else { return nil }
        return list
    }

    /// 便捷：返回非空數組，無則返回空數組
    func imageUrlsOrEmpty(for id: String) -> [String] {
        imageUrls(for: id) ?? []
    }

    /// 物理刪除該 post 的媒體文件（Documents/PostMedia 下前綴匹配的文件）+ 清除 UserDefaults 緩存。Detailed Track 會一併刪除 track_xxx_vp_0..vp_N 的鍵與文件。
    func destroyAllMedia(for postId: String) {
        guard !postId.isEmpty else { return }
        let safeId = postId.replacingOccurrences(of: "/", with: "_")
        let prefix = safeId + "_"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("PostMedia", isDirectory: true),
           FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
                .filter { $0.lastPathComponent.hasPrefix(prefix) }
                .forEach { try? FileManager.default.removeItem(at: $0) }
        }
        defaults.removeObject(forKey: keyPrefix + postId)
        if postId.hasPrefix("track_") {
            for i in 0..<100 {
                defaults.removeObject(forKey: keyPrefix + postId + "_vp_\(i)")
            }
        }
        objectWillChange.send()
    }

    /// 發布時歸類 id：Detailed Track 用 track_<routeID>，其餘用 published_<index>
    static func publishId(publishedIndex: Int, trackRouteID: String?) -> String {
        if let rid = trackRouteID, !rid.isEmpty {
            return "track_\(rid)"
        }
        return "published_\(publishedIndex)"
    }
}
