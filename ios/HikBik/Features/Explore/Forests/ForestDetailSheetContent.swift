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

/// 森林詳情頁 ViewModel：媒體、活動、設施數據
final class ForestDetailSheetViewModel: ObservableObject {
    @Published var images: [URL] = []
    @Published var activityNames: [String] = []
    @Published var isLoading = false
    /// 本地設施數據（DataLoader.loadForestFacilities），6 份森林/草原對應
    @Published var facilitiesData: ForestFacilitiesData?

    /// 同步加載設施：從 DataLoader 拿當前森林 id 對應的設施
    func loadFacilities(forestId: String) {
        facilitiesData = DataLoader.loadForestFacilities()[forestId]
    }

    /// onAppear 時調用：先請求 RIDBService.shared.fetchMedia(for: id)，失敗或空則用 fallback；載入中顯示 ProgressView
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

struct ForestDetailSheetContent: View {
    let forest: NationalForest
    var themeColor: Color = Color(red: 0.2, green: 0.6, blue: 0.3) // Forest green

    @StateObject private var viewModel = ForestDetailSheetViewModel()
    @State private var selectedFacility: ForestFacility?

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

    private var strippedDescription: String {
        RIDBAdapter.stripHTML(forest.description)
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
            ForestStatusBar(
                established: forest.established,
                region: forest.region,
                acres: acresDisplay,
                management: "U.S. Forest Service"
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    feeAndInfoSection
                    if effectiveCoordinate != nil {
                        forestMapSection
                    }
                    if !strippedDescription.isEmpty {
                        Text(strippedDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)
                    }
                    WeatherInfoView()
                        .padding(.bottom, 16)
                    facilityListView(selectedFacility: $selectedFacility)
                    ForestAccessView(
                        forest: forest,
                        forestCoordinate: effectiveCoordinate,
                        themeColor: themeColor
                    )
                    StartNavigationButton(coordinate: effectiveCoordinate, themeColor: themeColor)
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
        .sheet(item: $selectedFacility) { facility in
            FacilityDetailSheet(
                facility: facility,
                bookingURL: forest.websiteUrl.flatMap { URL(string: $0) } ?? URL(string: "https://www.recreation.gov/"),
                themeColor: themeColor,
                onBookTap: { openBooking(for: facility.name, url: forest.websiteUrl.flatMap { URL(string: $0) } ?? URL(string: "https://www.recreation.gov/")) }
            )
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            #if DEBUG
            print("[RIDB Debug] Forest detail opened with id (RecAreaID): \(forest.id)")
            #endif
            viewModel.loadFacilities(forestId: forest.id)
            Task {
                await viewModel.loadMedia(recAreaID: forest.id, fallbackPhotos: forest.photos, fallbackActivities: forest.activities)
            }
        }
    }

    private var forestMapSection: some View {
        Group {
            if let coord = effectiveCoordinate {
                DetailMapWithStyleSwitcher(center: coord, markerTitle: forest.name, height: 180)
            }
        }
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

    /// 設施清單區塊：點擊行 present 彈窗 FacilityDetailSheet；超過 8 個用 DisclosureGroup 收合
    private func facilityListView(selectedFacility: Binding<ForestFacility?>) -> some View {
        Group {
            if let data = viewModel.facilitiesData, !data.facilities.isEmpty {
                let facilities = data.facilities
                let primary = Array(facilities.prefix(8))
                let secondary = facilities.count > 8 ? Array(facilities.dropFirst(8)) : []
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 8) {
                        Image(systemName: "tent.2.fill")
                            .font(.body)
                            .foregroundStyle(themeColor)
                        Text("Available Facilities")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 8)
                    VStack(spacing: 0) {
                        ForEach(primary) { facility in
                            Button {
                                selectedFacility.wrappedValue = facility
                            } label: {
                                CompactFacilityRow(facility: facility, themeColor: themeColor)
                            }
                            .buttonStyle(.plain)
                            if facility.id != primary.last?.id || !secondary.isEmpty {
                                Divider()
                                    .padding(.leading, 48)
                            }
                        }
                        if !secondary.isEmpty {
                            DisclosureGroup {
                                ForEach(secondary) { facility in
                                    Button {
                                        selectedFacility.wrappedValue = facility
                                    } label: {
                                        CompactFacilityRow(facility: facility, themeColor: themeColor)
                                    }
                                    .buttonStyle(.plain)
                                    if facility.id != secondary.last?.id {
                                        Divider()
                                            .padding(.leading, 48)
                                    }
                                }
                            } label: {
                                Text("More facilities (\(secondary.count))")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(themeColor)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
    }

    private func openBooking(for name: String, url: URL?) {
        #if DEBUG
        print("[Interaction] 準備跳轉至設施：\(name)")
        #endif
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - 森林/草原通用天氣模塊（待命狀態：無具體數字，骨架佔位 + 淡閃爍）
struct WeatherInfoView: View {
    @State private var shimmerOpacity: Double = 0.28

    var body: some View {
        HStack(spacing: 20) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("--°C")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text("--°F")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(shimmerOpacity))
                )
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                    .opacity(0.6)
            }
            Spacer(minLength: 12)
            VStack(alignment: .trailing, spacing: 4) {
                Text("Waiting for data...")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("H: --°  L: --°")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                shimmerOpacity = 0.5
            }
        }
    }
}

// MARK: - 標題清洗：過濾 Campsite / Campground 以節省空間
private func cleanFacilityTitle(_ name: String) -> String {
    var s = name
        .replacingOccurrences(of: "Campsite", with: "", options: .caseInsensitive)
        .replacingOccurrences(of: "Campground", with: "", options: .caseInsensitive)
    while s.contains("  ") { s = s.replacingOccurrences(of: "  ", with: " ") }
    return s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
}

// MARK: - 設施詳情共用：預定 CTA、屬性 Icon Bar、去卡片化區塊

/// 預定狀態：有 URL 顯示「Reserve on Recreation.gov」按鈕，否則營地類顯示 First-come 提示
struct FacilityReservationCTA: View {
    let reservationURL: String?
    let isCampground: Bool
    var themeColor: Color

    var body: some View {
        Group {
            if let urlString = reservationURL, !urlString.isEmpty, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack(spacing: 8) {
                        Image(systemName: "link.circle.fill")
                        Text("Reserve on Recreation.gov")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .background(themeColor, in: RoundedRectangle(cornerRadius: 12))
            } else if isCampground {
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(themeColor)
                    Text("First-come, First-served / Walk-in Only")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            }
        }
    }
}

/// 橫向滾動的設施屬性 Icon Bar：Check-in/out、Pets、Max Vehicle Length 等
struct FacilityAttributesBar: View {
    var items: [(icon: String, label: String)]
    var themeColor: Color

    var body: some View {
        if items.isEmpty { return AnyView(EmptyView()) }
        return AnyView(
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: 6) {
                            Image(systemName: item.icon)
                                .font(.title3)
                                .foregroundStyle(themeColor)
                            Text(item.label)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                        }
                        .frame(minWidth: 72)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 4)
            }
        )
    }
}

/// 緊湊型設施行：僅名稱（清洗）、類型圖標、縮略地址；點擊整行進入 FacilityDetailView
struct CompactFacilityRow: View {
    let facility: ForestFacility
    var themeColor: Color

    private var displayTitle: String { cleanFacilityTitle(facility.name) }
    private var facilityIcon: String {
        switch facility.category.lowercased() {
        case "campgrounds": return "tent.fill"
        case "ranger-station": return "building.2.fill"
        default: return "mappin.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(themeColor.opacity(0.18))
                    .frame(width: 36, height: 36)
                Image(systemName: facilityIcon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(themeColor)
            }
            .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(displayTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                if !facility.abbreviatedAddress.isEmpty {
                    Text(facility.abbreviatedAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
        .frame(minHeight: 52)
    }
}

// MARK: - 彈窗式設施詳情：Hero + Quick Actions + Location / Description
struct FacilityDetailSheet: View {
    let facility: ForestFacility
    var bookingURL: URL?
    var themeColor: Color
    var onBookTap: (() -> Void)?

    private var descriptionText: String {
        let full = facility.facilityDescription ?? facility.details ?? ""
        return full.isEmpty ? "" : (full.contains("<") ? RIDBAdapter.stripHTML(full) : full)
    }
    private var fullAddressString: String {
        guard let addrs = facility.facilityAddresses, let first = addrs.first else {
            return facility.locations?.joined(separator: ", ") ?? ""
        }
        return [first.streetAddress1, first.streetAddress2, first.city, first.stateCode, first.postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    private var firstPhoneURL: URL? {
        guard let num = facility.facilityPhones?.first?.phoneNumber else { return nil }
        return URL(string: "tel:\(num.replacingOccurrences(of: " ", with: ""))")
    }
    private var directionsCoordinate: CLLocationCoordinate2D? {
        guard let addr = facility.facilityAddresses?.first,
              let lat = addr.latitude, let lon = addr.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    private var directionsQueryURL: URL? {
        let line = fullAddressString
        guard !line.isEmpty, let q = line.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "https://maps.apple.com/?q=\(q)")
    }

    private var reservationURLToShow: String? { facility.reservationURL ?? bookingURL?.absoluteString }
    private var attributeBarItems: [(icon: String, label: String)] {
        var list: [(icon: String, label: String)] = []
        if let info = facility.seasonalInfo, !info.isEmpty {
            list.append(("clock.fill", info.count > 20 ? String(info.prefix(20)) + "…" : info))
        }
        if facility.wheelchairAccessible == true {
            list.append(("figure.roll", "Accessible"))
        }
        return list
    }

    var body: some View {
        VStack(spacing: 0) {
            heroSection
            FacilityReservationCTA(
                reservationURL: reservationURLToShow,
                isCampground: facility.isCampgroundCategory,
                themeColor: themeColor
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 4)
            quickActionsSection
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !fullAddressString.isEmpty {
                        facilitySectionBlock(title: "Location") {
                            Text(fullAddressString)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if !descriptionText.isEmpty {
                        facilitySectionBlock(title: "Description") {
                            Text(descriptionText)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    FacilityAttributesBar(items: attributeBarItems, themeColor: themeColor)
                        .padding(.horizontal, 20)
                    WeatherInfoView()
                        .padding(.horizontal, 20)
                    if firstPhoneURL != nil || (facility.facilityEmails?.isEmpty == false) {
                        facilitySectionBlock(title: "Contact") {
                            if let url = firstPhoneURL {
                                Link(destination: url) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "phone.fill")
                                        Text(facility.facilityPhones?.first?.phoneNumber ?? "Call")
                                    }
                                    .foregroundStyle(themeColor)
                                }
                            }
                            ForEach(facility.facilityEmails ?? [], id: \.email) { e in
                                if let mailto = URL(string: "mailto:\(e.email)") {
                                    Link(destination: mailto) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "envelope.fill")
                                            Text(e.email)
                                        }
                                        .foregroundStyle(themeColor)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(forestSheetBackgroundColor)
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [themeColor.opacity(0.35), themeColor.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "tent.2.fill")
                .font(.system(size: 80))
                .foregroundStyle(themeColor.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 24)
                .padding(.trailing, 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(facility.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Text(facility.category.replacingOccurrences(of: "-", with: " ").uppercased())
                    .font(.caption.weight(.medium))
                    .foregroundStyle(themeColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .frame(height: 140)
    }

    private var quickActionsSection: some View {
        HStack(spacing: 30) {
            if firstPhoneURL != nil {
                ActionButton(icon: "phone.fill", label: "Call") {
                    if let url = firstPhoneURL { UIApplication.shared.open(url) }
                }
            }
            ActionButton(icon: "map.fill", label: "Directions") {
                if let coord = directionsCoordinate {
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: coord))
                    item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                } else if let url = directionsQueryURL {
                    UIApplication.shared.open(url)
                }
            }
            if facility.available, (bookingURL != nil || facility.reservationURL != nil) {
                ActionButton(icon: "link", label: "Book") {
                    if let url = facility.reservationURL.flatMap(URL.init) ?? bookingURL {
                        UIApplication.shared.open(url)
                    }
                    onBookTap?()
                }
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }

    private func facilitySectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }

    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct ActionButton: View {
    let icon: String
    let label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
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
