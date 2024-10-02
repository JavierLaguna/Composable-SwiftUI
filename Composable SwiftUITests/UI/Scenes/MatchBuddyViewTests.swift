import Testing
import SwiftUI
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "MatchBuddyView",
    .tags(.UI, .UIScene)
)
final class MatchBuddyViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private var store: StoreOf<MatchBuddyReducer>!

    @Test(
        "Loading State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingState(variant: SceneSnapshotUITest.Variant) {
        loadingStateSetUp()

        execute(
            name: "matchBuddyView_loadingState",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Loading State With Data",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingStateWithData(variant: SceneSnapshotUITest.Variant) {
        loadingStateWithDataSetUp()

        execute(
            name: "matchBuddyView_loadingStateWithData",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Populated State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func populatedState(variant: SceneSnapshotUITest.Variant) {
        populatedStateSetUp()

        execute(
            name: "matchBuddyView_populatedState",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Error State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func errorState(variant: SceneSnapshotUITest.Variant) {
        errorStateSetUp()

        execute(
            name: "matchBuddyView_errorState",
            view: view,
            variant: variant
        )
    }
}

// MARK: Private methods
private extension MatchBuddyViewTests {

    static func imageUrl(id: Int) -> String {
        "\(TestConfig.characterImageBaseUrl)/\(id).jpeg"
    }

    var view: some View {
        MatchBuddyView(
            store: store,
            character: character
        )
        .allEnvironmentsInjected
    }

    var character: Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: CharacterLocation(
                id: 1,
                name: "Earth"
            ),
            location: CharacterLocation(
                id: 1,
                name: "Earth"
            ),
            image: Self.imageUrl(id: 1),
            episodes: []
        )
    }

    var beerBuddy: BeerBuddy {
        BeerBuddy(
            count: 99,
            buddy: Character(
                id: 2,
                name: "Morty",
                status: .alive,
                species: "Human",
                type: "",
                gender: .male,
                origin: CharacterLocation(
                    id: 1,
                    name: "Earth"
                ),
                location: CharacterLocation(
                    id: 1,
                    name: "Earth"
                ),
                image: Self.imageUrl(id: 2),
                episodes: []
            ),
            character: character,
            firstEpisode: Episode(id: 1, name: "1", date: "1"),
            lastEpisode: Episode(id: 2, name: "2", date: "2")
        )
    }

    func loadingStateSetUp() {
        let state = MatchBuddyReducer.State(
            beerBuddy: .init(state: .loading)
        )
        configureStore(with: state)
    }

    func loadingStateWithDataSetUp() {
        var state = MatchBuddyReducer.State(
            beerBuddy: .init(state: .populated(data: beerBuddy))
        )
        state.beerBuddy.state = .loading
        configureStore(with: state)
    }

    func populatedStateSetUp() {
        let state = MatchBuddyReducer.State(
            beerBuddy: .init(state: .populated(data: beerBuddy))
        )
        configureStore(with: state)
    }

    func errorStateSetUp() {
        let error = InteractorError.generic(message: "")
        let state = MatchBuddyReducer.State(
            beerBuddy: .init(state: .error(error))
        )
        configureStore(with: state)
    }

    func configureStore(with state: MatchBuddyReducer.State) {
        store = StoreOf<MatchBuddyReducer>(
            initialState: state,
            reducer: {
                // Intentionally empty
            }
        )
    }
}
