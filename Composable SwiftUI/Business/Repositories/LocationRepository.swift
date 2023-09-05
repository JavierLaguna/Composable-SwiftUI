import Combine

protocol LocationRepository {
    func getCharacterIdsFromLocation(locationId: Int) -> AnyPublisher<[Int], RepositoryError>
    
    func getLocation(locationId: Int) async throws -> Location
}
