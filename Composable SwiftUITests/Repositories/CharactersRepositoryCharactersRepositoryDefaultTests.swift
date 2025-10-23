import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "CharactersRepositoryDefault",
    .tags(.repository)
)
struct CharactersRepositoryDefaultTests {

    @Test
    func getCharactersSuccess() async throws {
        let mockDatasource = MockCharacterRemoteDatasource()
        let mockResonse = GetCharactersResponse.mock
        let repository = CharactersRepositoryDefault(
            service: mockDatasource
        )

        given(mockDatasource)
            .getCharacters(page: .any)
            .willReturn(mockResonse)

        await #expect(repository.nextPage == nil)
        await #expect(repository.totalPages == nil)

        let result = try await repository.getCharacters()

        await #expect(repository.nextPage == 2)
        await #expect(repository.totalPages == 12)
        #expect(result.count == mockResonse.results.count)
        #expect(result == mockResonse.results.map { $0.toDomain() })

        verify(mockDatasource)
            .getCharacters(page: .value(nil))
            .called(.once)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)

        verify(mockDatasource)
            .getCharacters(by: .any)
            .called(.never)
    }

    @Test
    func getCharactersFail() async throws {
        let mockDatasource = MockCharacterRemoteDatasource()
        let mockError = RepositoryError.invalidUrl
        let repository = CharactersRepositoryDefault(
            service: mockDatasource
        )

        given(mockDatasource)
            .getCharacters(page: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await repository.getCharacters()
        }

        verify(mockDatasource)
            .getCharacters(page: .value(nil))
            .called(.once)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)

        verify(mockDatasource)
            .getCharacters(by: .any)
            .called(.never)
    }

    @Test
    func getCharactersByIdSuccess() async throws {
        let mockDatasource = MockCharacterRemoteDatasource()
        let mockResonse = CharacterResponse.mocks
        let repository = CharactersRepositoryDefault(
            service: mockDatasource
        )

        given(mockDatasource)
            .getCharacters(by: .any)
            .willReturn(mockResonse)

        await #expect(repository.nextPage == nil)
        await #expect(repository.totalPages == nil)

        let result = try await repository.getCharacters(characterIds: [1, 2])

        #expect(result.count == mockResonse.count)
        #expect(result == mockResonse.map { $0.toDomain() })

        verify(mockDatasource)
            .getCharacters(by: .value([1, 2]))
            .called(.once)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)
    }

    @Test
    func getCharactersByIdFail() async throws {
        let mockDatasource = MockCharacterRemoteDatasource()
        let mockError = RepositoryError.invalidUrl
        let repository = CharactersRepositoryDefault(
            service: mockDatasource
        )

        given(mockDatasource)
            .getCharacters(by: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await repository.getCharacters(characterIds: [1, 2])
        }

        verify(mockDatasource)
            .getCharacters(by: .value([1, 2]))
            .called(.once)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)

        verify(mockDatasource)
            .getCharacter(by: .any)
            .called(.never)
    }
}
