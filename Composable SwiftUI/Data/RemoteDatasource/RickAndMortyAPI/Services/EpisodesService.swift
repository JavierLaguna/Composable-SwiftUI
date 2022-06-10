import Combine
import Foundation

class EpisodesService: HttpClient, EpisodesRemoteDatasource {
    
    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/episode"

    func getEpisodesList(ids: [Int]) -> AnyPublisher<[EpisodeResponse], RepositoryError> {
        
        let idsParam = ids.map { "\($0)" }.joined(separator: ",")
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(idsParam)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            return Fail<[EpisodeResponse], RepositoryError>(error: .invalidUrl)
                .eraseToAnyPublisher()
        }
        
        return get(from: url)
            .mapError { error -> RepositoryError in .serviceFail(error: error)}
            .eraseToAnyPublisher()
    }
}
