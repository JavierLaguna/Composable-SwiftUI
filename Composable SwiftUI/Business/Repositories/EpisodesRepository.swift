protocol EpisodesRepository {
    func getEpisodesFromList(ids: [Int]) async throws -> [Episode]
}
