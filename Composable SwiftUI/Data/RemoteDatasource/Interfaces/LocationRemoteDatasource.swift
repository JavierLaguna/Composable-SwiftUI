import Combine

protocol LocationRemoteDatasource {
    func getLocation(locationId: Int) -> AnyPublisher<LocationResponse, RepositoryError>
}
