@testable import Composable_SwiftUI

struct EpisodesRemoteDatasourceMock: EpisodesRemoteDatasource {

    var success: Bool = true
    var expectedResponse: [EpisodeResponse] = [
        EpisodeResponse(id: 1, name: "Episode 1", airDate: "11-11-2011", episode: "episode 1", characters: ["url/1", "url/2"], created: "created"),
        EpisodeResponse(id: 2, name: "Episode 2", airDate: "12-12-2012", episode: "episode 2", characters: ["url/2", "url/3", "url/5"], created: "created")
    ]
    var expectedError: RepositoryError = .invalidUrl

    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }

    func getEpisode(id: Int) async throws -> EpisodeResponse {
        if success {
            return expectedResponse.first!
        } else {
            throw expectedError
        }
    }

    func getEpisodes(page: Int?) async throws -> GetEpisodesResponse {
        if success {
            return .init(
                info: .init(pages: 12, count: 35),
                results: expectedResponse
            )
        } else {
            throw expectedError
        }
    }
}
