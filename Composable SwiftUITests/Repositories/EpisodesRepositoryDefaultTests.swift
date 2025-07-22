import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "EpisodesRepositoryDefault",
    .tags(.repository)
)
struct EpisodesRepositoryDefaultTests {

    @Test
    func getEpisodesFromListSuccess() async throws {
        let mockDatasource = MockEpisodesRemoteDatasource()
        let mockResponse = EpisodeResponse.mocks
        let repository = EpisodesRepositoryDefault(service: mockDatasource)

        given(mockDatasource)
            .getEpisodesList(ids: .any)
            .willReturn(mockResponse)

        let result = try await repository.getEpisodesFromList(ids: [1, 2])

        #expect(result.count == mockResponse.count)
        #expect(result == mockResponse.map { $0.toDomain() })

        verify(mockDatasource)
            .getEpisodesList(ids: .value([1, 2]))
            .called(.once)

        verify(mockDatasource)
            .getEpisode(id: .any)
            .called(.never)

        verify(mockDatasource)
            .getEpisodes(page: .any)
            .called(.never)
    }

    @Test
    func getEpisodesFromListFail() async throws {
        let mockDatasource = MockEpisodesRemoteDatasource()
        let mockError = RepositoryError.invalidUrl
        let repository = EpisodesRepositoryDefault(service: mockDatasource)

        given(mockDatasource)
            .getEpisodesList(ids: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await repository.getEpisodesFromList(ids: [1, 2])
        }

        verify(mockDatasource)
            .getEpisodesList(ids: .value([1, 2]))
            .called(.once)

        verify(mockDatasource)
            .getEpisode(id: .any)
            .called(.never)

        verify(mockDatasource)
            .getEpisodes(page: .any)
            .called(.never)
    }
}
