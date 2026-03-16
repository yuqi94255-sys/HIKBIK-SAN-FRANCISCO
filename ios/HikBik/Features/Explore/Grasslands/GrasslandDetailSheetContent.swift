//
//  GrasslandDetailSheetContent.swift
//  HikBik
//
//  National Grassland detail sheet: same Map + Bottom Sheet framework as Park and Forest.
//  Entity type "National Grassland"; Access = Closest Town or future portal data. English only.
//

import SwiftUI
import MapKit

private let grasslandSheetBackgroundColor = Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255)

/// Grassland status bar: Est. | Region | Acres | Managed
private struct GrasslandStatusBar: View {
    var established: String?
    var region: String?
    var acres: String?
    var management: String

    var body: some View {
        HStack(spacing: 0) {
            GrasslandStatusCell(icon: "calendar", title: "Est.", value: established ?? "—")
            GrasslandStatusDivider()
            GrasslandStatusCell(icon: "map.fill", title: "Region", value: region ?? "—")
            GrasslandStatusDivider()
            GrasslandStatusCell(icon: "leaf.fill", title: "Acres", value: acres ?? "—")
            GrasslandStatusDivider()
            GrasslandStatusCell(icon: "building.2.fill", title: "Managed", value: management)
        }
        .frame(height: 70)
        .background(.ultraThinMaterial)
    }
}

private struct GrasslandStatusCell: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct GrasslandStatusDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.15))
            .frame(width: 1, height: 44)
    }
}

/// 草原詳情頁 ViewModel：與森林一致，onAppear 調用 RIDBService.shared.fetchMedia(for: id)，支援 isLoading
final class GrasslandDetailSheetViewModel: ObservableObject {
    @Published var images: [URL] = []
    @Published var activityNames: [String] = []
    @Published var isLoading = false

    func loadMedia(recAreaID: String, fallbackPhotos: [String]?, fallbackActivities: [String]? = nil) async {
        await MainActor.run { self.isLoading = true }
        do {
            let urls = try await RIDBService.shared.fetchMedia(for: recAreaID)
            #if DEBUG
            if !urls.isEmpty {
                print("[RIDB Success] 成功使用 API Key 抓取數據！")
                print("Fetched \(urls.count) images for ID: \(recAreaID)")
                if let first = urls.first {
                    print("[RIDB Debug] First image URL: \(first.absoluteString)")
                }
            }
            #endif
            await MainActor.run {
                if !urls.isEmpty { self.images = urls }
                else if let photos = fallbackPhotos { self.images = photos.compactMap { URL(string: $0) } }
            }
        } catch {
            #if DEBUG
            if case RIDBError.serverError(let code, _) = error, code == 401 {
                print("[Auth Error] 請檢查 API Key 是否正確傳遞。RIDB 回傳 401 Unauthorized。")
            }
            print("[RIDB Debug] No media found for ID: \(recAreaID)")
            #endif
            await MainActor.run {
                if let photos = fallbackPhotos { self.images = photos.compactMap { URL(string: $0) } }
            }
        }
        do {
            let names = try await RIDBService.shared.fetchActivities(recAreaId: recAreaID)
            await MainActor.run {
                if !names.isEmpty { self.activityNames = names }
                else if let activities = fallbackActivities { self.activityNames = activities }
            }
        } catch {
            await MainActor.run {
                if let activities = fallbackActivities { self.activityNames = activities }
            }
        }
        await MainActor.run { self.isLoading = false }
    }
}

struct GrasslandDetailSheetContent: View {
    let grassland: NationalGrassland
    var themeColor: Color = Color(red: 0.55, green: 0.45, blue: 0.2) // Grassland amber

    @StateObject private var viewModel = GrasslandDetailSheetViewModel()

    private var effectiveCoordinate: CLLocationCoordinate2D? {
        grassland.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var acresDisplay: String? {
        grassland.acres.map { n in
            if n >= 1_000_000 { return "\(n / 1_000_000)M" }
            if n >= 1_000 { return "\(n / 1_000)K" }
            return "\(n)"
        }
    }

    private var managementDisplay: String {
        grassland.managingForest ?? "U.S. Forest Service"
    }

    private var strippedDescription: String {
        RIDBAdapter.stripHTML(grassland.description)
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 40)
                .padding(.bottom, 24)
            Group {
                if viewModel.isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary.opacity(0.08))
                        ProgressView()
                    }
                    .frame(height: 200)
                } else {
                    MediaCarouselView(urls: viewModel.images)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            sheetHeader
            ActivityTagView(activities: viewModel.activityNames, themeColor: themeColor)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            GrasslandStatusBar(
                established: grassland.established,
                region: grassland.region,
                acres: acresDisplay,
                management: managementDisplay
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    feeAndInfoSection
                    if effectiveCoordinate != nil {
                        grasslandMapSection
                    }
                    if !strippedDescription.isEmpty {
                        Text(strippedDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                    }
                    WeatherInfoView()
                        .padding(.bottom, 16)
                    GrasslandAccessView(
                        grassland: grassland,
                        grasslandCoordinate: effectiveCoordinate,
                        themeColor: themeColor
                    )
                    StartNavigationButton(coordinate: effectiveCoordinate, themeColor: themeColor)
                    if let urlString = grassland.websiteUrl, let url = URL(string: urlString) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "link")
                                Text("Official Website")
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(themeColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(grasslandSheetBackgroundColor)
        .onAppear {
            #if DEBUG
            print("[RIDB Debug] Grassland detail opened with id (RecAreaID): \(grassland.id)")
            #endif
            Task {
                await viewModel.loadMedia(recAreaID: grassland.id, fallbackPhotos: grassland.photos, fallbackActivities: grassland.activities)
            }
        }
    }

    private var grasslandMapSection: some View {
        Group {
            if let coord = effectiveCoordinate {
                DetailMapWithStyleSwitcher(center: coord, markerTitle: grassland.name, height: 180)
            }
        }
    }

    private var sheetHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(grassland.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("National Grassland")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var feeAndInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Fees & Access")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            Text("No entrance fee for national grasslands. Check the official website for seasonal access and grazing information.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
