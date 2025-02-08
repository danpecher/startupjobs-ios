import SwiftUI

struct Fonts {
    static let note = Font.custom(
        StartupJobsFontFamily.FunnelDisplay.light.name,
        size: UIFontMetrics.default.scaledValue(for: 12)
    )
    static let regular = Font.custom(
        StartupJobsFontFamily.FunnelDisplay.regular.name,
        size: UIFontMetrics.default.scaledValue(for: 14)
    )
    static let regularBold = Font.custom(
        StartupJobsFontFamily.FunnelDisplay.bold.name,
        size: UIFontMetrics.default.scaledValue(for: 14)
    )
    static let title = Font.custom(
        StartupJobsFontFamily.FunnelDisplay.bold.name,
        size: UIFontMetrics.default.scaledValue(for: 17)
    )
    static let titleXL = Font.custom(
        StartupJobsFontFamily.FunnelDisplay.bold.name,
        size: UIFontMetrics.default.scaledValue(for: 22)
    )
}
