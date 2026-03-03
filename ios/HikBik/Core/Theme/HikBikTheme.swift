// 与 Figma / globals.css 设计规范一致
import SwiftUI

// MARK: - 颜色（对应 :root）
extension Color {
    static let hikbikBackground = Color(hex: "FFFFFF")
    static let hikbikForeground = Color(hex: "252525")      // oklch(0.145 0 0) 近似
    static let hikbikPrimary = Color(hex: "030213")
    static let hikbikPrimaryForeground = Color.white
    static let hikbikSecondary = Color(hex: "F2F2F7")       // oklch(0.95...) 近似
    static let hikbikSecondaryForeground = Color(hex: "030213")
    static let hikbikMuted = Color(hex: "ECECF0")
    static let hikbikMutedForeground = Color(hex: "717182")
    static let hikbikAccent = Color(hex: "E9EBEF")
    static let hikbikAccentForeground = Color(hex: "030213")
    static let hikbikDestructive = Color(hex: "D4183D")
    static let hikbikDestructiveForeground = Color.white
    static let hikbikBorder = Color.black.opacity(0.1)
    static let hikbikInputBackground = Color(hex: "F3F3F5")
    static let hikbikCard = Color.white
    static let hikbikCardForeground = Color(hex: "252525")
    
    // Tab / 强调（与 Web 版绿色一致）
    static let hikbikTabActive = Color(hex: "10B981")
    static let hikbikTabActiveTint = Color(hex: "10B981").opacity(0.2)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - 圆角（对应 --radius: 0.625rem = 10pt）
struct HikBikRadius {
    static let sm: CGFloat = 6   // -4px
    static let md: CGFloat = 8   // -2px
    static let lg: CGFloat = 10  // 0.625rem
    static let xl: CGFloat = 14  // +4px
}

// MARK: - 字体（与 body / h1-h4 一致：SF Pro，medium 500 / normal 400）
struct HikBikFont {
    static func title() -> Font { .title2.weight(.medium) }
    static func titleLarge() -> Font { .title.weight(.medium) }
    static func headline() -> Font { .headline.weight(.medium) }
    static func body() -> Font { .body }
    static func callout() -> Font { .callout }
    static func caption() -> Font { .caption }
    static func caption2() -> Font { .caption2 }
}

// MARK: - 间距（与 Web 版统一）
struct HikBikSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
}
