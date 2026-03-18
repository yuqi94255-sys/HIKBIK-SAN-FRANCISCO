// MARK: - 收藏目的地模型（取代用 Route 充當收藏對象）
import Foundation

/// 目的地類型：對應 RIDB RecAreaID / ParkID 等
enum DestinationType: String, Codable, CaseIterable {
    case park = "park"
    case forest = "forest"
    case grassland = "grassland"
    case recreationArea = "recreationArea"

    var displayName: String {
        switch self {
        case .park: return "National Park"
        case .forest: return "National Forest"
        case .grassland: return "National Grassland"
        case .recreationArea: return "Recreation Area"
        }
    }

    /// 與舊 FavoriteType 對齊，便於遷移
    init?(fromFavoriteType type: String) {
        let lower = type.lowercased()
        if lower.contains("nationalpark") || lower == "nationalpark" { self = .park; return }
        if lower.contains("nationalforest") || lower == "nationalforest" { self = .forest; return }
        if lower.contains("nationalgrassland") || lower == "nationalgrassland" { self = .grassland; return }
        if lower.contains("nationalrecreation") || lower == "nationalrecreation" { self = .recreationArea; return }
        if lower.contains("statepark") { self = .park; return }
        return nil
    }
}

/// 單一收藏目的地：用於 FavoritesManager 持久化與 FavoritesListView 展示
struct SavedDestination: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let category: DestinationType
    let agency: String
    let imageUrl: String?
    let latitude: Double
    let longitude: Double
    let dateSaved: Date

    enum CodingKeys: String, CodingKey {
        case id, name, category, agency, imageUrl, latitude, longitude, dateSaved
    }

    init(id: String, name: String, category: DestinationType, agency: String, imageUrl: String? = nil, latitude: Double, longitude: Double, dateSaved: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.agency = agency
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.dateSaved = dateSaved
    }
}
