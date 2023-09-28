
import XCTest
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

final class LoadingViewTests: XCTestCase, SnapshotUITest {
    
    // TODO: JLI
    // .background(.ultraThinMaterial)
    // ???
    
    private let view = LoadingView()
    
    override func setUpWithError() throws {
        try super.setUpWithError()

//        isRecording = true
    }

    func test_LoadingView_default_returnsSnapshot() {
        assertSnapshot(
            matching: LoadingView(),
            as: .image
        )
    }
    
    func test_LoadingView_iPhone13MiniLight_returnsSnapshot() {
        testSutViewOnSmallDeviceLight(view: view)
        
//        assertSnapshot(
//            matching: view,
//            as: .image(
//                layout: .device(config: smallDevice),
//                traits: .init(userInterfaceStyle: .light)
//            )
//        )
    }
    
    func test_LoadingView_iPhone13MiniDark_returnsSnapshot() {
        testSutViewOnSmallDeviceDark(view: view)
    }
}
