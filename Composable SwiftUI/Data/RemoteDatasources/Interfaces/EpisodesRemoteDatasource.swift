protocol EpisodesRemoteDatasource: Sendable {
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse]
}

struct EpisodesRemoteDatasourceFactory {

    static func build() -> EpisodesRemoteDatasource {
        EpisodesService(
            apiClient: APIClientFactory.build()
        )
    }
}
