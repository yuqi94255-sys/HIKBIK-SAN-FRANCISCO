// 地景全景樣式：圖片 + 底漸變 + 毛玻璃地區標籤 + SF Symbols 屬性；依類型自動配色
import SwiftUI

// MARK: - 依類型自動配色（國家公園 / 森林 / 草原 / 休閒區）
enum ParkCategoryAccent {
    case nationalPark   // 深松綠
    case forest         // 橄欖綠
    case grassland      // 金黃色
    case recreation     // 鋼藍色

    var color: Color {
        switch self {
        case .nationalPark: return Color(hex: "2D5A27")
        case .forest: return Color(hex: "4A7023")
        case .grassland: return Color(hex: "DAA520")
        case .recreation: return Color(hex: "4682B4")
        }
    }
}

private let panoramaCardCorner: CGFloat = 18
private let panoramaCardHeight: CGFloat = 200

/// 通用全景樣式卡片：全屏圖、底→中漸變、右上 Ultra Thin Material 地區標籤、標題 + SF Symbols 屬性列；無灰/白底、無邊框、浮起陰影
struct PanoramaDestinationCard: View {
    let imageUrl: String?
    let title: String
    let locationLabel: String
    let iconAccent: Color
    let attributes: [(icon: String, text: String)]
    var cardHeight: CGFloat = panoramaCardHeight
    var cornerRadius: CGFloat = panoramaCardCorner

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let urlString = imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default: Color.hikbikMuted
                        }
                    }
                } else {
                    Color.hikbikMuted
                }
            }
            .frame(height: cardHeight)
            .frame(maxWidth: .infinity)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: cardHeight)
            .allowsHitTesting(false)

            VStack {
                HStack {
                    Spacer()
                    Text(locationLabel)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.9), lineWidth: 0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(12)
                }
                Spacer()
            }
            .frame(height: cardHeight)
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 16) {
                    ForEach(Array(attributes.enumerated()), id: \.offset) { _, item in
                        HStack(spacing: 4) {
                            Image(systemName: item.icon)
                                .foregroundStyle(iconAccent)
                            Text(item.text)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.95))
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.white.opacity(0.12), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: -0.8)
    }
}

/// 州代碼 → 全名（用於地區標籤）
private func stateDisplayName(for park: NationalPark) -> String {
    let map: [String: String] = [
        "AK": "Alaska", "AL": "Alabama", "AZ": "Arizona", "AR": "Arkansas", "CA": "California",
        "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware", "FL": "Florida", "GA": "Georgia",
        "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa",
        "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland",
        "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri",
        "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey",
        "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota",
        "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island",
        "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas",
        "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia",
        "WI": "Wisconsin", "WY": "Wyoming"
    ]
    return map[park.state] ?? park.state
}

/// 国家公园卡片（用于列表）；全量使用全景樣式，圖標深松綠
struct NationalParkCardView: View {
    let park: NationalPark
    let imageUrl: String?

    private var attributes: [(icon: String, text: String)] {
        var list: [(icon: String, text: String)] = []
        if let established = park.established {
            list.append(("calendar", "Est. \(established)"))
        }
        if let visitors = park.visitors {
            list.append(("person.2.fill", visitors))
        }
        if let area = park.area ?? park.acreage.map({ "\($0) acres" }) {
            list.append(("square.dashed", area))
        }
        return list
    }

    var body: some View {
        PanoramaDestinationCard(
            imageUrl: imageUrl,
            title: park.name,
            locationLabel: stateDisplayName(for: park),
            iconAccent: ParkCategoryAccent.nationalPark.color,
            attributes: attributes
        )
    }
}

/// 国家森林卡片；全景樣式，圖標橄欖綠
struct NationalForestCardView: View {
    let forest: NationalForest
    let imageUrl: String?

    private var attributes: [(icon: String, text: String)] {
        var list: [(icon: String, text: String)] = []
        if let established = forest.established {
            list.append(("calendar", "Est. \(established)"))
        }
        if let visitors = forest.visitors {
            list.append(("person.2.fill", visitors))
        }
        if let acres = forest.acres {
            list.append(("square.dashed", "\(acres) acres"))
        }
        return list
    }

    private var locationLabel: String {
        forest.region.isEmpty ? forest.state : forest.region
    }

    var body: some View {
        PanoramaDestinationCard(
            imageUrl: imageUrl,
            title: forest.name,
            locationLabel: locationLabel,
            iconAccent: ParkCategoryAccent.forest.color,
            attributes: attributes
        )
    }
}
