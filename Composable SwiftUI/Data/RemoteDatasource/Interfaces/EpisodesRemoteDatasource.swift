protocol EpisodesRemoteDatasource {
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse]
}
