// MARK: - 收藏數據控制器：以 [SavedDestination] 為唯一儲存對象，UserDefaults 持久化
import Foundation

/// 收藏管理器：save / remove / load，不再使用 Route 或按類型分鍵的 FavoriteItem
final class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "savedDestinations"
    private let migrationDoneKey = "savedDestinations_migrationDone"

    private init() {}

    // MARK: - 讀寫

    /// 當前所有收藏目的地（已按 dateSaved 倒序）
    func load() -> [SavedDestination] {
        migrateFromFavoritesStoreIfNeeded()
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([SavedDestination].self, from: data) else {
            return []
        }
        return list.sorted { $0.dateSaved > $1.dateSaved }
    }

    /// 新增或覆蓋同 id 的收藏
    func save(_ destination: SavedDestination) {
        var list = load()
        list.removeAll { $0.id == destination.id }
        list.insert(destination, at: 0)
        persist(list)
    }

    /// 依 id 移除收藏
    func remove(_ id: String) {
        var list = load()
        list.removeAll { $0.id == id }
        persist(list)
    }

    func contains(id: String) -> Bool {
        load().contains { $0.id == id }
    }

    private func persist(_ list: [SavedDestination]) {
        guard let data = try? JSONEncoder().encode(list) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    /// 一次性從舊 FavoritesStore 遷移：用現有 FavoriteItem 生成最小 SavedDestination
    private func migrateFromFavoritesStoreIfNeeded() {
        if UserDefaults.standard.bool(forKey: migrationDoneKey) { return }
        var migrated: [SavedDestination] = []
        for type in FavoriteType.allCases {
            let legacyKey = Self.legacyKey(for: type)
            guard let data = UserDefaults.standard.data(forKey: legacyKey),
                  let items = try? JSONDecoder().decode([FavoriteItem].self, from: data) else { continue }
            for item in items {
                guard let cat = DestinationType(fromFavoriteType: type.rawValue) else { continue }
                let saved = SavedDestination(
                    id: "\(type.rawValue):\(item.id)",
                    name: "Saved Destination",
                    category: cat,
                    agency: "",
                    imageUrl: nil,
                    latitude: 0,
                    longitude: 0,
                    dateSaved: Date(timeIntervalSince1970: item.addedAt)
                )
                migrated.append(saved)
            }
        }
        if !migrated.isEmpty {
            var list = (UserDefaults.standard.data(forKey: key).flatMap { try? JSONDecoder().decode([SavedDestination].self, from: $0) }) ?? []
            let existingIds = Set(list.map(\.id))
            for m in migrated where !existingIds.contains(m.id) {
                list.append(m)
            }
            persist(list)
        }
        UserDefaults.standard.set(true, forKey: migrationDoneKey)
    }

    private static func legacyKey(for type: FavoriteType) -> String {
        let keyFor: [FavoriteType: String] = [
            .stateParks: "stateParksFavorites",
            .nationalpark: "nationalpark-favorites",
            .nationalforest: "nationalforest-favorites",
            .nationalgrassland: "nationalgrassland-favorites",
            .nationalrecreation: "nationalrecreation-favorites"
        ]
        return keyFor[type] ?? "stateParksFavorites"
    }
}
