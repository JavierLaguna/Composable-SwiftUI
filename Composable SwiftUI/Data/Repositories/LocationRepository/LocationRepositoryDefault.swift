import Combine
import Resolver

struct LocationRepositoryDefault: LocationRepository {
    
    @Injected private var service: LocationRemoteDatasource
    @Injected(name: "async") private var serviceAsync: LocationRemoteDatasource
    
    func getCharacterIdsFromLocation(locationId: Int) -> AnyPublisher<[Int], RepositoryError> {
        service.getLocation(locationId: locationId)
            .map { response -> [Int] in
                response.toDomain().residents
            }
            .eraseToAnyPublisher()
    }
    
    func getLocation(locationId: Int) async throws -> Location {
        try await serviceAsync.getLocation(locationId: locationId).toDomain()
    }
}
