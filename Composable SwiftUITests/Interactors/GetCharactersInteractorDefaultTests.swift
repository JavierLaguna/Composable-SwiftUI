import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "GetCharactersInteractorDefault",
    .tags(.interactor)
)
struct GetCharactersInteractorDefaultTests {

    @Test
    func executeSuccess() async throws {
        let mockRepository = MockCharactersRepository()
        let mockResponse = Character.mocks
        let interactor = GetCharactersInteractorDefault(repository: mockRepository)

        given(mockRepository)
            .getCharacters()
            .willReturn(mockResponse)

        let result = try await interactor.execute()

        #expect(result.count == mockResponse.count)
        #expect(result == mockResponse)

        verify(mockRepository)
            .getCharacters()
            .called(.once)

        verify(mockRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockRepository)
            .getCharacters(characterIds: .any)
            .called(.never)

        verify(mockRepository)
            .getTotalCharactersCount()
            .called(.never)
    }

    @Test
    func executeFail() async throws {
        let mockRepository = MockCharactersRepository()
        let mockError = InteractorError.repositoryFail(error: .invalidUrl)
        let interactor = GetCharactersInteractorDefault(repository: mockRepository)

        given(mockRepository)
            .getCharacters()
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await interactor.execute()
        }

        verify(mockRepository)
            .getCharacters()
            .called(.once)

        verify(mockRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockRepository)
            .getCharacters(characterIds: .any)
            .called(.never)

        verify(mockRepository)
            .getTotalCharactersCount()
            .called(.never)
    }
}
