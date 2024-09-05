import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite(
    "EpisodesRepositoryDefault Tests",
    .serialized
)
final class EpisodesRepositoryDefaultTests: ResetTestDependencies {

    @Test
    func getEpisodesFromListSuccess() async {
        let datasource = EpisodesRemoteDatasourceMock()
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        do {
            let result = try await repository.getEpisodesFromList(ids: [1, 2])

            #expect(result.count == datasource.expectedResponse.count)
            #expect(result == datasource.expectedResponse.map { $0.toDomain() })

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func getEpisodesFromListFail() async {
        let datasource = EpisodesRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        do {
            _ = try await repository.getEpisodesFromList(ids: [1, 2])

            Issue.record("Test Fail")

        } catch {
            #expect(error as? RepositoryError == .invalidUrl)
        }
    }
}
