import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@MainActor
final class CharactersListReducerTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Resolver.resetUnitTestRegistrations()
    }

    override func tearDown() {
        super.tearDown()

        Resolver.tearDown()
    }

    func testBindingSearchText() async {
        let store = TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer()
            }
        )

        await store.send(.set(\.$searchText, "test text")) {
            $0.searchText = "test text"
        }
    }

    func testGetCharactersSuccess() async {
        let interactor = GetCharactersInteractorMock()
        Resolver.test.register { interactor as GetCharactersInteractor }

        let store = TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer()
            }
        )

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.success) {
            $0.characters.state = .populated(data: interactor.expectedResponse)
        }
    }

    func testGetCharactersSuccessAndMoreCharacters() async {
        let interactor = GetCharactersInteractorMock()
        Resolver.test.register { interactor as GetCharactersInteractor }

        let location = CharacterLocation(id: 1, name: "Earth")
        let initialCharacters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: [])
        ]

        let store = TestStore(
            initialState: CharactersListReducer.State(
                characters: StateLoadable(state: .populated(data: initialCharacters))
            ),
            reducer: {
                CharactersListReducer()
            }
        )

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.success) {
            var newData = initialCharacters
            newData.append(contentsOf: interactor.expectedResponse)
            $0.characters.state = .populated(data: newData)
        }
    }

    func testGetCharactersFail() async {
        Resolver.test.register { GetCharactersInteractorMock(success: false) as GetCharactersInteractor }

        let store = TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer()
            }
        )

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.failure) {
            $0.characters.state = .error(InteractorError.generic(message: "mock error"))
        }
    }
}
