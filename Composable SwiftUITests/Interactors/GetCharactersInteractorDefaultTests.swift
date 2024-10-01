import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite("GetCharactersInteractorDefault", .tags(.interactor))
struct GetCharactersInteractorDefaultTests {

    @Test
    func executeSuccess() async throws {
        let repository = CharactersRepositoryMock()

        let interactor = GetCharactersInteractorDefault(repository: repository)

        let result = try #require(await interactor.execute())

        #expect(result.count == repository.expectedResponse.count)
        #expect(result == repository.expectedResponse)
    }

    @Test
    func executeFail() async throws {
        let repository = CharactersRepositoryMock(success: false)

        let interactor = GetCharactersInteractorDefault(repository: repository)

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute()
        }
    }
}
