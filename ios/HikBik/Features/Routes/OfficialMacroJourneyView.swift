// MARK: - 官方宏觀詳情頁模板（垂直鎖定 + 靜態地圖 + Day 列表鏈）
// 約定：純縱向 ScrollView，禁止 TabView / 橫向 ScrollView，無 X 軸偏移。
import SwiftUI
import MapKit

private let macroThemePurple = Color(hex: "A855F7")
private let macroThemeBackground = Color(hex: "0A0C10")
private let macroBlockPadding: CGFloat = 20
private let staticMapHeight: CGFloat = 220

struct OfficialMacroJourneyView: View {
    /// 可從 OfficialMacroRoute 轉成 template，或直接傳入 MacroJourneyTemplate
    let selectedRoute: OfficialMacroRoute
    @State private var isNavigating = false
    @State private var selectedDayIndex: Int? = nil

    private var journey: MacroJourneyTemplate {
        selectedRoute.toMacroJourneyTemplate()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            verticalLockedContainer
            startNavigationButton
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .fullScreenCover(isPresented: $isNavigating) {
            NavigationStack {
                OfficialMacroNavigationView(route: selectedRoute)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    /// 垂直鎖定容器：ScrollView(.vertical) + 100% 寬度，禁止水平滑動
    private var verticalLockedContainer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text(journey.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, macroBlockPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                staticHeaderMap
                dynamicDayList
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(macroThemeBackground)
    }

    /// 模板組件 A：靜態宏觀地圖（僅展示全路徑，不可拖拽/旋轉）
    private var staticHeaderMap: some View {
        Map(initialPosition: .region(regionForCoordinates(journey.coordinates)), interactionModes: []) {
            MapPolyline(coordinates: journey.coordinates)
                .stroke(macroThemePurple, lineWidth: selectedDayIndex != nil ? 4 : 3)
        }
        .mapStyle(.standard(elevation: .flat))
        .frame(height: staticMapHeight)
        .frame(maxWidth: .infinity)
        .allowsHitTesting(false)
    }

    /// 模板組件 B：動態 Day 列表（紫色細線連接的行程鏈）
    private var dynamicDayList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(journey.routes.enumerated()), id: \.element.id) { index, dayRoute in
                dayBlock(dayRoute: dayRoute, index: index, isLast: index == journey.routes.count - 1)
            }
        }
        .padding(.horizontal, macroBlockPadding)
        .padding(.top, 24)
        .padding(.bottom, 100)
    }

    private func dayBlock(dayRoute: DayRoute, index: Int, isLast: Bool) -> some View {
        let isSelected = selectedDayIndex == index
        return Button {
            selectedDayIndex = index
        } label: {
            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 0) {
                    Text("Day \(dayRoute.day)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(macroThemePurple)
                    if !isLast {
                        Rectangle()
                            .fill(macroThemePurple.opacity(0.5))
                            .frame(width: 2, height: 20)
                    }
                }
                .frame(width: 44, alignment: .center)

                VStack(alignment: .leading, spacing: 8) {
                    Text("\(dayRoute.from) → \(dayRoute.to)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 16) {
                        Label(dayRoute.duration, systemImage: "clock")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                        Label(dayRoute.distance, systemImage: "point.topleft.down.to.point.bottomright.curvedpath")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.white.opacity(isSelected ? 0.1 : 0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isSelected ? macroThemePurple.opacity(0.8) : Color.clear, lineWidth: 2)
                )
            }
        }
        .buttonStyle(.plain)
    }

    private func regionForCoordinates(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coords.isEmpty else {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.4, longitude: -111.5), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
        let lats = coords.map(\.latitude), lons = coords.map(\.longitude)
        let minLat = lats.min() ?? 0, maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0, maxLon = lons.max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.4, 0.05),
            longitudeDelta: max((maxLon - minLon) * 1.4, 0.05)
        )
        return MKCoordinateRegion(center: center, span: span)
    }

    private var startNavigationButton: some View {
        Button {
            AuthGuard.run(message: AuthGuardMessages.startNavigation) {
                isNavigating = true
            }
        } label: {
            Text("Start Navigation")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [macroThemePurple, macroThemePurple.opacity(0.75)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, macroBlockPadding)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(macroThemeBackground)
    }
}
