protocol EpisodesRemoteDatasource: Sendable {
    func getEpisode(id: Int) async throws -> EpisodeResponse
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse]
    func getEpisodes(page: Int?) async throws -> GetEpisodesResponse
}

struct EpisodesRemoteDatasourceFactory {

    static func build() -> any EpisodesRemoteDatasource {
        EpisodesService(
            apiClient: APIClientFactory.build()
        )
    }
}
