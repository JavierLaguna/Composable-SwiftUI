import Testing
import SwiftUI
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite("CharactersListView", .tags(.UI, .UIScene))
final class CharactersListViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private var store: StoreOf<CharactersListReducer>!

    @Test(
        "Loading State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingState(variant: SceneSnapshotUITest.Variant) {
        loadingStateSetUp()

        execute(
            name: "charactersListView_loadingState",
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
            name: "charactersListView_loadingStateWithData",
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
            name: "charactersListView_populatedState",
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
            name: "charactersListView_errorState",
            view: view,
            variant: variant
        )
    }
}

// MARK: Private methods
private extension CharactersListViewTests {

    static func imageUrl(id: Int) -> String {
        "\(TestConfig.characterImageBaseUrl)/\(id).jpeg"
    }

    var view: some View {
        CharactersListView(store: store)
            .allEnvironmentsInjected
    }

    var characters: [Character] {
        [
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
            ),
            Character(
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
            )
        ]
    }

    func loadingStateSetUp() {
        let state = CharactersListReducer.State(
            characters: .init(state: .loading)
        )
        configureStore(with: state)
    }

    func loadingStateWithDataSetUp() {
        var state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        state.characters.state = .loading
        configureStore(with: state)
    }

    func populatedStateSetUp() {
        let state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        configureStore(with: state)
    }

    func errorStateSetUp() {
        let error = InteractorError.generic(message: "")
        let state = CharactersListReducer.State(
            characters: .init(state: .error(error))
        )
        configureStore(with: state)
    }

    func configureStore(with state: CharactersListReducer.State) {
        store = StoreOf<CharactersListReducer>(
            initialState: state,
            reducer: {
                // Intentionally empty
            }
        )
    }
}
