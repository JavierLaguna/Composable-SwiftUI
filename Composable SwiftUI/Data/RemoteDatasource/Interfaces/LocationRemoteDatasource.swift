import Combine

protocol LocationRemoteDatasource {
    func getLocation(locationId: Int) -> AnyPublisher<LocationResponse, RepositoryError>
    
    func getLocation(locationId: Int) async throws -> LocationResponse
}
