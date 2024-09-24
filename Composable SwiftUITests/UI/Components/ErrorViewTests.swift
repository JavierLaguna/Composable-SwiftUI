import Testing
import SwiftUI

@testable import Composable_SwiftUI

@Suite("ErrorView", .tags(.UI, .UIComponent))
final class ErrorViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private let error = InteractorError.generic(message: "Algo ha fallado")
    private let onRetry: () -> Void = {
        // Intentionally empty
    }

    @Test(
        "Generic error",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func errorViewGenericError(variant: SceneSnapshotUITest.Variant) {
        execute(
            name: "errorView_genericError",
            view: ErrorView(error: error, onRetry: onRetry),
            variant: variant
        )
    }
}
