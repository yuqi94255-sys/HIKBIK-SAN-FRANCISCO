//
//  HomeFavoritesView.swift
//  HikBik
//
//  三大入口之一：Home 收藏夾。僅 RIDB 目的地（Park / Forest / Grassland / RecArea），
//  數據源 FavoritesManager，點擊卡片 NavigationLink 全屏 Push 至對應詳情頁，禁止 Sheet。
//

import SwiftUI
import MapKit

// MARK: - 主題（與原 Favorites 一致）
private enum HomeFavoritesTheme {
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

// MARK: - ViewModel：僅讀 FavoritesManager（RIDB 目的地）
final class HomeFavoritesViewModel: ObservableObject {
    @Published var destinations: [SavedDestination] = []

    func load() {
        destinations = FavoritesManager.shared.load()
    }

    func remove(id: String) {
        FavoritesManager.shared.remove(id)
        load()
    }
}

// MARK: - Home 收藏夾主視圖（網格 + NavigationLink 全屏跳轉）
struct HomeFavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HomeFavoritesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ZStack {
            HomeFavoritesTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                headerSection
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.destinations) { dest in
                            NavigationLink(value: dest) {
                                HomeFavoriteCardView(destination: dest) {
                                    viewModel.remove(id: dest.id)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(for: SavedDestination.self) { dest in
                destinationView(for: dest)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.load() }
    }

    @ViewBuilder
    private func destinationView(for dest: SavedDestination) -> some View {
        switch dest.category {
        case .park:
            if let park = resolvePark(from: dest) {
                NationalParkDetailView(park: park)
            } else {
                fallbackUnavailable(dest)
            }
        case .forest:
            if let forest = resolveForest(from: dest) {
                ForestDetailView(forest: forest)
            } else {
                fallbackUnavailable(dest)
            }
        case .grassland:
            if let grassland = resolveGrassland(from: dest) {
                GrasslandDetailView(grassland: grassland)
            } else {
                fallbackUnavailable(dest)
            }
        case .recreationArea:
            if let area = resolveRecArea(from: dest) {
                RecreationDetailView(area: area)
            } else {
                fallbackUnavailable(dest)
            }
        }
    }

    private func fallbackUnavailable(_ dest: SavedDestination) -> some View {
        ContentUnavailableView(
            dest.name,
            systemImage: "mappin.slash",
            description: Text("This place may have been removed from the catalog.")
        )
    }

    private func resolvePark(from dest: SavedDestination) -> NationalPark? {
        let id = dest.id
        let prefix = "nationalPark:"
        let altPrefix = "nationalpark:"
        let parkId: String
        if id.hasPrefix(prefix) {
            parkId = String(id.dropFirst(prefix.count))
        } else if id.hasPrefix(altPrefix) {
            parkId = String(id.dropFirst(altPrefix.count))
        } else { return nil }
        return DataLoader.loadNationalParks().first { $0.id == parkId }
    }

    private func resolveForest(from dest: SavedDestination) -> NationalForest? {
        let id = dest.id
        let prefix = "nationalforest:"
        guard id.lowercased().hasPrefix(prefix) else { return nil }
        let rest = String(id.dropFirst(prefix.count))
        let forestId: String
        if let colonIndex = rest.firstIndex(of: ":") {
            forestId = String(rest.prefix(upTo: colonIndex))
        } else {
            forestId = rest
        }
        return DataLoader.loadNationalForests().first { $0.id == forestId }
    }

    private func resolveGrassland(from dest: SavedDestination) -> NationalGrassland? {
        let id = dest.id
        let prefix = "nationalgrassland:"
        guard id.lowercased().hasPrefix(prefix) else { return nil }
        let rest = String(id.dropFirst(prefix.count))
        let grasslandId: String
        if let colonIndex = rest.firstIndex(of: ":") {
            grasslandId = String(rest.prefix(upTo: colonIndex))
        } else {
            grasslandId = rest
        }
        return DataLoader.loadNationalGrasslands().first { $0.id == grasslandId }
    }

    private func resolveRecArea(from dest: SavedDestination) -> NationalRecreationArea? {
        let id = dest.id
        let prefix = "nationalrecreation:"
        guard id.lowercased().hasPrefix(prefix) else { return nil }
        let rest = String(id.dropFirst(prefix.count))
        let areaIdStr: String
        if let colonIndex = rest.firstIndex(of: ":") {
            areaIdStr = String(rest.prefix(upTo: colonIndex))
        } else {
            areaIdStr = rest
        }
        guard let areaId = Int(areaIdStr) else { return nil }
        return DataLoader.loadNationalRecreation().first { $0.id == areaId }
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
                .foregroundStyle(HomeFavoritesTheme.textPrimary)
            }
            .buttonStyle(.plain)
            Spacer()
            Text("My Saved Wonders")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(HomeFavoritesTheme.textPrimary)
            Spacer()
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
                .foregroundStyle(HomeFavoritesTheme.heartPink)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.destinations.count) Saved Destinations")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(HomeFavoritesTheme.textPrimary)
                Text("RIDB places only · Tap to open")
                    .font(.system(size: 13))
                    .foregroundStyle(HomeFavoritesTheme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - 卡片（縮略圖 + 名稱 + 類型標籤 + 取消收藏按鈕）
private struct HomeFavoriteCardView: View {
    let destination: SavedDestination
    var onUnsave: (() -> Void)?

    private let cornerRadius: CGFloat = 16
    private var tagColor: Color { HomeFavoritesTheme.tagColor(for: destination.category) }

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
                                .foregroundStyle(HomeFavoritesTheme.heartPink)
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
                        .foregroundStyle(HomeFavoritesTheme.textPrimary)
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
                        .foregroundStyle(HomeFavoritesTheme.textMuted)
                    }

                    Spacer(minLength: 0)
                }
                .padding(12)
                .frame(width: w, height: textHeight, alignment: .leading)
                .background(HomeFavoritesTheme.cardBackground)
            }
            .frame(width: w, height: totalH)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(HomeFavoritesTheme.cardBorder, lineWidth: 1)
            )
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
    }
}

#Preview { NavigationStack { HomeFavoritesView() } }
