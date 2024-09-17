import Testing
import SwiftUI

@testable import Composable_SwiftUI

@Suite("LoadingView", .tags(.UI))
final class LoadingViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    @Test(
        "LoadingView",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingView(variant: SceneSnapshotUITest.Variant) {
        execute(
            name: "loadingView",
            view: LoadingView(),
            variant: variant
        )
    }
}
