import Testing
import SwiftUI
import SnapshotTesting

@testable import Composable_SwiftUI

@Suite("ErrorView")
final class ErrorViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private let error = InteractorError.generic(message: "Algo ha fallado")
    private let onRetry: () -> Void = {
        // Intentionally empty
    }

    @Test(
        "errorView_genericError",
        arguments: SceneSnapshotUITest.SnapshotType.allCases
    )
    func errorViewGenericError(snapshotType: SceneSnapshotUITest.SnapshotType) async throws {
        execute(
            view: ErrorView(error: error, onRetry: onRetry),
            snapshotType: snapshotType,
            name: "errorView_genericError"
        )
    }
}
