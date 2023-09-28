
import XCTest
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

final class ErrorViewTests: XCTest {
        
//    private let error = InteractorError.generic(message: "Algo ha fallado")
//    private let onRetry: () -> Void = {}
//    private let view: ErrorView
//    
//    override init() {
//        view =
//    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()

//        isRecording = true
    }
    
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

