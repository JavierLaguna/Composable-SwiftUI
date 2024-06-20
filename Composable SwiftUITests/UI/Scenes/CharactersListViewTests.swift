import XCTest
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
import jLagunaDevMacro

@testable import Composable_SwiftUI

struct VariantTest { // TODO: JLI
    let name: String
    let params: String?
    let setUp: String?

    init(name: String, params: String? = nil, setUp: String? = nil) {
        self.name = name
        self.params = params
        self.setUp = setUp
    }
}

@SceneSnapshotUITest(
    scene: "CharactersListView",
    variants: [
        VariantTest(name: "loadingState", params: "store: store", setUp: "loadingStateSetUp"),
        VariantTest(name: "loadingStateWithData", params: "store: store", setUp: "loadingStateWithDataSetUp"),
        VariantTest(name: "populatedState", params: "store: store", setUp: "populatedStateSetUp"),
        VariantTest(name: "errorState", params: "store: store", setUp: "errorStateSetUp")
    ]
)
final class CharactersListViewTests: XCTestCase {

    private var store: StoreOf<CharactersListReducer>!

    override class func setUp() {
        super.setUp()

        isRecording = false
    }
}

// MARK: Private methods
private extension CharactersListViewTests {

    static private func imageUrl(id: Int) -> String {
        "\(TestConfig.characterImageBaseUrl)/\(id).jpeg"
    }

    private var characters: [Character] {
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
