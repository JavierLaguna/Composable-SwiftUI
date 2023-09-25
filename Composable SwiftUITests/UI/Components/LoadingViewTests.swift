
import XCTest
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

final class LoadingViewTests: XCTestCase {
    
    // TODO: JLI
    // .background(.ultraThinMaterial)
    // ???
        
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
        assertSnapshot(
            matching: LoadingView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_ErrorView_iPhone13MiniDark_returnsSnapshot() {
        assertSnapshot(
            matching: LoadingView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
}
