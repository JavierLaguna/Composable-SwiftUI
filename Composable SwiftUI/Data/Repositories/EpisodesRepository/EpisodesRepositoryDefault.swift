import Combine
import Resolver

final class EpisodesRepositoryDefault: EpisodesRepository {
    
    @Injected private var service: EpisodesRemoteDatasource

    func getEpisodesFromList(ids: [Int]) -> AnyPublisher<[Episode], RepositoryError> {
        
        return service.getEpisodesList(ids: ids)
            .map { response -> [Episode] in
                response.compactMap { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}
