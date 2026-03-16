//
//  ActivityTagView.swift
//  HikBik
//
//  活動標籤：圖標 + 文字，Capsule 外框，橫向 ScrollView。
//  根據官方活動名稱映射 SF Symbol。
//

import SwiftUI

/// 將活動名稱映射為 SF Symbol 名稱
func symbolName(for activity: String) -> String {
    let lower = activity.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    switch lower {
    case "camping": return "tent.fill"
    case "hiking": return "figure.hiking"
    case "fishing": return "fish.fill"
    case "boating": return "sailboat.fill"
    case "biking", "cycling": return "figure.outdoor.cycle"
    case "hunting": return "target"
    case "picnicking": return "fork.knife"
    case "horseback riding", "horseback": return "figure.equestrian.sports"
    default: return "leaf.fill"
    }
}

struct ActivityTagView: View {
    let activities: [String]
    var themeColor: Color = .secondary

    var body: some View {
        if activities.isEmpty {
            EmptyView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(activities.uniqued().enumerated()), id: \.offset) { _, name in
                        HStack(spacing: 6) {
                            Image(systemName: symbolName(for: name))
                                .font(.system(size: 14, weight: .medium))
                            Text(name)
                                .font(.subheadline.weight(.medium))
                        }
                        .foregroundStyle(themeColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

#Preview {
    ActivityTagView(activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Boating"])
        .padding()
}
