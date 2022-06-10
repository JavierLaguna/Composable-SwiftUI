import Rswift
import SwiftUI

// MARK: - ImageResource
extension ImageResource {
    var image: Image {
        Image(name)
    }
}

// MARK: - ColorResource
extension ColorResource {
    var color: Color {
        Color(name)
    }
}

// MARK: - FontResource
extension FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}

extension UIFont {
    func fontWithSize(_ size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}
