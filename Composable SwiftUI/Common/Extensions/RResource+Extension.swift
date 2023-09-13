import SwiftUI
import RswiftResources

// MARK: - ImageResource
extension RswiftResources.ImageResource {
    var image: Image {
        Image(name)
    }
}

// MARK: - ColorResource
extension RswiftResources.ColorResource {
    var color: Color {
        Color(name)
    }
}

// MARK: - FontResource
extension FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(name, size: size)
    }
}

extension UIFont {
    func fontWithSize(_ size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}
