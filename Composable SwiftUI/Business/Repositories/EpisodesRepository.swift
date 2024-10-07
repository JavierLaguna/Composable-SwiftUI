protocol EpisodesRepository: Sendable {
    func getEpisodesFromList(ids: [Int]) async throws -> [Episode]
}

struct EpisodesRepositoryFactory {

    static func build() -> any EpisodesRepository {
        EpisodesRepositoryDefault(
            service: EpisodesRemoteDatasourceFactory.build()
        )
    }
}
