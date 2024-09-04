import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite("GetCharactersInteractorDefault Tests")
final class GetCharactersInteractorDefaultTests {

    init() {
        Resolver.resetUnitTestRegistrations()
    }

    deinit {
        Resolver.tearDown()
    }

    @Test
    func executeSuccess() async {
        let repository = CharactersRepositoryMock()
        Resolver.test.register { repository as CharactersRepository }

        let interactor = GetCharactersInteractorDefault()

        do {
            let result = try await interactor.execute()

            #expect(result.count == repository.expectedResponse.count)
            #expect(result == repository.expectedResponse)

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func executeFail() async {
        let repository = CharactersRepositoryMock(success: false)
        Resolver.test.register { repository as CharactersRepository }

        let interactor = GetCharactersInteractorDefault()

        do {
            _ = try await interactor.execute()

            Issue.record("Test Fail")

        } catch {
            #expect(error as? InteractorError == .repositoryFail(error: .invalidUrl))
        }
    }
}
