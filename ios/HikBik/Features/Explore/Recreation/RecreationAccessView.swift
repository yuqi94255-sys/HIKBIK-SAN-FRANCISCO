//
//  RecreationAccessView.swift
//  HikBik
//
//  Access & Logistics for NRA: Boarding Pass style, IATA/LIVE; conditional Ferry vs Search Airport Rentals.
//  English only.
//

import SwiftUI
import MapKit

private let recAccessCardWidth: CGFloat = 280
private let recAccessCardSpacing: CGFloat = 12
private let recAccessCardRadius: CGFloat = 16
private let recAccessCardPaddingTop: CGFloat = 20
private let recAccessCardPaddingSides: CGFloat = 16
private let recAccessCardHeight: CGFloat = 272
private let recAccessGapBadgeToTitle: CGFloat = 12
private let recAccessSectionGapAboveRoute: CGFloat = 20
private let recAccessRouteIconSpacing: CGFloat = 12
private let recAccessGapAboveButton: CGFloat = 14
private let recRentalComingSoonToast = "Coming Soon: Integrating Enterprise & Hertz real-time data."

struct RecreationAccessView: View {
    let area: NationalRecreationArea
    var coordinate: CLLocationCoordinate2D?
    var themeColor: Color = Color.cyan

    @State private var showRentalToast = false

    private var requiresAlt: Bool { area.requiresAlternativeAccess ?? false }
    private var gatewayTitle: String { area.location.states.first ?? "—" }
    private var gatewaySubtitle: String { "Nearest gateway" }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Access & Logistics")
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
            statusBadgesRow
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: recAccessCardSpacing) {
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
                .padding(.bottom, recAccessGapBadgeToTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(gatewayTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(gatewaySubtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: recAccessRouteIconSpacing) {
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
                        Spacer(minLength: 8)
                        LiveTrafficPulseView()
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
                .padding(.top, recAccessSectionGapAboveRoute)

                HStack {
                    Spacer(minLength: 4)
                    Text("TO: \(area.name)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
            }

            Text("\"Nearest gateway for supplies and vehicle access.\"")
                .font(.system(size: 11))
                .italic()
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .padding(.bottom, 2)

            Spacer(minLength: 0)

            Group {
                if requiresAlt {
                    Link(destination: URL(string: "https://www.nps.gov")!) {
                        HStack(spacing: 6) {
                            Image(systemName: "ferry.fill")
                            Text("Ferry / Access Info")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                } else {
                    Button(action: { showRentalToast = true }) {
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
                }
            }
            .padding(.top, recAccessGapAboveButton)
        }
        .padding(EdgeInsets(top: recAccessCardPaddingTop, leading: recAccessCardPaddingSides, bottom: recAccessCardPaddingSides, trailing: recAccessCardPaddingSides))
        .frame(width: recAccessCardWidth, alignment: .leading)
        .frame(height: recAccessCardHeight)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: recAccessCardRadius))
        .overlay(RoundedRectangle(cornerRadius: recAccessCardRadius).strokeBorder(Color.primary.opacity(0.1), lineWidth: 2))
    }

    private var toastOverlay: some View {
        Group {
            if showRentalToast {
                Text(recRentalComingSoonToast)
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
                            showRentalToast = false
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: showRentalToast)
    }
}

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
