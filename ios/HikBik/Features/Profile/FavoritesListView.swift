// My Favorites Screen – 2-column grid, 3:4 card ratio, floating heart, lineLimit(2)
import SwiftUI

// MARK: - Favorites theme (dark, match My Trips)
private enum FavoritesTheme {
    static let background = Color(hex: "0B121F")
    static let cardBackground = Color(hex: "162133")
    static let cardBorder = Color(hex: "1E293B")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "94A3B8")
    static let proBadge = Color(hex: "EAB308")
    static let heartPink = Color(hex: "EC4899")
    static let tagOfficial = Color(hex: "22C55E")
    static let tagJourney = Color(hex: "3B82F6")
    static let tagTrack = Color(hex: "8B5CF6")
    static let tagPreview = Color(hex: "64748B")
}

// MARK: - Favorite route card model
struct FavoriteRouteItem: Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let tag: String       // "Official", "Journey", "Track", "Preview"
    let isPro: Bool
    let rating: Double
    let author: String
    let distance: String
    let duration: String
}

// MARK: - Mock data (6 saved routes)
private let savedRoutes: [FavoriteRouteItem] = [
    FavoriteRouteItem(id: "f1", title: "Yellowstone Grand Loop", imageUrl: "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800", tag: "Official", isPro: true, rating: 5, author: "TrailGuide Official", distance: "92 mi", duration: "4 Days"),
    FavoriteRouteItem(id: "f2", title: "Pacific Coast Highway", imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800", tag: "Official", isPro: true, rating: 4.9, author: "TrailGuide Official", distance: "655 mi", duration: "10 Days"),
    FavoriteRouteItem(id: "f3", title: "Arizona Desert Explorer", imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800", tag: "Journey", isPro: false, rating: 4.7, author: "@desert_wanderer", distance: "580 mi", duration: "5 Days"),
    FavoriteRouteItem(id: "f4", title: "Moab Slickrock Trail", imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800", tag: "Track", isPro: false, rating: 4.8, author: "@trail_seeker", distance: "12.3 mi", duration: "6-8 hrs"),
    FavoriteRouteItem(id: "f5", title: "Rocky Mountain High", imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", tag: "Journey", isPro: false, rating: 4.8, author: "@mountain_rover", distance: "450 mi", duration: "7 Days"),
    FavoriteRouteItem(id: "f6", title: "Glacier National Park Loop", imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800", tag: "Official", isPro: true, rating: 5, author: "TrailGuide Official", distance: "78 mi", duration: "3 Days"),
]

// MARK: - FavoritesListView (My Favorites Screen)
struct FavoritesListView: View {
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ZStack {
            FavoritesTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                headerSection
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(savedRoutes) { item in
                            FavoriteCardView(item: item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundStyle(FavoritesTheme.textPrimary)
            }
            .buttonStyle(.plain)
            Spacer()
            Text("My Favorites")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(FavoritesTheme.textPrimary)
            Spacer()
            // Balance for centering title
            HStack(spacing: 6) { Image(systemName: "chevron.left"); Text("Back") }
                .font(.system(size: 17))
                .opacity(0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 28))
                .foregroundStyle(FavoritesTheme.heartPink)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(savedRoutes.count) Saved Routes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(FavoritesTheme.textPrimary)
                Text("Your inspiration collection")
                    .font(.system(size: 13))
                    .foregroundStyle(FavoritesTheme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - Favorite Card (3:4 ratio, image 55% / text 45%, floating heart)
struct FavoriteCardView: View {
    let item: FavoriteRouteItem
    private let cornerRadius: CGFloat = 16

    private var tagColor: Color {
        switch item.tag.lowercased() {
        case "official": return FavoritesTheme.tagOfficial
        case "journey": return FavoritesTheme.tagJourney
        case "track": return FavoritesTheme.tagTrack
        case "preview": return FavoritesTheme.tagPreview
        default: return FavoritesTheme.tagOfficial
        }
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let totalH = geo.size.height
            let imageHeight = totalH * 0.55
            let textHeight = totalH * 0.45

            VStack(spacing: 0) {
                // Image area (55%)
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: item.imageUrl)) { phase in
                        switch phase {
                        case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                        case .failure: Color.gray.opacity(0.3)
                        default: Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: w, height: imageHeight)
                    .clipped()

                    LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .top, endPoint: .center)
                        .frame(width: w, height: imageHeight)

                    Text(item.tag)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(tagColor.opacity(0.9))
                        .clipShape(Capsule())
                        .padding(10)

                    if item.isPro {
                        Text("PRO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(FavoritesTheme.proBadge)
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(10)
                    }

                    // Floating heart – top-right, ultraThinMaterial circle
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 36, height: 36)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(FavoritesTheme.heartPink)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(10)
                }
                .frame(width: w, height: imageHeight)

                // Text area (45%) – Spacer pushes author to bottom
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(FavoritesTheme.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(FavoritesTheme.proBadge)
                            Text(String(format: "%.1f", item.rating))
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundStyle(FavoritesTheme.textPrimary)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 9))
                            Text(item.distance)
                                .font(.system(size: 11, design: .monospaced))
                        }
                        .foregroundStyle(FavoritesTheme.textMuted)
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 9))
                            Text(item.duration)
                                .font(.system(size: 11, design: .monospaced))
                        }
                        .foregroundStyle(FavoritesTheme.textMuted)
                    }

                    Spacer(minLength: 0)

                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 9))
                        Text(item.author)
                            .font(.system(size: 11))
                            .lineLimit(1)
                    }
                    .foregroundStyle(FavoritesTheme.textMuted)
                }
                .padding(12)
                .frame(width: w, height: textHeight, alignment: .leading)
                .background(FavoritesTheme.cardBackground)
            }
            .frame(width: w, height: totalH)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(FavoritesTheme.cardBorder, lineWidth: 1)
            )
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
    }
}

#Preview { NavigationStack { FavoritesListView() } }
