
import XCTest
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

final class ErrorViewTests: XCTestCase {
        
    private let error = InteractorError.generic(message: "Algo ha fallado")
    private let onRetry: () -> Void = {}
    
    override func setUpWithError() throws {
        try super.setUpWithError()

//        isRecording = true
    }
    
    func test_ErrorView_iPhone13MiniLight_returnsSnapshot() {
        assertSnapshot(
            matching: ErrorView(error: error, onRetry: onRetry),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_ErrorView_iPhone13MiniDark_returnsSnapshot() {
        assertSnapshot(
            matching: ErrorView(error: error, onRetry: onRetry),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
}
