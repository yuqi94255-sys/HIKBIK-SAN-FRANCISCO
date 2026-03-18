// My Favorites Screen – 以 SavedDestination 為數據源，2-column grid，去 Route 依賴
import SwiftUI

// MARK: - Favorites theme (dark, match My Trips)
private enum FavoritesTheme {
    static let background = Color(hex: "0B121F")
    static let cardBackground = Color(hex: "162133")
    static let cardBorder = Color(hex: "1E293B")
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "94A3B8")
    static let heartPink = Color(hex: "EC4899")
    static func tagColor(for category: DestinationType) -> Color {
        switch category {
        case .park: return Color(hex: "22C55E")
        case .forest: return Color(hex: "3B82F6")
        case .grassland: return Color(hex: "EAB308")
        case .recreationArea: return Color(hex: "8B5CF6")
        }
    }
}

// MARK: - ViewModel：從 FavoritesManager 讀取 [SavedDestination]
final class FavoritesListViewModel: ObservableObject {
    @Published var destinations: [SavedDestination] = []

    func load() {
        destinations = FavoritesManager.shared.load()
    }

    func remove(id: String) {
        FavoritesManager.shared.remove(id)
        load()
    }
}

// MARK: - FavoritesListView (My Favorites Screen)
struct FavoritesListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FavoritesListViewModel()

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
                        ForEach(viewModel.destinations) { dest in
                            SavedDestinationCardView(destination: dest) {
                                viewModel.remove(id: dest.id)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.load() }
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
                Text("\(viewModel.destinations.count) Saved Destinations")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(FavoritesTheme.textPrimary)
                Text("Your saved places")
                    .font(.system(size: 13))
                    .foregroundStyle(FavoritesTheme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - 收藏目的地卡片（3:4 比例，圖 55% / 文字 45%，右上角愛心可取消收藏）
struct SavedDestinationCardView: View {
    let destination: SavedDestination
    var onUnsave: (() -> Void)?

    private let cornerRadius: CGFloat = 16
    private var tagColor: Color { FavoritesTheme.tagColor(for: destination.category) }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let totalH = geo.size.height
            let imageHeight = totalH * 0.55
            let textHeight = totalH * 0.45

            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: destination.imageUrl.flatMap { URL(string: $0) }) { phase in
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

                    Text(destination.category.displayName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(tagColor.opacity(0.9))
                        .clipShape(Capsule())
                        .padding(10)

                    Button {
                        onUnsave?()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 36, height: 36)
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(FavoritesTheme.heartPink)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(10)
                }
                .frame(width: w, height: imageHeight)

                VStack(alignment: .leading, spacing: 6) {
                    Text(destination.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(FavoritesTheme.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if !destination.agency.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "building.2")
                                .font(.system(size: 9))
                            Text(destination.agency)
                                .font(.system(size: 11))
                                .lineLimit(1)
                        }
                        .foregroundStyle(FavoritesTheme.textMuted)
                    }

                    Spacer(minLength: 0)
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
