import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite(
    "CharactersRepositoryDefault Tests",
    .serialized
)
final class CharactersRepositoryDefaultTests: ResetTestDependencies {

    @Test
    func getCharactersSuccess() async throws {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        #expect(repository.nextPage == nil)
        #expect(repository.totalPages == nil)

        let result = try #require(await repository.getCharacters())

        #expect(repository.nextPage == 2)
        #expect(repository.totalPages == 12)
        #expect(result.count == datasource.expectedResponseByPage.results.count)
        #expect(result == datasource.expectedResponseByPage.results.map { $0.toDomain() })
    }

    @Test
    func getCharactersFail() async throws {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getCharacters()
        }
    }

    @Test
    func getCharactersByIdSuccess() async throws {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        #expect(repository.nextPage == nil)
        #expect(repository.totalPages == nil)

        let result = try #require(await repository.getCharacters(characterIds: [1, 2]))

        #expect(result.count == datasource.expectedResponseByIds.count)
        #expect(result == datasource.expectedResponseByIds.map { $0.toDomain() })
    }

    @Test
    func getCharactersByIdFail() async throws {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getCharacters(characterIds: [1, 2])
        }
    }
}
