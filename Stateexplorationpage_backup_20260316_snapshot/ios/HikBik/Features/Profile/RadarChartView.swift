// 5-axis Performance Radar – Distance, Elevation, Wilderness, Frequency, Exploration
import SwiftUI

struct RadarChartView: View {
    let values: [Double]  // 5 values 0...1
    let labels: [String]
    var lineColor: Color = Color(hex: "39FF14")
    var fillColor: Color = Color(hex: "39FF14").opacity(0.35)
    var axisColor: Color = Color(hex: "8E8E93").opacity(0.4)
    var labelColor: Color = Color(hex: "8E8E93")
    @State private var animatedScale: CGFloat = 0

    private let sides = 5
    private let size: CGFloat = 160

    private var isEmpty: Bool {
        values.count >= sides && values.allSatisfy { $0 < 0.05 }
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 28
            ZStack {
                // Faint grid background when radar is empty
                if isEmpty {
                    ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { level in
                        polygonPath(center: center, radius: radius * level, sides: sides)
                            .stroke(axisColor.opacity(0.15), lineWidth: 1)
                    }
                    ForEach(0..<sides, id: \.self) { i in
                        let angle = angleForIndex(i)
                        let end = pointOnCircle(center: center, radius: radius, angle: angle)
                        Path { p in
                            p.move(to: center)
                            p.addLine(to: end)
                        }
                        .stroke(axisColor.opacity(0.12), lineWidth: 1)
                    }
                }
                // Grid layers (normal)
                ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { level in
                    polygonPath(center: center, radius: radius * level * animatedScale, sides: sides)
                        .stroke(axisColor, lineWidth: 0.8)
                }
                // Axes
                ForEach(0..<sides, id: \.self) { i in
                    let angle = angleForIndex(i)
                    let end = pointOnCircle(center: center, radius: radius * animatedScale, angle: angle)
                    Path { p in
                        p.move(to: center)
                        p.addLine(to: end)
                    }
                    .stroke(axisColor, lineWidth: 0.8)
                }
                // Data fill with neon glow
                if values.count >= sides {
                    radarPolygon(center: center, radius: radius * animatedScale)
                        .fill(
                            RadialGradient(
                                colors: [fillColor.opacity(0.6), fillColor.opacity(0.2), fillColor.opacity(0.05)],
                                center: .center,
                                startRadius: 0,
                                endRadius: radius * animatedScale
                            )
                        )
                    radarPolygon(center: center, radius: radius * animatedScale)
                        .fill(fillColor)
                        .blur(radius: 8)
                        .opacity(0.7)
                    radarPolygon(center: center, radius: radius * animatedScale)
                        .stroke(lineColor, lineWidth: 2)
                    radarPolygon(center: center, radius: radius * animatedScale)
                        .stroke(lineColor.opacity(0.8), lineWidth: 4)
                        .blur(radius: 6)
                        .opacity(0.5)
                }
                // Labels
                ForEach(Array(labels.prefix(sides).enumerated()), id: \.offset) { i, label in
                    let angle = angleForIndex(i)
                    let r = radius * animatedScale + 22
                    let p = pointOnCircle(center: center, radius: r, angle: angle)
                    Text(label)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundStyle(labelColor)
                        .position(p)
                }
            }
        }
        .frame(width: size + 80, height: size + 80)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedScale = 1
            }
        }
    }

    private func angleForIndex(_ i: Int) -> Double {
        -.pi / 2 + (Double(i) / Double(sides)) * 2 * .pi
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        CGPoint(
            x: center.x + radius * CGFloat(cos(angle)),
            y: center.y + radius * CGFloat(sin(angle))
        )
    }

    private func polygonPath(center: CGPoint, radius: CGFloat, sides: Int) -> Path {
        var p = Path()
        let start = pointOnCircle(center: center, radius: radius, angle: angleForIndex(0))
        p.move(to: start)
        for i in 1..<sides {
            p.addLine(to: pointOnCircle(center: center, radius: radius, angle: angleForIndex(i)))
        }
        p.closeSubpath()
        return p
    }

    private func radarPolygon(center: CGPoint, radius: CGFloat) -> Path {
        var p = Path()
        guard values.count >= sides else { return p }
        for i in 0..<sides {
            let v = max(0, min(1, values[i]))
            let r = radius * CGFloat(v)
            let pt = pointOnCircle(center: center, radius: r, angle: angleForIndex(i))
            if i == 0 { p.move(to: pt) }
            else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}
