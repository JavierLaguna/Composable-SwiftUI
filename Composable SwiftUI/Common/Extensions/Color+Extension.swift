import SwiftUI

extension Color {

    init(light: UIColor, dark: UIColor) {
        self = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        })
    }

    init(light: Color, dark: Color) {
        let uiColor = UIColor { traitCollection in
            let resolvedLight = UIColor(light)
            let resolvedDark = UIColor(dark)
            return traitCollection.userInterfaceStyle == .dark ? resolvedDark : resolvedLight
        }
        self = Color(uiColor)
    }
}
