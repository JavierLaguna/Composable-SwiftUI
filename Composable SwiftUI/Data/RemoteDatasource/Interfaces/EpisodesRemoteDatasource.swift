protocol EpisodesRemoteDatasource {
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse]
}

struct EpisodesRemoteDatasourceFactory {

    static func build() -> EpisodesRemoteDatasource {
        EpisodesService()
    }
}
