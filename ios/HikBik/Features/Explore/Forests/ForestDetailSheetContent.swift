//
//  ForestDetailSheetContent.swift
//  HikBik
//
//  National Forest detail sheet: same UI framework as Park (Map + Sheet).
//  Data decoupled: type "National Forest", management "U.S. Forest Service", Access = gateway town or future portals.
//  English only.
//

import SwiftUI
import MapKit

private let forestSheetBackgroundColor = Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1E/255)

/// Forest version of status bar: Est. | Region | Acres | Management (USFS)
private struct ForestStatusBar: View {
    var established: String?
    var region: String?
    var acres: String?
    var management: String = "U.S. Forest Service"

    var body: some View {
        HStack(spacing: 0) {
            ForestStatusCell(icon: "calendar", title: "Est.", value: established ?? "—")
            ForestStatusDivider()
            ForestStatusCell(icon: "map.fill", title: "Region", value: region ?? "—")
            ForestStatusDivider()
            ForestStatusCell(icon: "tree.fill", title: "Acres", value: acres ?? "—")
            ForestStatusDivider()
            ForestStatusCell(icon: "building.2.fill", title: "Managed", value: management)
        }
        .frame(height: 70)
        .background(.ultraThinMaterial)
    }
}

private struct ForestStatusCell: View {
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

private struct ForestStatusDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.15))
            .frame(width: 1, height: 44)
    }
}

struct ForestDetailSheetContent: View {
    let forest: NationalForest
    var themeColor: Color = Color(red: 0.2, green: 0.6, blue: 0.3) // Forest green

    private var effectiveCoordinate: CLLocationCoordinate2D? {
        forest.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var acresDisplay: String? {
        forest.acres.map { n in
            if n >= 1_000_000 { return "\(n / 1_000_000)M" }
            if n >= 1_000 { return "\(n / 1_000)K" }
            return "\(n)"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.primary.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 40)
                .padding(.bottom, 24)
            sheetHeader
            ForestStatusBar(
                established: forest.established,
                region: forest.region,
                acres: acresDisplay,
                management: "U.S. Forest Service"
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    feeAndInfoSection
                    if let photos = forest.photos, !photos.isEmpty {
                        gallerySection(photos: photos)
                    }
                    if !forest.description.isEmpty {
                        Text(forest.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                    }
                    ForestAccessView(
                        forest: forest,
                        forestCoordinate: effectiveCoordinate,
                        themeColor: themeColor
                    )
                    StartNavigationButton(coordinate: effectiveCoordinate, themeColor: themeColor)
                    if let facilities = DataLoader.loadForestFacilities()[forest.id] {
                        ForestFacilitiesSummaryView(facilities: facilities, themeColor: themeColor)
                    }
                    if let urlString = forest.websiteUrl, let url = URL(string: urlString) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "link")
                                Text("Official Forest Service Website")
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
        .background(forestSheetBackgroundColor)
    }

    private var sheetHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(forest.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("National Forest")
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
            Text("No entrance fee for most national forests. Some recreation sites may require a pass; check the official website.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func gallerySection(photos: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(photos.prefix(10).enumerated()), id: \.offset) { _, urlString in
                    if let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Color.primary.opacity(0.15)
                            }
                        }
                        .frame(width: 160, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

/// Reusable Start Navigation button (Park + Forest)
struct StartNavigationButton: View {
    var coordinate: CLLocationCoordinate2D?
    var themeColor: Color

    var body: some View {
        Button {
            guard let coord = coordinate else { return }
            let placemark = MKPlacemark(coordinate: coord)
            let item = MKMapItem(placemark: placemark)
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                Text("Start Navigation")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [themeColor, themeColor.opacity(0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
        .buttonStyle(.plain)
        .disabled(coordinate == nil)
        .opacity(coordinate == nil ? 0.6 : 1)
    }
}

/// Compact facilities summary for forest sheet
private struct ForestFacilitiesSummaryView: View {
    let facilities: ForestFacilitiesData
    var themeColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Facilities")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            HStack(spacing: 12) {
                if let camp = facilities.campgrounds {
                    Label("\(camp.developed) campgrounds", systemImage: "tent.fill")
                }
                if let trails = facilities.trails {
                    Label("\(trails.hiking) hiking trails", systemImage: "figure.hiking")
                }
                if let water = facilities.waterActivities, water.lakesCount > 0 {
                    Label("\(water.lakesCount) lakes", systemImage: "drop.fill")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
