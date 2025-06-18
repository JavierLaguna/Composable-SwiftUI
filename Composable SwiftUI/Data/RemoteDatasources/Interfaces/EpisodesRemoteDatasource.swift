protocol EpisodesRemoteDatasource: Sendable {
    func getEpisode(id: Int) async throws -> EpisodeResponse
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse]
}

struct EpisodesRemoteDatasourceFactory {

    static func build() -> any EpisodesRemoteDatasource {
        EpisodesService(
            apiClient: APIClientFactory.build()
        )
    }
}
