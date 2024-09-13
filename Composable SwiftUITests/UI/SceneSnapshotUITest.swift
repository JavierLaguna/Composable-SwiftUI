import SwiftUI
import SnapshotTesting

@MainActor
class SceneSnapshotUITest {

    enum Device: String, CaseIterable {
        case image
        case iPhoneSmallest = "iPhoneSe"
        case iPhoneSmall = "iPhone13Mini"
        case iPhoneMedium = "iPhoneX"
        case iPhoneBig = "iPhone13Pro"
        case iPhoneBigest = "iPhone13ProMax"
    }

    enum UIStyle: String, CaseIterable {
        case light
        case dark
    }

    func execute(view: some View, testName: String, file: StaticString) {
        assertSnapshot(
            of: view,
            as: .image,
            file: file, // TODO: JLI - Class var ?
            testName: testName
        )
    }
}
