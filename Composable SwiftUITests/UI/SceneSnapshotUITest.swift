import Testing
import SwiftUI
import SnapshotTesting

// IMPORTANT: Run tests using iPhone 16 Pro (18.0)

@MainActor
class SceneSnapshotUITest {

    var file: StaticString {
        #filePath
    }

    var precision: Float = 0.98

    func execute(
        name: String,
        view: some View,
        variant: Variant,
        record: Bool = false
    ) {
        let testName = "\(name)_\(variant.layoutName)_snapshot"

        switch variant {
        case .image:
            assertSnapshot(
                of: view,
                as: .image(precision: precision),
                record: record,
                file: file,
                testName: testName
            )

        case let .device(device, uiStyle, orientation):
            assertSnapshot(
                of: view,
                as: .image(
                    precision: precision,
                    layout: device.layout(orientation: orientation),
                    traits: .init(userInterfaceStyle: uiStyle.userInterfaceStyle)
                ),
                record: record,
                file: file,
                testName: testName
            )
        }
    }
}

// MARK: Variant
extension SceneSnapshotUITest {

    enum Variant: CustomTestStringConvertible {
        case image
        case device(Device, uiStyle: UIStyle, orientation: ViewImageConfig.Orientation = .portrait)

        static var allVariants: [Variant] {
            let orientations: [ViewImageConfig.Orientation] = [.portrait, .landscape]
            var variants: [Variant] = [.image]

            Device.allCases.forEach { device in
                UIStyle.allCases.forEach { style in
                    orientations.forEach { orientation in
                        variants.append(.device(device, uiStyle: style, orientation: orientation))
                    }
                }
            }

            return variants
        }

        var layoutName: String {
            switch self {
            case .image:
                "image"
            case let .device(device, uiStyle, orientation):
                "\(device.layoutName)_\(uiStyle.rawValue)_\(orientation)"
            }
        }

        var testDescription: String {
            layoutName.replacingOccurrences(of: "_", with: " ")
        }
    }
}

// MARK: Device
extension SceneSnapshotUITest {

    enum Device: CaseIterable {
        case iPhoneSmallest
        case iPhoneSmall
        case iPhoneMedium
        case iPhoneBig
        case iPhoneBigest

        var layoutName: String {
            switch self {
            case .iPhoneSmallest: "iPhoneSE"
            case .iPhoneSmall: "iPhone13Mini"
            case .iPhoneMedium: "iPhone12"
            case .iPhoneBig: "iPhone13Pro"
            case .iPhoneBigest: "iPhone13ProMax"
            }
        }

        func layout(orientation: ViewImageConfig.Orientation = .portrait) -> SwiftUISnapshotLayout {
            .device(config: viewImageConfig(orientation: orientation))
        }

        private func viewImageConfig(orientation: ViewImageConfig.Orientation) -> ViewImageConfig {
            switch self {
            case .iPhoneSmallest: .iPhoneSe(orientation)
            case .iPhoneSmall: .iPhone13Mini(orientation)
            case .iPhoneMedium: .iPhone12(orientation)
            case .iPhoneBig: .iPhone13Pro(orientation)
            case .iPhoneBigest: .iPhone13ProMax(orientation)
            }
        }
    }
}

// MARK: UIStyle
extension SceneSnapshotUITest {

    enum UIStyle: String, CaseIterable {
        case light
        case dark

        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .light: .light
            case .dark: .dark
            }
        }
    }
}
