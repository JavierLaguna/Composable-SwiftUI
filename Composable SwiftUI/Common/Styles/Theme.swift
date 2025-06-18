import UIKit
import SwiftUI

struct Theme {

    // MARK: Colors
    struct Colors {
        static let primary = R.color.green_200.color

        static let text = Color(light: R.color.black_custom.color, dark: R.color.white_custom.color)
        static let secondaryText = R.color.white_custom.color

        static let buttonText = R.color.white_custom.color
        static let buttonBackground = R.color.green_500.color

        static let navIcon = R.color.white_custom.color

        static let background = Color(light: R.color.white_custom.color, dark: R.color.black_custom.color)
        static let backgroundSecondary = Color(light: R.color.white_custom.color, dark: R.color.gray_custom.color)
    }

    // MARK: Fonts
    struct Fonts {

        // .weight(.medium) is the default
        static private let fontName = "HelveticaNeue-CondensedBold"

        static let title: Font = .custom(fontName, size: 32)
        static let titleBold: Font = .custom(fontName, size: 32).weight(.heavy)
        static let title2: Font = .custom(fontName, size: 24)
        static let title2Bold: Font = .custom(fontName, size: 24).weight(.bold)

        static let subtitle: Font = .custom(fontName, size: 20)

        static let sectionTitle: Font = .custom(fontName, size: 16).weight(.black)

        static let body: Font = .custom(fontName, size: 16).weight(.regular)
        static let bodyBold: Font = .custom(fontName, size: 16).weight(.bold)
        static let body2: Font = .custom(fontName, size: 14).weight(.regular)
        static let body2Bold: Font = .custom(fontName, size: 14).weight(.bold)

        static let chip: Font = .custom(fontName, size: 12).weight(.heavy)

        static let button: Font = .custom(fontName, size: 18).weight(.regular)

        struct Special {
            static let font: UIFont = {
                let fontName = "WubbaLubbaDubDubRegular"
                guard let font = UIFont(name: fontName, size: 14) else {
                    return UIFont.systemFont(ofSize: 14)
                }
                return font
            }()

            static let title = Font(font.withSize(34))
            static let subtitle = Font(font.withSize(28))
            static let body = Font(font.withSize(18))
        }
    }

    // MARK: Space
    struct Space {
        private static let spacer: CGFloat = 8

        /** 0 */
        static let none: CGFloat = 0
        /** 2 */
        static let xs = spacer * 0.25
        /** 4 */
        static let s = spacer * 0.5
        /** 8 */
        static let m = spacer * 1
        /** 12 */
        static let l = spacer * 1.5
        /** 16 */
        static let xl = spacer * 2
        /** 24 */
        static let xxl = spacer * 3
        /** 32 */
        static let xxxl = spacer * 4
    }

    // MARK: Radius
    struct Radius {
        private static let spacer: CGFloat = 10

        /** 0 */
        static let none: CGFloat = 0
        /** 2.5 */
        static let xs = spacer * 0.25
        /** 5 */
        static let s = spacer * 0.5
        /** 10 */
        static let m = spacer * 1
        /** 15 */
        static let l = spacer * 1.5
        /** 20 */
        static let xl = spacer * 2
        /** 30 */
        static let xxl = spacer * 3
        /** 40 */
        static let xxxl = spacer * 4
    }
}
