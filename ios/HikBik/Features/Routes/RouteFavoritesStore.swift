// 官方步道專用收藏存儲，與 RIDB 零關係
import Foundation

final class RouteFavoritesStore: ObservableObject {
    static let shared = RouteFavoritesStore()

    private let key = "routeFavoritesIds"

    @Published private(set) var favoriteIds: Set<String> = []

    private init() {
        load()
    }

    func load() {
        if let raw = UserDefaults.standard.array(forKey: key) as? [String] {
            favoriteIds = Set(raw)
        } else {
            favoriteIds = []
        }
    }

    func add(_ routeId: String) {
        favoriteIds.insert(routeId)
        persist()
    }

    func remove(_ routeId: String) {
        favoriteIds.remove(routeId)
        persist()
    }

    func isFavorite(_ routeId: String) -> Bool {
        favoriteIds.contains(routeId)
    }

    func toggle(_ routeId: String) {
        if favoriteIds.contains(routeId) {
            remove(routeId)
        } else {
            add(routeId)
        }
    }

    private func persist() {
        UserDefaults.standard.set(Array(favoriteIds), forKey: key)
    }
}
