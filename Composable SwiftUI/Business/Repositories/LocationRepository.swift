import Combine

protocol LocationRepository {
    func getCharacterIdsFromLocation(locationId: Int) -> AnyPublisher<[Int], RepositoryError>
}
