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
    func getEpisodesFromListSuccess() async throws {
        let datasource = EpisodesRemoteDatasourceMock()
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        let result = try #require(await repository.getEpisodesFromList(ids: [1, 2]))

        #expect(result.count == datasource.expectedResponse.count)
        #expect(result == datasource.expectedResponse.map { $0.toDomain() })
    }

    @Test
    func getEpisodesFromListFail() async {
        let datasource = EpisodesRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        await #expect(throws: RepositoryError.invalidUrl) {
            try await repository.getEpisodesFromList(ids: [1, 2])
        }
    }
}
