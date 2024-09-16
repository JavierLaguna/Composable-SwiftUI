import SwiftUI
import SnapshotTesting

@MainActor
class SceneSnapshotUITest {

    var file: StaticString {
        #filePath
    }

    func execute(view: some View, snapshotType: SnapshotType, name: String) {
        let layout = snapshotType.layout
        let testName = "\(name)_\(snapshotType.layoutName)_snapshot"
        assertSnapshot(
            of: view,
            as: layout == nil ? .image : .image(
                layout: layout!
//                traits: .init(userInterfaceStyle: .light)
            ),
            file: file,
            testName: testName
        )
    }
}

extension SceneSnapshotUITest {

    enum SnapshotType: CaseIterable {
        case image
        case iPhoneSmallest
        case iPhoneSmall
        case iPhoneMedium
        case iPhoneBig
        case iPhoneBigest

        var layout: SwiftUISnapshotLayout? {
            self == .image ? nil : .device(config: device ?? defaultDevice)
        }

        var defaultDevice: ViewImageConfig {
            .iPhone12
        }

        var device: ViewImageConfig? {
            switch self {
            case .image: nil
            case .iPhoneSmallest: .iPhoneSe
            case .iPhoneSmall: .iPhone13Mini
            case .iPhoneMedium: .iPhone12
            case .iPhoneBig: .iPhone13Pro
            case .iPhoneBigest: .iPhone13ProMax
            }
        }

        var layoutName: String {
            switch self {
            case .image: "image"
            case .iPhoneSmallest: "iPhoneSe"
            case .iPhoneSmall: "iPhone13Mini"
            case .iPhoneMedium: "iPhone12"
            case .iPhoneBig: "iPhone13Pro"
            case .iPhoneBigest: "iPhone13ProMax"
            }
        }
    }

    enum UIStyle: String, CaseIterable {
        case light
        case dark
    }
}
