import Combine

protocol EpisodesRepository {
    func getEpisodesFromList(ids: [Int]) -> AnyPublisher<[Episode], RepositoryError>
}
