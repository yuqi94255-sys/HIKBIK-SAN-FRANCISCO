//
//  AccessLogisticsView.swift
//  HikBik
//
//  Terminal Info Board: ProTip banner, portal cards, rental badges, Search Rental stub, Live traffic pulse.
//  All UI text in English.
//

import SwiftUI
import MapKit

// MARK: - Rental badge type (from proTip / tip scan)
private enum RentalBadgeType: String, CaseIterable {
    case fourWheel = "4WD/AWD Recommended"
    case winter = "Winter Gear Advised"
    case gravel = "Gravel Road Warning"
    var icon: String {
        switch self {
        case .fourWheel: return "🛻"
        case .winter: return "❄️"
        case .gravel: return "⚠️"
        }
    }
    static func from(text: String) -> [RentalBadgeType] {
        let lower = text.lowercased()
        var out: [RentalBadgeType] = []
        if lower.contains("4wd") || lower.contains("awd") { out.append(.fourWheel) }
        if lower.contains("snow") || lower.contains("winter") { out.append(.winter) }
        if lower.contains("unpaved") || lower.contains("gravel") { out.append(.gravel) }
        return out
    }
}

private let rentalBadgeTooltip = "Highly recommended for this park's specific terrain."
private let rentalComingSoonToast = "Coming Soon: Integrating Enterprise & Hertz real-time data."

// MARK: - Design constants (horizontal info cards: Apple Maps / Airbnb style)
private enum AccessDesign {
    static let cardRadius: CGFloat = 16
    static let bannerRadius: CGFloat = 12
    static let borderWidth: CGFloat = 2
    static let typeBadgeRadius: CGFloat = 6
    static let amber = Color(red: 245/255, green: 158/255, blue: 11/255)
    static let portalCardWidth: CGFloat = 280
    static let carouselCardSpacing: CGFloat = 12
    /// Card inner padding (no clipping; badge must stay visible)
    static let cardPaddingTop: CGFloat = 20
    static let cardPaddingSides: CGFloat = 16
    static let cardPaddingBottom: CGFloat = 16
    static let portalCardHeight: CGFloat = 272
    /// Gap between type badge and IATA · City title (strict 12pt)
    static let gapBadgeToTitle: CGFloat = 12
    static let sectionGapAboveRoute: CGFloat = 20
    static let routeIconSpacing: CGFloat = 12
    static let gapAboveSearchButton: CGFloat = 14
}

/// Access & Logistics: ProTip banner, portal cards, rental badges, Search Rental stub, Live pulse. All labels in English.
struct AccessLogisticsView: View {
    var parkId: String
    var portalsFromBackup: [PortalItem]?
    var accessFromBackup: AccessInfo?
    var proTipFromBackup: String?
    var cellSignalStrength: String?
    var permitRequired: Bool?
    var parkCoordinate: CLLocationCoordinate2D?
    var themeColor: Color = Color(red: 0.98, green: 0.45, blue: 0.09)

    @State private var showRentalComingSoonToast = false

    private var backup: ParkBackupItem? { DataLoader.loadParkBackup()[parkId] }
    private var portals: [PortalItem] { portalsFromBackup ?? backup?.portals ?? [] }
    private var proTip: String? { proTipFromBackup ?? backup?.proTip }
    private var legacyAccess: AccessInfo? { accessFromBackup ?? backup?.access }

    private var roadLabel: String { "Paved Road" }
    private var signalLabel: String {
        let s = cellSignalStrength?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let s = s, !s.isEmpty {
            let lower = s.lowercased()
            if lower.contains("no") || lower.contains("none") || lower.contains("limited") { return "Signal: Limited" }
            return "Signal: Available"
        }
        return "Signal: —"
    }

    /// 是否顯示 ProTip 警示（含 4WD / Reservation / Ferry 時可閃爍圖標）
    private var proTipNeedsWarning: Bool {
        guard let t = proTip else { return false }
        let lower = t.lowercased()
        return lower.contains("4wd") || lower.contains("reservation") || lower.contains("ferry")
    }

    /// 相容：無 portals 時用 legacy access 組一條；IATA code 用於卡片標題
    private var displayPortals: [PortalItem] {
        if !portals.isEmpty { return portals }
        guard let acc = legacyAccess,
              let s = acc.nearestAirport?.trimmingCharacters(in: .whitespacesAndNewlines),
              !s.isEmpty else { return [] }
        let code = acc.nearestAirportCode ?? String(s.split(separator: " ").first ?? "")
        let drive = s.contains("hr") ? (s.split(separator: "—").last.map(String.init)?.trimmingCharacters(in: .whitespaces) ?? "") : ""
        let airportTitle = code.isEmpty ? s : "\(code) \(s)"
        return [PortalItem(type: "Fastest", airport: airportTitle, driveTime: drive, entrance: "Park Entrance", tip: "See NPS for directions.")]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Access & Logistics")
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)

            statusBadgesRow

            if let tip = proTip, !tip.isEmpty {
                proTipBanner(tip: tip)
            }

            if displayPortals.isEmpty {
                primaryArrivalFallbackRow
            } else {
                portalCardsGrid
            }

            startNavigationButton
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground).opacity(0.95), in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: AccessDesign.borderWidth)
        )
        .overlay(alignment: .bottom) { toastOverlay }
    }

    // MARK: - 狀態標籤（路況 / 信號 / 許可證）

    private var statusBadgesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text(roadLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.primary.opacity(0.08), in: Capsule())
                Text(signalLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.primary.opacity(0.08), in: Capsule())
                if permitRequired == true {
                    Text("Permit Required")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.black.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.yellow.opacity(0.9), in: Capsule())
                }
            }
            .padding(.vertical, 2)
        }
    }

    // MARK: - ProTip 警示條（黃色高亮，左側 ⚠️ 條件閃爍）

    private func proTipBanner(tip: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if proTipNeedsWarning {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(AccessDesign.amber)
                    .symbolEffect(.pulse, options: .repeating)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Pro Tip")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(.systemBrown))
                Text(tip)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AccessDesign.amber.opacity(0.18), in: RoundedRectangle(cornerRadius: AccessDesign.bannerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AccessDesign.bannerRadius)
                .strokeBorder(AccessDesign.amber.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: - Horizontal carousel (swipe, snap, wide cards)

    private var portalCardsGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AccessDesign.carouselCardSpacing) {
                ForEach(displayPortals) { item in
                    portalCard(item, onRentalTap: { showRentalComingSoonToast = true })
                        .frame(width: AccessDesign.portalCardWidth, alignment: .leading)
                }
            }
            .padding(.horizontal, 20)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }

    private var toastOverlay: some View {
        Group {
            if showRentalComingSoonToast {
                Text(rentalComingSoonToast)
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

    // MARK: - Portal card (wide rectangle, horizontal carousel)

    private func portalCard(_ item: PortalItem, onRentalTap: @escaping () -> Void) -> some View {
        let iata = Self.iataFromAirport(item.airport)
        let city = Self.cityFromAirport(item.airport)
        let cityDisplay = city.isEmpty ? item.airport : city
        let isFastest = item.type.lowercased().contains("fastest")
        let rentalBadges = RentalBadgeType.from(text: (proTip ?? "") + " " + item.tip)
        let showSearchRental = iata == "ANC" || iata == "FAI"

        return VStack(alignment: .leading, spacing: 0) {
            // 1. Type badge — FIRST element in card, high z-index, never clipped
            Text(item.type.uppercased())
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(0.5)
                .foregroundStyle(isFastest ? Color.blue : Color.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background((isFastest ? Color.blue : Color.green).opacity(0.15), in: RoundedRectangle(cornerRadius: AccessDesign.typeBadgeRadius))
                .zIndex(50)
                .padding(.bottom, AccessDesign.gapBadgeToTitle)

            // 2. IATA · City title
            VStack(alignment: .leading, spacing: 4) {
                Text(iata)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .tracking(-0.5)
                if !cityDisplay.isEmpty {
                    Text(cityDisplay)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }

            // 4. Route line: 4.0 hr and ● LIVE on same line, no overlap (no clipping)
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: AccessDesign.routeIconSpacing) {
                    Image(systemName: "airplane")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Rectangle()
                        .fill(Color.primary.opacity(0.12))
                        .frame(height: 2)
                    HStack(spacing: 0) {
                        Text(item.driveTime)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
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

                HStack {
                    if !city.isEmpty {
                        Text("FROM: \(city)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    Spacer(minLength: 4)
                    Text("TO: \(item.entrance)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
            .padding(.top, AccessDesign.sectionGapAboveRoute)

            // Tip
            if !item.tip.isEmpty {
                Text("\"\(item.tip)\"")
                    .font(.system(size: 11))
                    .italic()
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            // Footer: rental badges row
            if !rentalBadges.isEmpty {
                HStack(spacing: 6) {
                    ForEach(rentalBadges, id: \.rawValue) { badge in
                        Text("\(badge.icon) \(badge.rawValue)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 4))
                            .help(rentalBadgeTooltip)
                    }
                }
            }

            // Search Airport Rentals: more padding and gap from badges above
            if showSearchRental {
                Button(action: onRentalTap) {
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
                .padding(.top, AccessDesign.gapAboveSearchButton)
            }
        }
        .padding(EdgeInsets(top: AccessDesign.cardPaddingTop, leading: AccessDesign.cardPaddingSides, bottom: AccessDesign.cardPaddingBottom, trailing: AccessDesign.cardPaddingSides))
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: AccessDesign.portalCardHeight)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: AccessDesign.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AccessDesign.cardRadius)
                .strokeBorder(Color.primary.opacity(0.1), lineWidth: AccessDesign.borderWidth)
        )
    }

    /// 從 "FAT (Fresno)" 取 IATA "FAT"
    private static func iataFromAirport(_ airport: String) -> String {
        if let first = airport.split(separator: " ").first { return String(first) }
        return airport
    }

    /// 從 "FAT (Fresno)" 取城市 "Fresno"
    private static func cityFromAirport(_ airport: String) -> String {
        guard let open = airport.firstIndex(of: "("),
              let close = airport.firstIndex(of: ")") else { return "" }
        return String(airport[airport.index(after: open)..<close])
    }

    // MARK: - 無 portals 時的 fallback 一行

    private var primaryArrivalFallbackRow: some View {
        let text = legacyAccess?.nearestAirport?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "—"
        return HStack(spacing: 10) {
            Image(systemName: "airplane.arrival")
                .foregroundStyle(themeColor)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Start Navigation

    private var startNavigationButton: some View {
        Button {
            openInAppleMaps()
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
        .disabled(parkCoordinate == nil)
        .opacity(parkCoordinate == nil ? 0.6 : 1)
    }

    private func openInAppleMaps() {
        guard let coord = parkCoordinate else { return }
        let placemark = MKPlacemark(coordinate: coord)
        let item = MKMapItem(placemark: placemark)
        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - Live Traffic Pulse (green dot + LIVE label, breathing animation)
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
