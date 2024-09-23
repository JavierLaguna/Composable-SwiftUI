protocol EpisodesRepository {
    func getEpisodesFromList(ids: [Int]) async throws -> [Episode]
}

struct EpisodesRepositoryFactory {

    static func build() -> EpisodesRepository {
        EpisodesRepositoryDefault(
            service: EpisodesRemoteDatasourceFactory.build()
        )
    }
}
