import Testing
import SwiftUI
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "MainView",
    .tags(.UI, .UIScene)
)
final class MainViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private var store: StoreOf<MainReducer>!

    @Test(
        "Characters Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func charactersTabSelected(variant: SceneSnapshotUITest.Variant) {
        configureStore()

        execute(
            name: "mainView_charactersTabSelected",
            view: view(selectedTab: .characters),
            variant: variant
        )
    }

    @Test(
        "Episodes Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func episodesTabSelected(variant: SceneSnapshotUITest.Variant) {
        configureStore()

        execute(
            name: "mainView_episodesTabSelected",
            view: view(selectedTab: .episodes),
            variant: variant
        )
    }

    @Test(
        "Locations Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func locationsTabSelected(variant: SceneSnapshotUITest.Variant) {
        configureStore()

        execute(
            name: "mainView_locationsTabSelected",
            view: view(selectedTab: .locations),
            variant: variant
        )
    }
}

// MARK: Private methods
private extension MainViewTests {

    var mainView: some View {
        MainView(mainStore: store)
    }

    func view(selectedTab: TabSelection) -> some View {
        mainView
            .overlay {
                TabSelectionConfigurator(selectedTab: selectedTab)
                    .allowsHitTesting(false)
            }
            .allEnvironmentsInjected
    }

    func configureStore() {
        store = StoreOf<MainReducer>(
            initialState: .init(),
            reducer: {
                // Intentionally empty
            }
        )
    }
}

// MARK: Private types
private extension MainViewTests {

    enum TabSelection {
        case characters
        case episodes
        case locations
    }

    struct TabSelectionConfigurator: View {

        @Environment(MainCoordinator.self) private var mainCoordinator

        let selectedTab: TabSelection

        var body: some View {
            Color.clear
                .frame(width: 0, height: 0)
                .onAppear {
                    switch selectedTab {
                    case .characters:
                        mainCoordinator.navigateToCharacters()
                    case .episodes:
                        mainCoordinator.navigateToEpisodes()
                    case .locations:
                        mainCoordinator.navigateToLocations()
                    }
                }
        }
    }
}
