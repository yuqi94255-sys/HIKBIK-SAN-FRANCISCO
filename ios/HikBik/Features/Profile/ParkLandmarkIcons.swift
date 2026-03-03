// Unique landmark-style icons per U.S. National Park (SF Symbol or semantic name for silhouette)
import SwiftUI

enum ParkLandmarkIcons {
    /// SF Symbol name for park id (e.g. yosemite → Half Dome style = mountain.2.fill).
    /// Falls back to "leaf.fill" when no mapping.
    static func iconName(forParkId parkId: String) -> String {
        let id = parkId.lowercased()
        switch id {
        case "yosemite": return "mountain.2.fill"
        case "grand-canyon", "grand-canyon-np": return "square.stack.3d.up.fill"
        case "zion": return "triangle.fill"
        case "yellowstone": return "flame.fill"
        case "glacier", "glacier-np": return "snowflake"
        case "acadia": return "water.waves"
        case "rocky-mountain", "rocky-mountain-np": return "mountain.2.fill"
        case "great-smoky-mountains", "great-smoky-mountains-np": return "leaf.fill"
        case "arches": return "arch.fill"
        case "bryce-canyon": return "building.2.fill"
        case "canyonlands": return "square.stack.fill"
        case "denali", "denali-np": return "mountain.2.fill"
        case "everglades": return "allergens"
        case "grand-teton", "grand-teton-np": return "mountain.2.fill"
        case "olympic", "olympic-np": return "cloud.rain.fill"
        case "sequoia", "sequoia-np": return "tree.fill"
        case "kings-canyon": return "tree.fill"
        case "redwood", "redwood-np": return "tree.fill"
        case "crater-lake": return "drop.fill"
        case "death-valley": return "sun.max.fill"
        case "havasu-falls", "grand-canyon-west": return "drop.fill"
        case "mammoth-cave": return "arrow.down.circle.fill"
        case "mesa-verde": return "building.columns.fill"
        case "mount-rainier": return "mountain.2.fill"
        case "petrified-forest": return "leaf.fill"
        case "shenandoah": return "mountain.2.fill"
        case "voyageurs": return "water.waves"
        case "wind-cave": return "arrow.down.circle.fill"
        case "badlands": return "square.fill"
        case "biscayne": return "water.waves"
        case "black-canyon": return "rectangle.fill"
        case "cuyahoga-valley": return "leaf.fill"
        case "gateway-arch", "jefferson-national-expansion": return "arch.fill"
        case "great-basin": return "mountain.2.fill"
        case "great-sand-dunes": return "circle.fill"
        case "hot-springs": return "flame.fill"
        case "isle-royale": return "leaf.fill"
        case "joshua-tree": return "tree.fill"
        case "lassen-volcanic": return "flame.fill"
        case "new-river-gorge": return "water.waves"
        case "north-cascades": return "snowflake"
        case "capitol-reef": return "square.fill"
        case "channel-islands": return "water.waves"
        case "congaree": return "tree.fill"
        case "dry-tortugas": return "water.waves"
        case "gates-of-the-arctic": return "snowflake"
        case "glacier-bay": return "water.waves"
        case "haleakala": return "flame.fill"
        case "hawaii-volcanoes", "hawaii-volcanoes-np": return "flame.fill"
        case "indiana-dunes": return "water.waves"
        case "katmai": return "flame.fill"
        case "kenai-fjords": return "snowflake"
        case "kobuk-valley": return "snowflake"
        case "lake-clark": return "water.waves"
        case "american-samoa", "national-park-of-american-samoa": return "water.waves"
        case "pinnacles": return "mountain.2.fill"
        case "saguaro": return "tree.fill"
        case "theodore-roosevelt": return "mountain.2.fill"
        case "virgin-islands", "virgin-islands-np": return "water.waves"
        case "wrangell-st-elias", "wrangell-st-elias-np": return "snowflake"
        case "white-sands": return "circle.fill"
        default: return "leaf.fill"
        }
    }

    /// Resolve park id from achievement id ("park_yosemite" → "yosemite").
    static func parkId(fromAchievementId achievementId: String) -> String {
        guard achievementId.hasPrefix("park_") else { return achievementId }
        return String(achievementId.dropFirst("park_".count))
    }
}
