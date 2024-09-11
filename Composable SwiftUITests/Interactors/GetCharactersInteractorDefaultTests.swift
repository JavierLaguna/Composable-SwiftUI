import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite(
    "GetCharactersInteractorDefault Tests",
    .serialized
)
final class GetCharactersInteractorDefaultTests: ResetTestDependencies {

    @Test
    func executeSuccess() async throws {
        let repository = CharactersRepositoryMock()
        Resolver.test.register { repository as CharactersRepository }

        let interactor = GetCharactersInteractorDefault()

        let result = try #require(await interactor.execute())

        #expect(result.count == repository.expectedResponse.count)
        #expect(result == repository.expectedResponse)
    }

    @Test
    func executeFail() async throws {
        let repository = CharactersRepositoryMock(success: false)
        Resolver.test.register { repository as CharactersRepository }

        let interactor = GetCharactersInteractorDefault()

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute()
        }
    }
}
