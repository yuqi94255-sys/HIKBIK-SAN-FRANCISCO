// 与 Web/Figma 卡片设计一致：图片 + 标题 + 州/元信息 + 活动标签
import SwiftUI

/// 国家公园卡片（用于列表）
struct NationalParkCardView: View {
    let park: NationalPark
    let imageUrl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 图片区
            ZStack(alignment: .topTrailing) {
                Group {
                    if let urlString = imageUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Color.hikbikMuted
                            }
                        }
                    } else {
                        Color.hikbikMuted
                    }
                }
                .frame(height: 160)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                Text(park.state)
                    .font(HikBikFont.caption2())
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(white: 0.45))
                    .clipShape(Capsule())
                    .padding(10)
            }
            .frame(height: 160)

            // 信息区（与设计稿一致：标题、Est./访客行、浅绿活动胶囊白字、View Details 绿字）
            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Text(park.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.hikbikPrimary)
                    .lineLimit(2)
                HStack(spacing: HikBikSpacing.md) {
                    if let established = park.established {
                        Label("Est. \(established)", systemImage: "calendar")
                            .font(HikBikFont.caption2())
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                    if let visitors = park.visitors {
                        Label(visitors, systemImage: "person.2")
                            .font(HikBikFont.caption2())
                            .foregroundStyle(Color.hikbikMutedForeground)
                    }
                }
                if let activities = park.activities, !activities.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(activities.prefix(3), id: \.self) { a in
                            Text(a)
                                .font(HikBikFont.caption2())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.hikbikTabActive)
                                .clipShape(Capsule())
                        }
                        if activities.count > 3 {
                            Text("+\(activities.count - 3)")
                                .font(HikBikFont.caption2())
                                .foregroundStyle(Color.hikbikMutedForeground)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.hikbikMuted.opacity(0.6))
                                .clipShape(Capsule())
                        }
                    }
                }
                HStack(spacing: 4) {
                    Text("View Details")
                        .font(HikBikFont.caption())
                        .fontWeight(.medium)
                        .foregroundStyle(Color.hikbikTabActive)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.hikbikTabActive)
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikCard)
        }
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

/// 国家森林卡片
struct NationalForestCardView: View {
    let forest: NationalForest
    let imageUrl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let urlString = imageUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Color.hikbikMuted
                            }
                        }
                    } else {
                        Color.hikbikMuted
                    }
                }
                .frame(height: 140)
                .clipped()
                LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                Text(forest.state)
                    .font(HikBikFont.caption2())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(8)
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                Text(forest.name)
                    .font(HikBikFont.headline())
                    .foregroundStyle(Color.hikbikPrimary)
                    .lineLimit(2)
                Text(forest.region)
                    .font(HikBikFont.caption())
                    .foregroundStyle(Color.hikbikMutedForeground)
                if let activities = forest.activities, !activities.isEmpty {
                    FlowLayout(spacing: 4) {
                        ForEach(activities.prefix(3), id: \.self) { a in
                            Text(a)
                                .font(HikBikFont.caption2())
                                .foregroundStyle(Color.hikbikTabActive)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.hikbikTabActiveTint)
                                .clipShape(Capsule())
                        }
                    }
                }
                HStack {
                    Text("View Details")
                        .font(HikBikFont.caption())
                        .foregroundStyle(Color.hikbikTabActive)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.hikbikTabActive)
                }
            }
            .padding(HikBikSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.hikbikCard)
        }
        .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.xl))
        .overlay(RoundedRectangle(cornerRadius: HikBikRadius.xl).stroke(Color.hikbikBorder, lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
