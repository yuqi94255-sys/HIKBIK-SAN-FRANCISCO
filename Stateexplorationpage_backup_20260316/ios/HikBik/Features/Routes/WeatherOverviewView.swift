// MARK: - Live Weather Component — Sheet 內實時天氣（Stats Bar 下方）
import SwiftUI

/// 實時天氣組件：深色磨砂 (.ultraThinMaterial)、圓角 16。圖標 + 氣溫 + 風速 + 降水概率；
/// National Grassland 優先突出 Wind Speed；National Recreation Area 顯示 Water Temp（接口已預留）。
struct WeatherOverviewView: View {
    let snapshot: WeatherSnapshot
    var category: DetailedTrackCategory?
    var accentColor: Color = Color(hex: "2D5A27")

    @State private var iconScale: CGFloat = 1.0
    @State private var iconOpacity: Double = 1.0
    @State private var iconOffsetY: CGFloat = 0

    private var isGrassland: Bool { category == .nationalGrassland }
    private var isNRA: Bool { category == .nationalRecreationArea }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            weatherIconView
            VStack(alignment: .leading, spacing: 6) {
                if isGrassland {
                    windRow
                    tempAndPrecipRow
                } else {
                    tempAndPrecipRow
                    windRow
                }
                if isNRA, let water = snapshot.waterTempDisplay {
                    waterTempRow(value: water)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
        .onAppear { startIconAnimation() }
    }

    private var weatherIconView: some View {
        Image(systemName: snapshot.conditionSymbol)
            .font(.system(size: 36, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(accentColor)
            .scaleEffect(iconScale)
            .opacity(iconOpacity)
            .offset(y: iconOffsetY)
    }

    private var tempAndPrecipRow: some View {
        HStack(spacing: 10) {
            Text(snapshot.temperatureDisplay)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(snapshot.conditionDescription)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.secondary)
            Text("·")
                .foregroundStyle(Color.secondary)
            Text("Precip \(snapshot.precipitationDisplay)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
    }

    private var windRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "wind")
                .font(.system(size: isGrassland ? 16 : 14))
                .foregroundStyle(isGrassland ? accentColor : Color.secondary)
            Text(snapshot.windDisplay)
                .font(.system(size: isGrassland ? 16 : 14, weight: .semibold))
                .foregroundStyle(isGrassland ? .white : Color.secondary)
        }
    }

    private func waterTempRow(value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "water.waves")
                .font(.system(size: 14))
                .foregroundStyle(accentColor)
            Text("Water \(value)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.secondary)
        }
    }

    private func startIconAnimation() {
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            iconScale = 1.08
            iconOpacity = 0.92
        }
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            iconOffsetY = 3
        }
    }
}
