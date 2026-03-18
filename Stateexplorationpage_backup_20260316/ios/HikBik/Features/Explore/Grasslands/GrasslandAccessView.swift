//
//  GrasslandAccessView.swift
//  HikBik
//
//  Access & Logistics for National Grassland: same horizontal cards as Park/Forest.
//  Primary gateway = Closest Town (nearestCity) when no airport data. IATA/City/LIVE/Search Airport Rentals.
//  Grassland-specific badges: Muddy road warning, Open range cattle. English only.
//

import SwiftUI
import MapKit

private let grassAccessCardWidth: CGFloat = 280
private let grassAccessCardSpacing: CGFloat = 12
private let grassAccessCardRadius: CGFloat = 16
private let grassAccessCardPaddingTop: CGFloat = 20
private let grassAccessCardPaddingSides: CGFloat = 16
private let grassAccessCardHeight: CGFloat = 272
private let grassAccessGapBadgeToTitle: CGFloat = 12
private let grassAccessSectionGapAboveRoute: CGFloat = 20
private let grassAccessRouteIconSpacing: CGFloat = 12
private let grassAccessGapAboveSearchButton: CGFloat = 14
private let grassRentalComingSoonToast = "Coming Soon: Integrating Enterprise & Hertz real-time data."

/// Grassland-specific alert badges (from description / proTip scan)
private enum GrasslandBadgeType: String, CaseIterable {
    case muddyRoad = "Muddy Road Warning"
    case openRangeCattle = "Open Range Cattle"
    var icon: String {
        switch self {
        case .muddyRoad: return "⚠️"
        case .openRangeCattle: return "🐄"
        }
    }
    static func from(text: String) -> [GrasslandBadgeType] {
        let lower = text.lowercased()
        var out: [GrasslandBadgeType] = []
        if lower.contains("muddy") || lower.contains("mud ") || lower.contains("mud.") { out.append(.muddyRoad) }
        if lower.contains("cattle") || lower.contains("open range") || lower.contains("open-range") { out.append(.openRangeCattle) }
        return out
    }
}

struct GrasslandAccessView: View {
    let grassland: NationalGrassland
    var grasslandCoordinate: CLLocationCoordinate2D?
    var proTip: String? = nil // Optional future field for grassland backup JSON
    var themeColor: Color = Color(red: 0.55, green: 0.45, blue: 0.2)

    @State private var showRentalComingSoonToast = false

    /// Closest Town as primary gateway when no airport data
    private var closestTownTitle: String { grassland.nearestCity ?? "—" }
    private var closestTownSubtitle: String { "Closest Town" }
    private var grasslandBadges: [GrasslandBadgeType] {
        let text = (proTip ?? "") + " " + grassland.description
        return GrasslandBadgeType.from(text: text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Access & Logistics")
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
            statusBadgesRow
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: grassAccessCardSpacing) {
                    gatewayCard
                }
                .padding(.horizontal, 20)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground).opacity(0.95), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primary.opacity(0.12), lineWidth: 2))
        .overlay(alignment: .bottom) { toastOverlay }
    }

    private var statusBadgesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text("Paved Road")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.primary.opacity(0.08), in: Capsule())
                Text("Signal: —")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.primary.opacity(0.08), in: Capsule())
            }
            .padding(.vertical, 2)
        }
    }

    private var gatewayCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("CLOSEST TOWN")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(0.5)
                .foregroundStyle(themeColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(themeColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
                .zIndex(50)
                .padding(.bottom, grassAccessGapBadgeToTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(closestTownTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .tracking(-0.5)
                Text(closestTownSubtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: grassAccessRouteIconSpacing) {
                    Image(systemName: "airplane")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Rectangle()
                        .fill(Color.primary.opacity(0.12))
                        .frame(height: 2)
                    HStack(spacing: 0) {
                        Text("—")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer(minLength: 8)
                        GrasslandLivePulseView()
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(minWidth: 0)
                    Rectangle()
                        .fill(Color.primary.opacity(0.12))
                        .frame(height: 2)
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(themeColor)
                }
                .frame(height: 24)
                .padding(.top, grassAccessSectionGapAboveRoute)

                HStack {
                    Spacer(minLength: 4)
                    Text("TO: \(grassland.name)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }

            Text("\"Closest town for supplies and vehicle access.\"")
                .font(.system(size: 11))
                .italic()
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .padding(.bottom, 2)

            if !grasslandBadges.isEmpty {
                HStack(spacing: 6) {
                    ForEach(grasslandBadges, id: \.rawValue) { badge in
                        Text("\(badge.icon) \(badge.rawValue)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 4))
                    }
                }
            }

            Spacer(minLength: 0)

            Button(action: { showRentalComingSoonToast = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 11))
                    Text("Search Airport Rentals")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .foregroundStyle(Color.primary.opacity(0.25))
                )
            }
            .buttonStyle(.plain)
            .opacity(0.9)
            .padding(.top, grassAccessGapAboveSearchButton)
        }
        .padding(EdgeInsets(top: grassAccessCardPaddingTop, leading: grassAccessCardPaddingSides, bottom: grassAccessCardPaddingSides, trailing: grassAccessCardPaddingSides))
        .frame(width: grassAccessCardWidth, alignment: .leading)
        .frame(height: grassAccessCardHeight)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: grassAccessCardRadius))
        .overlay(RoundedRectangle(cornerRadius: grassAccessCardRadius).strokeBorder(Color.primary.opacity(0.1), lineWidth: 2))
    }

    private var toastOverlay: some View {
        Group {
            if showRentalComingSoonToast {
                Text(grassRentalComingSoonToast)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.primary.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showRentalComingSoonToast = false
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: showRentalComingSoonToast)
    }
}

private struct GrasslandLivePulseView: View {
    @State private var isPulsing = false
    var body: some View {
        HStack(spacing: 3) {
            Circle()
                .fill(Color.green)
                .frame(width: 6, height: 6)
                .scaleEffect(isPulsing ? 1.2 : 0.9)
                .opacity(isPulsing ? 0.9 : 0.6)
            Text("LIVE")
                .font(.system(size: 8, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}
