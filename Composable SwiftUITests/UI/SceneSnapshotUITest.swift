import SwiftUI
import SnapshotTesting

@MainActor
class SceneSnapshotUITest {

    var file: StaticString {
        #filePath
    }

    func execute(
        name: String,
        view: some View,
        variant: Variant
    ) {
        let testName = "\(name)_\(variant.layoutName)_snapshot"

        switch variant {
        case .image:
            assertSnapshot(
                of: view,
                as: .image,
                file: file,
                testName: testName
            )

        case let .device(device, uiStyle):
            assertSnapshot(
                of: view,
                as: .image(
                    layout: device.layout,
                    traits: .init(userInterfaceStyle: uiStyle.userInterfaceStyle)
                ),
                file: file,
                testName: testName
            )
        }
    }
}

// MARK: Variant
extension SceneSnapshotUITest {

    enum Variant {
        case image
        case device(Device, uiStyle: UIStyle)

        static var allVariants: [Variant] {
            var variants: [Variant] = [.image]

            Device.allCases.forEach { device in
                UIStyle.allCases.forEach { style in
                    variants.append(.device(device, uiStyle: style)
                    )
                }
            }

            return variants
        }

        var layoutName: String {
            switch self {
            case .image:
                "image"
            case let .device(device, uiStyle):
                "\(device.layoutName)_\(uiStyle.rawValue)"
            }
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

        var layout: SwiftUISnapshotLayout {
            .device(config: viewImageConfig)
        }

        var viewImageConfig: ViewImageConfig {
            switch self {
            case .iPhoneSmallest: .iPhoneSe
            case .iPhoneSmall: .iPhone13Mini
            case .iPhoneMedium: .iPhone12
            case .iPhoneBig: .iPhone13Pro
            case .iPhoneBigest: .iPhone13ProMax
            }
        }

        var layoutName: String {
            switch self {
            case .iPhoneSmallest: "iPhoneSe"
            case .iPhoneSmall: "iPhone13Mini"
            case .iPhoneMedium: "iPhone12"
            case .iPhoneBig: "iPhone13Pro"
            case .iPhoneBigest: "iPhone13ProMax"
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
