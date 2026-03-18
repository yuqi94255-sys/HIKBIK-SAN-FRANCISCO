// 收藏本地存储（与 Web lib/favorites 一致：5 种类型分键存储）
import Foundation

/// 与架构文档一致：5 種收藏類型
enum FavoriteType: String, CaseIterable {
    case stateParks = "stateParks"
    case nationalpark = "nationalpark"
    case nationalforest = "nationalforest"
    case nationalgrassland = "nationalgrassland"
    case nationalrecreation = "nationalrecreation"
}

/// 与 Web FavoriteItem 一致
struct FavoriteItem: Codable {
    let id: String       // parkId 或 stringId（国家公园/森林/草原为 string）
    let stateName: String?
    let addedAt: TimeInterval
}

enum FavoritesStore {
    private static let keyFor: [FavoriteType: String] = [
        .stateParks: "stateParksFavorites",
        .nationalpark: "nationalpark-favorites",
        .nationalforest: "nationalforest-favorites",
        .nationalgrassland: "nationalgrassland-favorites",
        .nationalrecreation: "nationalrecreation-favorites"
    ]

    private static func key(_ type: FavoriteType) -> String {
        keyFor[type] ?? "stateParksFavorites"
    }

    private static func loadItems(_ type: FavoriteType) -> [FavoriteItem] {
        guard let data = UserDefaults.standard.data(forKey: key(type)),
              let items = try? JSONDecoder().decode([FavoriteItem].self, from: data) else { return [] }
        return items
    }

    private static func saveItems(_ type: FavoriteType, _ items: [FavoriteItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key(type))
    }

    // MARK: - 按类型 API（与 Web lib/favorites 一致）

    static func loadIds(_ type: FavoriteType) -> [String] {
        loadItems(type).map(\.id)
    }

    static func contains(_ type: FavoriteType, id: String) -> Bool {
        loadItems(type).contains { $0.id == id }
    }

    static func add(_ type: FavoriteType, id: String, stateName: String? = nil) {
        var items = loadItems(type)
        if items.contains(where: { $0.id == id }) { return }
        items.append(FavoriteItem(id: id, stateName: stateName, addedAt: Date().timeIntervalSince1970))
        saveItems(type, items)
    }

    static func remove(_ type: FavoriteType, id: String) {
        let items = loadItems(type).filter { $0.id != id }
        saveItems(type, items)
    }

    static func getFavoritesCount(stateName: String? = nil) -> Int {
        var count = 0
        for type in FavoriteType.allCases {
            let items = loadItems(type)
            if let state = stateName {
                count += items.filter { $0.stateName == state }.count
            } else {
                count += items.count
            }
        }
        return count
    }

    // MARK: - 兼容旧调用：favId 格式 "nationalPark:yosemite" / "statePark:IN:1"

    private static func parseLegacyId(_ favId: String) -> (FavoriteType, String)? {
        let parts = favId.split(separator: ":", omittingEmptySubsequences: false)
        guard let first = parts.first else { return nil }
        let typeStr = String(first)
        let idPart = parts.dropFirst().joined(separator: ":")
        guard !idPart.isEmpty else { return nil }
        let type: FavoriteType? = switch typeStr.lowercased() {
        case "nationalpark": .nationalpark
        case "statepark", "stateparks": .stateParks
        case "nationalforest": .nationalforest
        case "nationalgrassland": .nationalgrassland
        case "nationalrecreation": .nationalrecreation
        default: nil
        }
        guard let t = type else { return nil }
        return (t, idPart)
    }

    /// 合并 5 键为 [String]，格式 "type:id" 供 FavoritesListView 使用
    static func loadIds() -> [String] {
        var out: [String] = []
        for type in FavoriteType.allCases {
            let prefix = type.rawValue
            for item in loadItems(type) {
                out.append("\(prefix):\(item.id)")
            }
        }
        return out
    }

    static func add(_ legacyId: String) {
        guard let (type, id) = parseLegacyId(legacyId) else { return }
        add(type, id: id)
    }

    static func remove(_ legacyId: String) {
        guard let (type, id) = parseLegacyId(legacyId) else { return }
        remove(type, id: id)
    }

    static func contains(_ legacyId: String) -> Bool {
        guard let (type, id) = parseLegacyId(legacyId) else { return false }
        return contains(type, id: id)
    }
}
