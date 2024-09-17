import UIKit
import SwiftUI

struct Theme {

    static var isDarkMode: Bool {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }

    // MARK: Colors
    struct Colors {
        static let primary = R.color.green_200.color

        static let text = R.color.green_200.color
        static let secondaryText = R.color.white_custom.color

        static let buttonText = R.color.white_custom.color
        static let buttonBackground = R.color.green_500.color

        static let navIcon = R.color.white_custom.color

        static var background: Color {
            return Theme.isDarkMode ? R.color.gray_custom.color : R.color.white_custom.color
        }
    }

    // MARK: Fonts
    struct Fonts {

        private enum FontStyle: String {
            case regular
            case medium
            case bold
            case extraBold
            case light

            var font: UIFont {
                // let fontName = "WubbaLubbaDubDub-\(rawValue.capitalized)"
                let fontName = "WubbaLubbaDubDubRegular"
                guard let font = UIFont(name: fontName, size: 14) else {
                    return UIFont.systemFont(ofSize: 14)
                }
                return font
            }
        }

        static let title = FontStyle.medium.font.fontWithSize(32)
        static let titleBold = FontStyle.bold.font.fontWithSize(32)
        static let title2 = FontStyle.medium.font.fontWithSize(24)
        static let title2Bold = FontStyle.bold.font.fontWithSize(24)

        static let subtitle = FontStyle.medium.font.fontWithSize(20)

        static let body = FontStyle.regular.font.fontWithSize(16)
        static let body2 = FontStyle.regular.font.fontWithSize(14)

        static let button = FontStyle.regular.font.fontWithSize(18)
    }

    // MARK: Space
    struct Space {
        private static let spacer: CGFloat = 8

        static let none: CGFloat = 0  // 0
        static let xs = spacer * 0.25  // 2
        static let s = spacer * 0.5  // 4
        static let m = spacer * 1  // 8
        static let l = spacer * 1.5  // 14
        static let xl = spacer * 2  // 16
        static let xxl = spacer * 3  // 24
        static let xxxl = spacer * 4  // 32
    }

    struct Radius {
        private static let spacer: CGFloat = 10

        static let none: CGFloat = 0  // 0
        static let xs = spacer * 0.25  // 2.5
        static let s = spacer * 0.5  // 5
        static let m = spacer * 1  // 10
        static let l = spacer * 1.5  // 15
        static let xl = spacer * 2  // 20
        static let xxl = spacer * 3  // 30
        static let xxxl = spacer * 4  // 40
    }
}
