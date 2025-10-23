import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "CharactersListReducer",
    .tags(.reducer)
)
struct CharactersListReducerTests {

    @Test
    func bindingSearchText() async {
        let mockInteractor = MockGetCharactersInteractor()
        let store = await TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer(
                    getCharactersInteractor: mockInteractor
                )
            }
        )

        await store.send(.set(\.searchText, "test text")) {
            $0.searchText = "test text"
        }
    }

    @Test
    func getCharactersSuccess() async {
        let mockInteractor = MockGetCharactersInteractor()
        let mockResponse = [Character.mock]
        let store = await TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer(
                    getCharactersInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(mockResponse)

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.success) {
            $0.characters.state = .populated(data: mockResponse)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }

    @Test
    func getCharactersSuccessAndMoreCharacters() async {
        let mockInteractor = MockGetCharactersInteractor()
        let mockResponse = [Character.mock]
        let initialCharacters = Character.mocks
        let store = await TestStore(
            initialState: CharactersListReducer.State(
                characters: StateLoadable(state:
                        .populated(data: initialCharacters
                ))
            ),
            reducer: {
                CharactersListReducer(
                    getCharactersInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(mockResponse)

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.success) {
            var newData = initialCharacters
            newData.append(contentsOf: mockResponse)
            $0.characters.state = .populated(data: newData)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }

    @Test
    func getCharactersFail() async {
        let mockInteractor = MockGetCharactersInteractor()
        let mockError = InteractorError.generic(message: "mock error")
        let store = await TestStore(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer(
                    getCharactersInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute()
            .willThrow(mockError)

        await store.send(.getCharacters) {
            $0.characters.state = .loading
        }

        await store.receive(\.onGetCharacters.failure) {
            $0.characters.state = .error(mockError)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }
}
