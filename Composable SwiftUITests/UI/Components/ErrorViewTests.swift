import XCTest
import SwiftUI
import SnapshotTesting
import jLagunaDevMacro

@testable import Composable_SwiftUI

@SceneSnapshotUITest(
    scene: "ErrorView",
    variants: [
        VariantTest(name: "genericError", params: "error: error, onRetry: onRetry")
    ]
)
final class ErrorViewTests: XCTest {

    private let error = InteractorError.generic(message: "Algo ha fallado")
    private let onRetry: () -> Void = { }

}
