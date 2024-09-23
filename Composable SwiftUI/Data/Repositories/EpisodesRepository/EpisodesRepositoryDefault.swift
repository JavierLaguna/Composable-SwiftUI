struct EpisodesRepositoryDefault: EpisodesRepository {

    let service: EpisodesRemoteDatasource

    func getEpisodesFromList(ids: [Int]) async throws -> [Episode] {
        let response = try await service.getEpisodesList(ids: ids)
        return response.compactMap { $0.toDomain() }
    }
}
