import Testing
import SwiftUI
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "MainTabView",
    .tags(.UI, .UIScene)
)
final class MainTabViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    @Test(
        "Characters Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func charactersTabSelected(variant: SceneSnapshotUITest.Variant) {
        execute(
            name: "mainTabView_charactersTabSelected",
            view: view(selectedTab: .characters),
            variant: variant
        )
    }

    @Test(
        "Episodes Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func episodesTabSelected(variant: SceneSnapshotUITest.Variant) {
        execute(
            name: "mainTabView_episodesTabSelected",
            view: view(selectedTab: .episodes),
            variant: variant
        )
    }

    @Test(
        "Locations Tab Selected",
        arguments: SceneSnapshotUITest.Variant.allPortraitDevicesVariants
    )
    func locationsTabSelected(variant: SceneSnapshotUITest.Variant) {
        execute(
            name: "mainTabView_locationsTabSelected",
            view: view(selectedTab: .locations),
            variant: variant
        )
    }
}

// MARK: Private methods
private extension MainTabViewTests {

    func view(selectedTab: MainCoordinator.Tab) -> some View {
        let store = StoreOf<MainReducer>(
            initialState: .init(
                charactersListState: .init(
                    characters: .init(
                        state: .populated(data: Character.mocks)
//                        state: .loading
                    )
                )
            ),
            reducer: {
                MainReducer()
            }
        )
        let charactersCoordinator = CharactersCoordinator(mainStore: store)
        let episodesCoordinator = EpisodesCoordinator()
        let locationsCoordinator = LocationsCoordinator()

        return MainTabView(
            selectedTab: .constant(selectedTab.rawValue)
        )
        .allEnvironmentsInjected
//        .environment(charactersCoordinator)
//        .environment(episodesCoordinator)
//        .environment(locationsCoordinator)
    }
}

// MARK: Private types
private extension MainTabViewTests {

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
