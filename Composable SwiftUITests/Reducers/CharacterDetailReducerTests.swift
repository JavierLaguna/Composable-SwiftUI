import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "CharacterDetailReducer",
    .tags(.reducer)
)
struct CharacterDetailReducerTests {

    @Test
    func getCharacterDescription_whenInteractorFail_returnsInteractorError() async {
        let mockGetCharactersInteractor = MockGetCharactersInteractor()
        let mockGetCharacterDescriptionInteractor = MockGetCharacterDescriptionInteractor()
        let mockGetTotalCharactersCountInteractor = MockGetTotalCharactersCountInteractor()
        let mockGetEpisodesInteractor = MockGetEpisodesInteractor()

        let mockError = InteractorError.generic(message: "mock error")

        given(mockGetCharacterDescriptionInteractor)
            .execute(character: .any)
            .willThrow(mockError)

        let store = await TestStore(
            initialState: .init(
                character: Character.mock,
                viewMode: .allInfo
            ),
            reducer: {
                CharacterDetailReducer(
                    getCharactersInteractor: mockGetCharactersInteractor,
                    getCharacterDescriptionInteractor: mockGetCharacterDescriptionInteractor,
                    getTotalCharactersCountInteractor: mockGetTotalCharactersCountInteractor,
                    getEpisodesByIdsInteractor: mockGetEpisodesInteractor
                )
            }
        )

        await store.send(.getCharacterDescription) {
            $0.characterDescription.state = .loading
        }

        await store.receive(\.onReceiveCharacterDescription.failure) {
            $0.characterDescription.state = .error(mockError)
        }

        verify(mockGetCharacterDescriptionInteractor)
            .execute(character: .value(Character.mock))
            .called(.once)

        verify(mockGetCharactersInteractor)
            .execute()
            .called(.never)

        verify(mockGetCharactersInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockGetCharactersInteractor)
            .execute(ids: .any)
            .called(.never)

        verify(mockGetTotalCharactersCountInteractor)
            .execute()
            .called(.never)

        verify(mockGetEpisodesInteractor)
            .execute(ids: .any)
            .called(.never)
    }
}
