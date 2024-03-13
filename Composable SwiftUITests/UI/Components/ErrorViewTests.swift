import XCTest
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

// TODO: JLI
final class ErrorViewTests: XCTest {

//    func test_ErrorView_iPhone13MiniLight_returnsSnapshot() {
//        let sut = testSutViewOnSmallDeviceLight(view: ErrorView(error: error, onRetry: onRetry))
//        sut()
//    }

//    func test_ErrorView_iPhone13MiniDark_returnsSnapshot() {
//        assertSnapshot(
//            matching: ErrorView(error: error, onRetry: onRetry),
//            as: .image(
//                layout: .device(config: .iPhone13Mini),
//                traits: .init(userInterfaceStyle: .light)
//            )
//        )
//    }

    func testNew() {
        assertSnapshot(
            matching: LoadingView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
}
