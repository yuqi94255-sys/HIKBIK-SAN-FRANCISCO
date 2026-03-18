// 歸還詳情頁：三種歸還方式（Mail-back / Home Pickup / In-Store）、進度條、押金狀態
import SwiftUI
import CoreImage.CIFilterBuiltins
import MapKit

// MARK: - 歸還進度（Requested -> Received -> Refunded）
private enum ReturnProgress: Int, CaseIterable {
    case requested = 1
    case received = 2
    case refunded = 3
    var title: String {
        switch self {
        case .requested: return "Requested"
        case .received: return "Received"
        case .refunded: return "Refunded"
        }
    }
}

/// 頁內選擇的歸還方式（與下單時的 returnMethod 可不同）
private enum ReturnDetailMode: String, CaseIterable {
    case mailBack = "Mail-back"
    case homePickup = "Home Pickup"
    case inStore = "In-Store"
}

// MARK: - 全美 50 州（字母序）+ DC + International / Manual（選中後 State 可手寫）
private enum USStatePickerData {
    static let internationalOption = "International / Manual"

    /// 50 州按字母順序 + DC + International / Manual
    static let stateNames: [String] = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
        "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
        "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
        "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
        "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
        "Wisconsin", "Wyoming", internationalOption
    ]
}

/// 國際區號選項（用於 Country Code Picker）
private struct PhoneCountryCode: Identifiable, Hashable {
    let code: String
    let display: String
    var id: String { code }
    static let options: [PhoneCountryCode] = [
        PhoneCountryCode(code: "+1", display: "+1"),
        PhoneCountryCode(code: "+86", display: "+86"),
        PhoneCountryCode(code: "+44", display: "+44"),
        PhoneCountryCode(code: "+81", display: "+81"),
        PhoneCountryCode(code: "+886", display: "+886"),
        PhoneCountryCode(code: "+33", display: "+33"),
        PhoneCountryCode(code: "+49", display: "+49"),
        PhoneCountryCode(code: "+61", display: "+61"),
        PhoneCountryCode(code: "+82", display: "+82"),
        PhoneCountryCode(code: "+91", display: "+91"),
    ]
}

/// 取件地址（多層級展示：姓名+電話 / 街道 / 城市州郵編；支援國際電話與郵件）
private struct PickupAddress {
    var recipientName: String
    var phoneCountryCode: String
    var phone: String
    var email: String
    var street: String
    var apartmentOrSuite: String
    var city: String
    var state: String
    var zip: String

    /// 第一行：收件人 | 區號+電話
    var line1: String {
        let name = recipientName.trimmingCharacters(in: .whitespaces)
        let fullPhone = fullPhoneNumber
        if name.isEmpty && fullPhone.isEmpty { return "—" }
        if name.isEmpty { return fullPhone }
        if fullPhone.isEmpty { return name }
        return "\(name) | \(fullPhone)"
    }

    private var fullPhoneNumber: String {
        let cc = phoneCountryCode.trimmingCharacters(in: .whitespaces)
        let num = phone.trimmingCharacters(in: .whitespaces)
        if num.isEmpty { return "" }
        if cc.isEmpty { return num }
        return "\(cc) \(num)"
    }

    /// 第二行：街道（含 Apt/Suite 若存在）
    var line2: String {
        let s = street.trimmingCharacters(in: .whitespaces)
        let a = apartmentOrSuite.trimmingCharacters(in: .whitespaces)
        if s.isEmpty && a.isEmpty { return "—" }
        if a.isEmpty { return s }
        return s.isEmpty ? a : "\(s), \(a)"
    }

    /// 第三行：城市, 州 郵編
    var line3: String {
        let c = city.trimmingCharacters(in: .whitespaces)
        let s = state.trimmingCharacters(in: .whitespaces)
        let z = zip.trimmingCharacters(in: .whitespaces)
        if c.isEmpty && s.isEmpty && z.isEmpty { return "—" }
        var parts: [String] = []
        if !c.isEmpty { parts.append(c) }
        if !s.isEmpty { parts.append(s) }
        if !z.isEmpty { parts.append(z) }
        return parts.joined(separator: ", ")
    }

    /// 從訂單的 shippingAddress 推導（若為 nil 或佔位則用默認物流格式）
    private static let placeholderAddress = "—"
    static func fromOrder(_ order: Order) -> PickupAddress {
        if let raw = order.shippingAddress, !raw.isEmpty, raw != placeholderAddress {
            return parseMultilineAddress(raw) ?? defaultOrderAddress
        }
        return defaultOrderAddress
    }

    /// 模擬 GPS 定位地址
    static func gpsSimulated() -> PickupAddress {
        PickupAddress(
            recipientName: "Current Location",
            phoneCountryCode: "+1",
            phone: "555-0199",
            email: "",
            street: "456 Trailhead Rd",
            apartmentOrSuite: "",
            city: "Boulder",
            state: "CO",
            zip: "80301"
        )
    }

    private static let defaultOrderAddress = PickupAddress(
        recipientName: "John Doe",
        phoneCountryCode: "+1",
        phone: "555-0123",
        email: "",
        street: "789 Alpine Trail",
        apartmentOrSuite: "Suite 200",
        city: "Denver",
        state: "CO",
        zip: "80202"
    )

    private static func parseMultilineAddress(_ s: String) -> PickupAddress? {
        let lines = s.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        guard lines.count >= 1 else { return nil }
        let line1 = lines[0].trimmingCharacters(in: .whitespaces)
        let line2 = lines.count > 1 ? lines[1].trimmingCharacters(in: .whitespaces) : ""
        let line3 = lines.count > 2 ? lines[2].trimmingCharacters(in: .whitespaces) : ""
        if line1.isEmpty && line2.isEmpty && line3.isEmpty { return nil }
        var name = "", phone = "", phoneCC = "+1"
        if line1.contains("|") {
            let parts = line1.split(separator: "|", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            name = parts.first ?? ""
            let ph = parts.count > 1 ? parts[1] : ""
            if ph.hasPrefix("+") {
                let idx = ph.firstIndex(where: { $0 != "+" && !$0.isNumber }) ?? ph.endIndex
                phoneCC = String(ph[..<idx])
                phone = String(ph[idx...]).trimmingCharacters(in: .whitespaces)
                if phoneCC.isEmpty { phoneCC = "+1" }
            } else {
                phone = ph
            }
        } else {
            name = line1
        }
        var city = "", state = "", zip = ""
        if !line3.isEmpty {
            let parts = line3.split(separator: ",", maxSplits: 2).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count >= 1 { city = parts[0] }
            if parts.count >= 2 { state = parts[1] }
            if parts.count >= 3 { zip = parts[2] }
        }
        return PickupAddress(recipientName: name, phoneCountryCode: phoneCC, phone: phone, email: "", street: line2, apartmentOrSuite: "", city: city, state: state, zip: zip)
    }
}

private let mailBackReturnAddress = "HIKBIK Returns\n1234 Warehouse Way\nFresno, CA 93721"

/// In-Store 用：門店 + 與模擬用戶的距離（英里）
private struct StoreWithDistance: Identifiable {
    let store: HikBikStore
    let distanceMiles: Double
    var id: String { store.id }
    var distanceText: String {
        if distanceMiles < 0.1 { return "Nearest" }
        return String(format: "%.1f mi away", distanceMiles)
    }
}

/// 根據當前時間簡單判斷門店是否營業（Mon–Fri 9–20, Sat–Sun 10–18 本地時區）
private func isStoreOpenNow(_ store: HikBikStore) -> Bool {
    let cal = Calendar.current
    let hour = cal.component(.hour, from: Date())
    let weekday = cal.component(.weekday, from: Date())
    let isWeekend = weekday == 1 || weekday == 7
    if isWeekend { return hour >= 10 && hour < 18 }
    return hour >= 9 && hour < 20
}

struct ReturnDetailView: View {
    let order: Order
    @ObservedObject var mockAPI: MockAPIService
    @State private var trackingNumber: String = ""
    @State private var selectedMode: ReturnDetailMode = .mailBack
    @State private var pickupDate: Date = Date()
    @State private var didSetInitialMode = false
    @State private var pickupAddress: PickupAddress = PickupAddress(recipientName: "", phoneCountryCode: "+1", phone: "", email: "", street: "", apartmentOrSuite: "", city: "", state: "", zip: "")
    @State private var didSetPickupAddress = false
    @State private var showChangeAddressSheet = false
    @State private var selectedStoreForReturn: HikBikStore?
    @State private var inStoreMapPosition: MapCameraPosition = .automatic
    @State private var isGeneratingLabel = false
    @State private var generatedLabel: ShippingLabel?
    @State private var isSubmittingReturn = false
    @State private var returnSubmitError: String?
    private let viewModel = OrdersViewModel(api: .shared)
    private let shippingService = ShippingService.shared
    private let returnService = ReturnService.shared

    /// 模擬用戶位置（Denver），用於 In-Store 距離排序
    private static let simulatedUserLocation = CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903)

    private var currentOrder: Order {
        mockAPI.orders.first(where: { $0.id == order.id }) ?? order
    }

    private var completedStepIndex: Int {
        switch currentOrder.status {
        case .renting: return 0
        case .returning: return 1
        case .received: return 2
        case .completed: return currentOrder.isDepositRefunded == true ? 3 : 2
        default: return 0
        }
    }

    private var cardBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    private var returnCode: String {
        currentOrder.id + "-return-" + currentOrder.orderNumber.replacingOccurrences(of: " ", with: "")
    }

    /// 用於追蹤進度條與面單：生成的運單號或用戶輸入的運單號
    private var effectiveTrackingNumber: String {
        generatedLabel?.trackingNumber ?? trackingNumber
    }

    /// 根據訂單狀態推導物流階段（用於頂部追蹤條）
    private var trackingStageFromOrder: TrackingStage? {
        switch currentOrder.status {
        case .returning: return .inTransit
        case .received: return .outForDelivery
        case .completed: return .returned
        default: return nil
        }
    }

    /// In-Store：按與模擬用戶位置距離由近到遠排序的門店
    private var sortedStoresWithDistance: [StoreWithDistance] {
        let user = CLLocation(latitude: Self.simulatedUserLocation.latitude, longitude: Self.simulatedUserLocation.longitude)
        return StoresView.allStores
            .map { store in
                let loc = CLLocation(latitude: store.latitude, longitude: store.longitude)
                let miles = user.distance(from: loc) / 1609.34
                return StoreWithDistance(store: store, distanceMiles: miles)
            }
            .sorted { $0.distanceMiles < $1.distanceMiles }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                topProgressBar
                if !effectiveTrackingNumber.trimmingCharacters(in: .whitespaces).isEmpty || trackingStageFromOrder != nil {
                    trackingProgressBar
                }
                modeSegmentedControl
                dynamicContentCard
                refundStatusCard
                if currentOrder.status == .renting {
                    confirmButton
                    if selectedMode == .mailBack || selectedMode == .homePickup {
                        returnLabelSection
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.deepSpaceBackground)
        .onAppear {
            if !didSetInitialMode {
                didSetInitialMode = true
                if currentOrder.returnMethod == .pickup || currentOrder.pickupFee != nil {
                    selectedMode = .homePickup
                }
            }
            if !didSetPickupAddress {
                didSetPickupAddress = true
                pickupAddress = PickupAddress.fromOrder(currentOrder)
            }
            if selectedStoreForReturn == nil, let first = sortedStoresWithDistance.first {
                selectedStoreForReturn = first.store
                inStoreMapPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: first.store.latitude, longitude: first.store.longitude), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)))
            }
        }
        .onChange(of: selectedMode) { _, newMode in
            if newMode == .inStore, selectedStoreForReturn == nil, let first = sortedStoresWithDistance.first {
                selectedStoreForReturn = first.store
                inStoreMapPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: first.store.latitude, longitude: first.store.longitude), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)))
            }
        }
        .sheet(isPresented: $showChangeAddressSheet) {
            ChangePickupAddressSheet(
                order: currentOrder,
                currentAddress: $pickupAddress,
                onDismiss: { showChangeAddressSheet = false }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.deepSpaceBackground, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: - Progress Bar
    private var topProgressBar: some View {
        HStack(spacing: 0) {
            ForEach(Array(ReturnProgress.allCases.enumerated()), id: \.element.rawValue) { index, step in
                let isCompleted = completedStepIndex >= step.rawValue
                VStack(spacing: 8) {
                    Circle()
                        .fill(isCompleted ? Color.shopNeonGreen : Color.white.opacity(0.2))
                        .frame(width: 12, height: 12)
                    Text(step.title)
                        .font(.system(size: 11, weight: isCompleted ? .semibold : .regular, design: .rounded))
                        .foregroundStyle(isCompleted ? Color.shopNeonGreen : Color.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                if index < ReturnProgress.allCases.count - 1 {
                    Rectangle()
                        .fill(completedStepIndex > step.rawValue ? Color.shopNeonGreen : Color.white.opacity(0.2))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    /// 物流追蹤進度條：In Transit -> Out for Delivery -> Returned（有運單號或已歸還時顯示）
    private var trackingProgressBar: some View {
        let stage = trackingStageFromOrder ?? .inTransit
        return VStack(alignment: .leading, spacing: 8) {
            Text("Shipment")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.6))
            HStack(spacing: 0) {
                ForEach(Array(TrackingStage.allCases.enumerated()), id: \.element.rawValue) { index, s in
                    let isCompleted = stage.stepIndex >= s.stepIndex
                    VStack(spacing: 6) {
                        Circle()
                            .fill(isCompleted ? Color.shopNeonGreen : Color.white.opacity(0.2))
                            .frame(width: 10, height: 10)
                        Text(s.rawValue)
                            .font(.system(size: 10, weight: isCompleted ? .semibold : .regular, design: .rounded))
                            .foregroundStyle(isCompleted ? Color.shopNeonGreen : Color.white.opacity(0.5))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    if index < TrackingStage.allCases.count - 1 {
                        Rectangle()
                            .fill(stage.stepIndex > s.stepIndex ? Color.shopNeonGreen : Color.white.opacity(0.2))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(14)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - 模式切換器（進度條下方）
    private var modeSegmentedControl: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How to return")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white)
            Picker("", selection: $selectedMode) {
                ForEach(ReturnDetailMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - 動態內容區塊（依選中模式）
    @ViewBuilder
    private var dynamicContentCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedMode.rawValue)
                .font(.headline)
                .foregroundStyle(Color.white)

            switch selectedMode {
            case .mailBack:
                mailBackContent
            case .homePickup:
                homePickupContent
            case .inStore:
                inStoreContent
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var mailBackContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Return address")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            Text(mailBackReturnAddress)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.85))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.shopNeonGreen.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("Tracking number")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            TextField("Enter carrier tracking number", text: $trackingNumber)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white)
                .padding(14)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .autocapitalization(.allCharacters)
            Button {} label: {
                HStack(spacing: 8) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 14))
                    Text("Submit Tracking")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(Color.deepSpaceBackground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.shopNeonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .disabled(trackingNumber.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(trackingNumber.trimmingCharacters(in: .whitespaces).isEmpty ? 0.6 : 1)
        }
    }

    private var homePickupContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pickup Location")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            VStack(alignment: .leading, spacing: 8) {
                Text(pickupAddress.line1)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
                Text(pickupAddress.line2)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                Text(pickupAddress.line3)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                HStack {
                    Spacer()
                    Button {
                        showChangeAddressSheet = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Change Address")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(Color.shopNeonGreen)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            Text("Please ensure the courier can access this location.")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.55))
            Text("Preferred date & time")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            DatePicker("", selection: $pickupDate, in: Date()...)
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(Color.shopNeonGreen)
            Text("Courier will arrive at your door.")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundStyle(Color.shopNeonGreen.opacity(0.9))
        }
    }

    private var inStoreContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            inStoreMapCard
            Text("Nearby stores")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            inStoreCarousel
            if let store = selectedStoreForReturn {
                inStoreDirectionsAndQR(store: store)
            }
        }
    }

    private var inStoreMapCard: some View {
        Map(position: $inStoreMapPosition, interactionModes: .all) {
            ForEach(sortedStoresWithDistance) { item in
                Annotation(item.store.name, coordinate: CLLocationCoordinate2D(latitude: item.store.latitude, longitude: item.store.longitude)) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundStyle(selectedStoreForReturn?.id == item.store.id ? Color.shopNeonGreen : Color.red)
                }
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var inStoreCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sortedStoresWithDistance) { item in
                    inStoreCard(item: item)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func inStoreCard(item: StoreWithDistance) -> some View {
        let isSelected = selectedStoreForReturn?.id == item.store.id
        let isNearest = sortedStoresWithDistance.first?.store.id == item.store.id
        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedStoreForReturn = item.store
                inStoreMapPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.store.latitude, longitude: item.store.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)))
            }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.store.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                    if isNearest {
                        Text("Nearest")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.deepSpaceBackground)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.shopNeonGreen)
                            .clipShape(Capsule())
                    }
                }
                Text(item.distanceText)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.7))
                HStack(spacing: 4) {
                    Circle()
                        .fill(isStoreOpenNow(item.store) ? Color.shopNeonGreen : Color.orange)
                        .frame(width: 6, height: 6)
                    Text(isStoreOpenNow(item.store) ? "Open Now" : "Closed")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(isStoreOpenNow(item.store) ? Color.shopNeonGreen : Color.orange)
                }
            }
            .frame(width: 160, alignment: .leading)
            .padding(14)
            .background(isSelected ? Color.shopNeonGreen.opacity(0.15) : Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.shopNeonGreen : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private func inStoreDirectionsAndQR(store: HikBikStore) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {
                let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude))
                let item = MKMapItem(placemark: placemark)
                item.name = store.name
                item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14))
                    Text("Get Directions")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(Color.deepSpaceBackground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.shopNeonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 8) {
                Text("Show this QR code to the staff in-store.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.8))
                ReturnDetailQRView(code: returnCode)
            }
        }
    }

    // MARK: - Deposit Counter
    private var refundStatusCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Security Deposit:")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.85))
                Text("$50.00")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.shopNeonGreen)
            }
            HStack(spacing: 8) {
                Image(systemName: refundStatusIcon)
                    .font(.system(size: 18))
                    .foregroundStyle(refundStatusColor)
                Text(refundStatusText)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.8))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.shopNeonGreen.opacity(0.35), lineWidth: 1)
        )
    }

    private var refundStatusText: String {
        if currentOrder.status == .completed && currentOrder.isDepositRefunded == true {
            return "The $50 deposit has been credited back to your original payment method."
        }
        if currentOrder.status == .returning || currentOrder.status == .received {
            return "Waiting for inspection. Refund will be processed after we receive and check the items."
        }
        return "Waiting for inspection."
    }

    private var refundStatusIcon: String {
        if currentOrder.status == .completed && currentOrder.isDepositRefunded == true {
            return "checkmark.circle.fill"
        }
        return "clock.badge.checkmark"
    }

    private var refundStatusColor: Color {
        if currentOrder.status == .completed && currentOrder.isDepositRefunded == true {
            return Color(hex: "22C55E")
        }
        return Color.shopNeonGreen
    }

    // MARK: - 底部按鈕（POST /api/v1/returns，成功後更新訂單狀態；Mail-back 時展示 label_url）
    private var confirmButton: some View {
        VStack(spacing: 12) {
            Button {
                Task { await submitReturnAndUpdateUI() }
            } label: {
                HStack(spacing: 8) {
                    if isSubmittingReturn {
                        ProgressView()
                            .tint(Color.deepSpaceBackground)
                    } else {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.system(size: 18))
                        Text("Confirm & Start Return Process")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                }
                .foregroundStyle(Color.deepSpaceBackground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.shopNeonGreen)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .disabled(isSubmittingReturn)
            if let err = returnSubmitError {
                Text(err)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.red.opacity(0.9))
            }
        }
    }

    /// 調用 ReturnService.submitReturn，成功後更新 Mock 訂單狀態；Mail-back 時若後端返回 label_url 則展示下載
    private func submitReturnAndUpdateUI() async {
        isSubmittingReturn = true
        returnSubmitError = nil
        let method: ReturnMethodAPI
        switch selectedMode {
        case .mailBack: method = .mailBack
        case .homePickup: method = .schedulePickup
        case .inStore: method = .dropOffAtStore
        }
        let pickupDTO: PickupAddressDTO? = (selectedMode == .mailBack || selectedMode == .homePickup)
            ? PickupAddressDTO(
                recipientName: pickupAddress.recipientName,
                phone: pickupAddress.phoneCountryCode + " " + pickupAddress.phone,
                street: pickupAddress.street + (pickupAddress.apartmentOrSuite.isEmpty ? "" : ", \(pickupAddress.apartmentOrSuite)"),
                city: pickupAddress.city,
                state: pickupAddress.state,
                zip: pickupAddress.zip
            )
            : nil
        let storeId = selectedMode == .inStore ? selectedStoreForReturn?.id : nil
        do {
            let response = try await returnService.submitReturn(orderId: currentOrder.id, returnMethod: method, pickupAddress: pickupDTO, storeId: storeId)
            await MainActor.run {
                viewModel.startMockReturnFlow(for: currentOrder.id)
                if selectedMode == .mailBack, let url = response.labelUrl, !url.isEmpty {
                    generatedLabel = ShippingLabel(
                        id: currentOrder.id + "-label",
                        trackingNumber: response.trackingNumber ?? "",
                        carrierName: "Return Label",
                        labelURL: url,
                        estimatedArrival: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
                    )
                }
            }
        } catch {
            await MainActor.run {
                returnSubmitError = error.localizedDescription
            }
        }
        await MainActor.run {
            isSubmittingReturn = false
        }
    }

    /// Mail-back / Home Pickup：面單生成模擬（ProgressView + 成功後預覽/下載）
    private var returnLabelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Return Label")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            if isGeneratingLabel {
                HStack(spacing: 12) {
                    ProgressView()
                        .tint(Color.shopNeonGreen)
                    Text("Generating Shipping Label...")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if let label = generatedLabel {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.shopNeonGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(label.carrierName)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.white)
                            Text("Tracking: \(label.trackingNumber)")
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                        Spacer()
                    }
                    Text("Est. arrival: \(label.estimatedArrival.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.6))
                    Button {
                        if let url = URL(string: label.labelURL) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 16))
                            Text("Download Return Label")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(Color.deepSpaceBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.shopNeonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .background(cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.shopNeonGreen.opacity(0.3), lineWidth: 1)
                )
            } else {
                Button {
                    Task {
                        isGeneratingLabel = true
                        let mode: ReturnLabelMode = selectedMode == .homePickup ? .homePickup : .mailBack
                        let label = await shippingService.generateReturnLabel(orderId: currentOrder.id, mode: mode)
                        await MainActor.run {
                            isGeneratingLabel = false
                            generatedLabel = label
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 16))
                        Text("Generate Return Label")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(Color.deepSpaceBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.shopNeonGreen.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - 修改取件地址 Sheet（三選項：原下單地址 / GPS 模擬 / 新增地址）
private struct ChangePickupAddressSheet: View {
    let order: Order
    @Binding var currentAddress: PickupAddress
    var onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showNewAddressForm = false
    @State private var newName = ""
    @State private var newPhoneCountryCode = "+1"
    @State private var newPhone = ""
    @State private var newEmail = ""
    @State private var newStreet = ""
    @State private var newApartmentOrSuite = ""
    @State private var newCity = ""
    @State private var newState = ""
    @State private var newZip = ""

    private var cardBg: Color { Color(uiColor: .secondarySystemBackground) }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        currentAddress = PickupAddress.fromOrder(order)
                        dismiss()
                    } label: {
                        HStack {
                            Label("Use order address", systemImage: "shippingbox.fill")
                                .foregroundStyle(Color.white)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.shopNeonGreen)
                                .opacity(isOrderAddressSelected ? 1 : 0)
                        }
                    }
                    .listRowBackground(cardBg)
                    .listRowSeparatorTint(Color.white.opacity(0.2))

                    Button {
                        currentAddress = PickupAddress.gpsSimulated()
                        dismiss()
                    } label: {
                        HStack {
                            Label("Use current location (simulated)", systemImage: "location.fill")
                                .foregroundStyle(Color.white)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.shopNeonGreen)
                                .opacity(isGpsSelected ? 1 : 0)
                        }
                    }
                    .listRowBackground(cardBg)
                    .listRowSeparatorTint(Color.white.opacity(0.2))

                    Button {
                        showNewAddressForm = true
                    } label: {
                        Label("Add new pickup address", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.shopNeonGreen)
                    }
                    .listRowBackground(cardBg)
                    .listRowSeparatorTint(Color.white.opacity(0.2))
                } header: {
                    Text("Choose pickup address")
                        .foregroundStyle(Color.white.opacity(0.7))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.deepSpaceBackground)
            .navigationTitle("Change Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.deepSpaceBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss(); onDismiss() }
                        .foregroundStyle(Color.shopNeonGreen)
                }
            }
            .sheet(isPresented: $showNewAddressForm) {
                newAddressFormView
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var isOrderAddressSelected: Bool {
        currentAddress.recipientName == PickupAddress.fromOrder(order).recipientName
            && currentAddress.street == PickupAddress.fromOrder(order).street
    }

    private var isGpsSelected: Bool {
        currentAddress.street == PickupAddress.gpsSimulated().street
    }

    private var newAddressFormView: some View {
        NewPickupAddressFormView(
            name: $newName,
            phoneCountryCode: $newPhoneCountryCode,
            phone: $newPhone,
            email: $newEmail,
            street: $newStreet,
            apartmentOrSuite: $newApartmentOrSuite,
            city: $newCity,
            state: $newState,
            zip: $newZip,
            onCancel: { showNewAddressForm = false },
            onConfirm: {
                currentAddress = PickupAddress(
                    recipientName: newName,
                    phoneCountryCode: newPhoneCountryCode,
                    phone: newPhone,
                    email: newEmail.trimmingCharacters(in: .whitespaces),
                    street: newStreet,
                    apartmentOrSuite: newApartmentOrSuite,
                    city: newCity,
                    state: newState,
                    zip: newZip
                )
                showNewAddressForm = false
                onDismiss()
            },
            canConfirm: newAddressFormCanConfirm
        )
        .onAppear {
            newName = currentAddress.recipientName
            newPhoneCountryCode = currentAddress.phoneCountryCode.isEmpty ? "+1" : currentAddress.phoneCountryCode
            newPhone = currentAddress.phone
            newEmail = currentAddress.email
            newStreet = currentAddress.street
            newApartmentOrSuite = currentAddress.apartmentOrSuite
            newCity = currentAddress.city
            newState = currentAddress.state
            newZip = currentAddress.zip
        }
    }

    private var newAddressFormCanConfirm: Bool {
        let streetOk = !newStreet.trimmingCharacters(in: .whitespaces).isEmpty
        let emailTrimmed = newEmail.trimmingCharacters(in: .whitespaces)
        let emailOk = emailTrimmed.isEmpty || (emailTrimmed.contains("@") && emailTrimmed.firstIndex(of: "@")! > emailTrimmed.startIndex && emailTrimmed.lastIndex(of: "@")! < emailTrimmed.index(before: emailTrimmed.endIndex))
        return streetOk && emailOk
    }
}

// MARK: - 新增取件地址表單（國際化：Contact Info + Pickup Address、區號選擇器、Email、上標籤下內容、地圖、底部確認）
private struct NewPickupAddressFormView: View {
    @Binding var name: String
    @Binding var phoneCountryCode: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var street: String
    @Binding var apartmentOrSuite: String
    @Binding var city: String
    @Binding var state: String
    @Binding var zip: String
    var onCancel: () -> Void
    var onConfirm: () -> Void
    var canConfirm: Bool
    @Environment(\.dismiss) private var dismiss

    /// 與 Checkout 地址編輯器一致：deepSpaceCard、圓角 12、輸入框圓角 8、字體粗細與 Checkout 一致
    private var sectionBg: Color { Color.deepSpaceCard }
    private let sectionCorner: CGFloat = 12
    private static let inputCorner: CGFloat = 8
    private static let labelFontSize: CGFloat = 12
    private static let inputFontSize: CGFloat = 15
    private static let mockMapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    contactInfoSection
                    pickupAddressSection
                }
                .padding(20)
                .padding(.bottom, 16)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.deepSpaceBackground)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                confirmButton
            }
            .navigationTitle("New Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                        .foregroundStyle(Color.white.opacity(0.9))
                }
            }
        }
    }

    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Contact Info")
                .font(.system(size: Self.labelFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
                .padding(.bottom, 12)
            labeledField(label: "Name", text: $name)
            divider
            phoneField
            divider
            labeledField(label: "Email Address", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBg)
        .clipShape(RoundedRectangle(cornerRadius: sectionCorner))
    }

    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Phone Number")
                .font(.system(size: Self.labelFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
            HStack(spacing: 10) {
                Menu {
                    ForEach(PhoneCountryCode.options) { option in
                        Button(option.display) { phoneCountryCode = option.code }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(phoneCountryCode)
                            .font(.system(size: Self.inputFontSize, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.65))
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Self.inputCorner))
                    .overlay(RoundedRectangle(cornerRadius: Self.inputCorner).stroke(Color.white.opacity(0.16), lineWidth: 1))
                }
                TextField("", text: $phone)
                    .font(.system(size: Self.inputFontSize, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white)
                    .keyboardType(.phonePad)
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Self.inputCorner))
                    .overlay(RoundedRectangle(cornerRadius: Self.inputCorner).stroke(Color.white.opacity(0.16), lineWidth: 1))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var pickupAddressSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Pickup Address")
                .font(.system(size: Self.labelFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
                .padding(.bottom, 12)
            Map(initialPosition: .region(Self.mockMapRegion), interactionModes: [])
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: Self.inputCorner))
                .padding(.bottom, 16)
            labeledField(label: "Street", text: $street)
            divider
            labeledField(label: "Apartment / Suite", text: $apartmentOrSuite)
            divider
            stateRow
            divider
            labeledField(label: "City", text: $city, autocapitalization: .words)
            divider
            labeledField(label: "ZIP Code", text: $zip, keyboard: .numberPad)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBg)
        .clipShape(RoundedRectangle(cornerRadius: sectionCorner))
    }

    /// 州選擇器 100% 使用 Menu（Picker），絕不使用 TextField，避免誤彈鍵盤
    @ViewBuilder
    private var stateRow: some View {
        statePickerRow
    }

    /// 純 Menu 觸發器：點擊只彈州名菜單，不響應焦點、不彈鍵盤；與 Checkout 輸入框樣式一致（圓角 8、邊框）
    private var statePickerRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("State")
                .font(.system(size: Self.labelFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
            Menu {
                ForEach(USStatePickerData.stateNames, id: \.self) { s in
                    Button(s) { state = s }
                }
            } label: {
                HStack {
                    Text(state.isEmpty ? "Select State" : state)
                        .font(.system(size: Self.inputFontSize, weight: .regular, design: .rounded))
                        .foregroundStyle(state.isEmpty ? Color.white.opacity(0.5) : Color.white)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.65))
                }
                .padding(12)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Self.inputCorner))
                .overlay(RoundedRectangle(cornerRadius: Self.inputCorner).stroke(Color.white.opacity(0.16), lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .allowsHitTesting(true)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(height: 1)
            .padding(.vertical, 12)
    }

    private func labeledField(label: String, text: Binding<String>, autocapitalization: UITextAutocapitalizationType = .sentences, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: Self.labelFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
            TextField("", text: text)
                .font(.system(size: Self.inputFontSize, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white)
                .padding(12)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Self.inputCorner))
                .overlay(RoundedRectangle(cornerRadius: Self.inputCorner).stroke(Color.white.opacity(0.16), lineWidth: 1))
                .keyboardType(keyboard)
                .autocapitalization(autocapitalization)
        }
    }

    private var confirmButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)
            Button(action: onConfirm) {
                Text("Confirm This Address")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.deepSpaceBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(canConfirm ? Color.shopNeonGreen : Color.shopNeonGreen.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .disabled(!canConfirm)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(Color.deepSpaceBackground)
        }
    }
}

// MARK: - Return QR（歸還唯一碼生成 QR 圖）
private struct ReturnDetailQRView: View {
    let code: String
    private let size: CGFloat = 180

    var body: some View {
        if let image = qrImage(from: code) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: "qrcode")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.white.opacity(0.4))
                )
        }
    }

    private func qrImage(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 8, y: 8))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

#Preview {
    NavigationStack {
        ReturnDetailView(
            order: Order(
                id: "p",
                orderNumber: "ORD-2026-RENT-1",
                date: Date(),
                status: .renting,
                total: "$49.99",
                items: [OrderItem(id: "i1", name: "Trail Running Shoes", quantity: 1, price: "$49.99")],
                orderType: .rent,
                rentalPeriod: RentalPeriod(start: Date(), end: Date()),
                returnMethod: .selfShip,
                pickupFee: nil
            ),
            mockAPI: MockAPIService.shared
        )
    }
}
