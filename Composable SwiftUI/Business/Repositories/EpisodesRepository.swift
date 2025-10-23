import Foundation
import Mockable

@Mockable
protocol EpisodesRepository: Sendable {
    func getEpisodes() async throws -> [Episode]
    func getEpisodesFromList(ids: [Int]) async throws -> [Episode]
}

struct EpisodesRepositoryFactory {

    static func build() -> any EpisodesRepository {
        EpisodesRepositoryDefault(
            service: EpisodesRemoteDatasourceFactory.build()
        )
    }
}
