// 官方步道專用收藏視圖，與 RIDB 零關係；點擊卡片 NavigationLink 全屏 Push 至 OfficialRouteDetailView
import SwiftUI

struct RouteFavoritesView: View {
    @StateObject private var store = RouteFavoritesStore.shared

    private var favoriteRoutes: [RouteItem] {
        let all = RoutesView.allRouteItems
        return store.favoriteIds.compactMap { id in all.first { $0.id == id } }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteRoutes.isEmpty {
                    ContentUnavailableView(
                        "No saved routes",
                        systemImage: "heart.slash",
                        description: Text("Save official routes from the Routes tab to see them here.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            Text("Official routes only · Tap to open")
                                .font(.caption)
                                .foregroundStyle(RouteColors.textMuted)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)

                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(favoriteRoutes) { route in
                                    NavigationLink(destination: OfficialRouteDetailView(route: route)) {
                                        RouteFavoriteCardView(route: route, onUnfavorite: {
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            store.remove(route.id)
                                        })
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .background(RouteColors.background)
            .navigationTitle("Saved Routes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct RouteFavoriteCardView: View {
    let route: RouteItem
    let onUnfavorite: () -> Void
    private let imageHeight: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: route.imageUrl)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(height: imageHeight)
                .frame(maxWidth: .infinity)
                .clipped()

                Button(action: onUnfavorite) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.red)
                        .padding(10)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(route.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(RouteColors.textPrimary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 11))
                    Text(route.location)
                        .font(.system(size: 12))
                        .lineLimit(1)
                }
                .foregroundStyle(RouteColors.textMuted)

                HStack {
                    Text(route.distance)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(RouteColors.accentGreen)
                    if let elev = route.elevation {
                        Text("· \(elev)")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(RouteColors.textMuted)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RouteColors.cardBg)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RouteFavoritesView()
}
