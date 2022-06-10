import Combine
import Resolver

final class CharactersRepositoryDefault: CharactersRepository {
    
    @Injected private var service: CharacterRemoteDatasource

    private(set) var nextPage: Int?
    private(set) var totalPages: Int?
    
    func getCharacters() -> AnyPublisher<[Character], RepositoryError> {
        
        if let nextPage = nextPage,
           let totalPages = totalPages,
           nextPage > totalPages {
            return Just([])
                .setFailureType(to: RepositoryError.self)
                .eraseToAnyPublisher()
        }
        
        return service.getCharacters(page: nextPage)
            .map { [weak self] response in
                if let nextPage = self?.nextPage {
                    self?.nextPage = nextPage + 1
                } else {
                    self?.nextPage = 2
                }
                
                self?.totalPages = response.info.pages
                
                return response.results.map{ $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    func getCharacters(characterIds: [Int]) -> AnyPublisher<[Character], RepositoryError> {
        
        return service.getCharacters(by: characterIds)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
