import Testing
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

@Suite("ErrorView")
final class ErrorViewTests: SceneSnapshotUITest {

    private let error = InteractorError.generic(message: "Algo ha fallado")
    private let onRetry: () -> Void = {
        // Intentionally empty
    }

    @Test
    func errorView_genericError_image_snapshot() async throws {
        execute(
            view: ErrorView(error: error, onRetry: onRetry),
            testName: "errorView_genericError_image_snapshot",
            file: #filePath
        )
    }

    // TODO: JLI
    @Test
    func errorView_genericError_image_snapshot() {

        assertSnapshot(
            of: ErrorView(error: error, onRetry: onRetry),
            as: .image
        )
    }

    // TODO: JLI
    @Test
    func errorView_genericError_iPhoneSe_light_snapshot() {

        assertSnapshot(
            of: ErrorView(error: error, onRetry: onRetry),
            as: .image(
            layout: .device(config: .iPhoneSe),
            traits: .init(userInterfaceStyle: .light)
            )
        )
    }
}
