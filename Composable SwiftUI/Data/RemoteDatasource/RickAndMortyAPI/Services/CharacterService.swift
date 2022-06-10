import Combine
import Foundation

class CharacterService: HttpClient, CharacterRemoteDatasource {
    
    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/character"

    func getCharacters(page: Int? = nil) -> AnyPublisher<GetCharactersResponse, RepositoryError> {
        
        var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)"),
            resolvingAgainstBaseURL: false
        )

        if let page = page {
            let queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            return Fail<GetCharactersResponse, RepositoryError>(error: .invalidUrl)
                .eraseToAnyPublisher()
        }
        
        return get(from: url)
            .mapError { error -> RepositoryError in .serviceFail(error: error)}
            .eraseToAnyPublisher()
    }
    
    func getCharacter(by id: Int) -> AnyPublisher<CharacterResponse, RepositoryError> {
        
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(id)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            return Fail<CharacterResponse, RepositoryError>(error: .invalidUrl)
                .eraseToAnyPublisher()
        }
        
        return get(from: url)
            .mapError { error -> RepositoryError in .serviceFail(error: error)}
            .eraseToAnyPublisher()
    }
    
    func getCharacters(by characterIds: [Int]) -> AnyPublisher<[CharacterResponse], RepositoryError> {
        guard !characterIds.isEmpty else {
            return Fail<[CharacterResponse], RepositoryError>(error: .invalidParameters)
                .eraseToAnyPublisher()
        }
        
        if characterIds.count == 1, let id = characterIds.first {
            return getCharacter(by: id)
                .flatMap { response -> AnyPublisher<[CharacterResponse], RepositoryError> in
                    return Just([response])
                        .setFailureType(to: RepositoryError.self)
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        let idsParam = characterIds.map { "\($0)" }.joined(separator: ",")
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(idsParam)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            return Fail<[CharacterResponse], RepositoryError>(error: .invalidUrl)
                .eraseToAnyPublisher()
        }
        
        return get(from: url)
            .mapError { error -> RepositoryError in .serviceFail(error: error)}
            .eraseToAnyPublisher()
    }
}
