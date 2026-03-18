//
//  ForestAccessView.swift
//  HikBik
//
//  Access section for National Forest: same visual as Park (horizontal portal cards, LIVE pulse, badges).
//  Data: "Nearest Gateway Town" placeholder when no airport/portal data; future ForestBackupData can add portals.
//  English only. Search Car Rental button.
//

import SwiftUI
import MapKit

private let forestAccessCardWidth: CGFloat = 280
private let forestAccessCardSpacing: CGFloat = 12
private let forestAccessCardRadius: CGFloat = 16
private let forestAccessCardPaddingTop: CGFloat = 20
private let forestAccessCardPaddingSides: CGFloat = 16
private let forestAccessCardHeight: CGFloat = 272
private let forestAccessGapBadgeToTitle: CGFloat = 12
private let forestAccessSectionGapAboveRoute: CGFloat = 20
private let forestAccessRouteIconSpacing: CGFloat = 12
private let forestAccessGapAboveSearchButton: CGFloat = 14
private let forestRentalComingSoonToast = "Coming Soon: Integrating Enterprise & Hertz real-time data."

struct ForestAccessView: View {
    let forest: NationalForest
    var forestCoordinate: CLLocationCoordinate2D?
    var themeColor: Color = Color(red: 0.2, green: 0.6, blue: 0.3)

    @State private var showRentalComingSoonToast = false

    /// Single gateway card when no portal data: Nearest Gateway Town
    private var gatewayTitle: String { forest.nearestCity ?? "—" }
    private var gatewaySubtitle: String { "Nearest Gateway Town" }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Access & Logistics")
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
            statusBadgesRow
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: forestAccessCardSpacing) {
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
            Text("GATEWAY")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(0.5)
                .foregroundStyle(themeColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(themeColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
                .zIndex(50)
                .padding(.bottom, forestAccessGapBadgeToTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(gatewayTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .tracking(-0.5)
                Text(gatewaySubtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: forestAccessRouteIconSpacing) {
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
                        LiveTrafficPulseView()
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
                .padding(.top, forestAccessSectionGapAboveRoute)

                HStack {
                    Spacer(minLength: 4)
                    Text("TO: \(forest.name)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }

            Text("\"Nearest town for supplies, lodging, and vehicle rental.\"")
                .font(.system(size: 11))
                .italic()
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .padding(.bottom, 2)

            Spacer(minLength: 0)

            Button(action: { showRentalComingSoonToast = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 11))
                    Text("Search Car Rental")
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
            .padding(.top, forestAccessGapAboveSearchButton)
        }
        .padding(EdgeInsets(top: forestAccessCardPaddingTop, leading: forestAccessCardPaddingSides, bottom: forestAccessCardPaddingSides, trailing: forestAccessCardPaddingSides))
        .frame(width: forestAccessCardWidth, alignment: .leading)
        .frame(height: forestAccessCardHeight)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: forestAccessCardRadius))
        .overlay(RoundedRectangle(cornerRadius: forestAccessCardRadius).strokeBorder(Color.primary.opacity(0.1), lineWidth: 2))
    }

    private var toastOverlay: some View {
        Group {
            if showRentalComingSoonToast {
                Text(forestRentalComingSoonToast)
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

/// Live traffic pulse (green dot + LIVE) — shared with Park Access
private struct LiveTrafficPulseView: View {
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
