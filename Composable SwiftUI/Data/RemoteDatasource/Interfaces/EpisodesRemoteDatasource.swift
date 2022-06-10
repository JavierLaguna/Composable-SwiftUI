import Combine

protocol EpisodesRemoteDatasource {
    func getEpisodesList(ids: [Int]) -> AnyPublisher<[EpisodeResponse], RepositoryError>
}
