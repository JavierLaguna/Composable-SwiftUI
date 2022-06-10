import Combine
import Foundation

class LocationService: HttpClient, LocationRemoteDatasource {
    
    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/location"

    func getLocation(locationId: Int) -> AnyPublisher<LocationResponse, RepositoryError> {
        
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(locationId)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            return Fail<LocationResponse, RepositoryError>(error: .invalidUrl)
                .eraseToAnyPublisher()
        }
        
        return get(from: url)
            .mapError { error -> RepositoryError in .serviceFail(error: error)}
            .eraseToAnyPublisher()
    }
}
