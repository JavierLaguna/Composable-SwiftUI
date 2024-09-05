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
    func getCharactersSuccess() async {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        #expect(repository.nextPage == nil)
        #expect(repository.totalPages == nil)

        do {
            let result = try await repository.getCharacters()

            #expect(repository.nextPage == 2)
            #expect(repository.totalPages == 12)
            #expect(result.count == datasource.expectedResponseByPage.results.count)
            #expect(result == datasource.expectedResponseByPage.results.map { $0.toDomain() })

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func getCharactersFail() async {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        do {
            _ = try await repository.getCharacters()

            Issue.record("Test Fail")

        } catch {
            #expect(error as? RepositoryError == .invalidUrl)
        }
    }

    @Test
    func getCharactersByIdSuccess() async {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        #expect(repository.nextPage == nil)
        #expect(repository.totalPages == nil)

        do {
            let result = try await repository.getCharacters(characterIds: [1, 2])

            #expect(result.count == datasource.expectedResponseByIds.count)
            #expect(result == datasource.expectedResponseByIds.map { $0.toDomain() })

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func getCharactersByIdFail() async {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        do {
            _ = try await repository.getCharacters(characterIds: [1, 2])

            Issue.record("Test Fail")

        } catch {
            #expect(error as? RepositoryError == .invalidUrl)
        }
    }
}
