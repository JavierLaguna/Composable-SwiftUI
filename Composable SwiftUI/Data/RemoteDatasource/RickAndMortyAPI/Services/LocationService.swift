import Combine
import Foundation

final class LocationService: HttpClient, LocationRemoteDatasource {
    
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
    
    func getLocation(locationId: Int) async throws -> LocationResponse {
        fatalError("not implemented, use LocationServiceAsync")
    }
}

final class LocationServiceAsync: AsyncHttpClient, LocationRemoteDatasource {
    
    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/location"
    
    func getLocation(locationId: Int) async throws -> LocationResponse {
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(locationId)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }
        
        return try await get(from: url)
    }
    
    func getLocation(locationId: Int) -> AnyPublisher<LocationResponse, RepositoryError> {
        fatalError("not implemented, use LocationService")
    }
}
