import Combine
import Resolver

final class LocationRepositoryDefault: LocationRepository {
    
    @Injected private var service: LocationRemoteDatasource

    func getCharacterIdsFromLocation(locationId: Int) -> AnyPublisher<[Int], RepositoryError> {
        
        return service.getLocation(locationId: locationId)
            .map { response -> [Int] in
                response.residents?.compactMap { $0.getIdFromUrl() } ?? []
            }
            .eraseToAnyPublisher()
    }
}
