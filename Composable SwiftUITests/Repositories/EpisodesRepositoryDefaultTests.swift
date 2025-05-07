import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "EpisodesRepositoryDefault",
    .tags(.repository)
)
struct EpisodesRepositoryDefaultTests {

    @Test
    func getEpisodesFromListSuccess() async throws {
        let datasource = EpisodesRemoteDatasourceMock()
        let repository = EpisodesRepositoryDefault(service: datasource)

        let result = try await repository.getEpisodesFromList(ids: [1, 2])

        #expect(result.count == datasource.expectedResponse.count)
        #expect(result == datasource.expectedResponse.map { $0.toDomain() })
    }

    @Test
    func getEpisodesFromListFail() async throws {
        let datasource = EpisodesRemoteDatasourceMock(success: false)
        let repository = EpisodesRepositoryDefault(service: datasource)

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getEpisodesFromList(ids: [1, 2])
        }
    }
}
