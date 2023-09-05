import Combine
import Foundation

final class CharacterService: HttpClient, CharacterRemoteDatasource {
    
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
    
    func getCharacter(by id: Int) async throws -> CharacterResponse {
        fatalError("not implemented, use CharacterServiceAsync")
    }
    
    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        fatalError("not implemented, use CharacterServiceAsync")
    }
}

final class CharacterServiceAsync: AsyncHttpClient, CharacterRemoteDatasource {
    
    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/character"
    
    func getCharacters(page: Int? = nil) -> AnyPublisher<GetCharactersResponse, RepositoryError> {
        
        fatalError("not implemented, use CharacterService")
    }
    
    func getCharacter(by id: Int) -> AnyPublisher<CharacterResponse, RepositoryError> {
        
        fatalError("not implemented, use CharacterService")
    }
    
    func getCharacters(by characterIds: [Int]) -> AnyPublisher<[CharacterResponse], RepositoryError> {
        
        fatalError("not implemented, use CharacterService")
    }
    
    func getCharacter(by id: Int) async throws -> CharacterResponse {
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(id)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }
        
        return try await get(from: url)
    }
    
    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        guard !characterIds.isEmpty else {
            throw RepositoryError.invalidParameters
        }
        
        if characterIds.count == 1, let id = characterIds.first {
            let response = try await getCharacter(by: id)
            return [response]
        }
        
        let idsParam = characterIds.map { "\($0)" }.joined(separator: ",")
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(idsParam)"),
            resolvingAgainstBaseURL: false
        )
        
        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }
        
        return try await get(from: url)
    }
}
