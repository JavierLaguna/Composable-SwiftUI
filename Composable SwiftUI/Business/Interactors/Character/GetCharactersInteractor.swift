import Combine
import Resolver

protocol GetCharactersInteractor {
    func execute() -> AnyPublisher<[Character], InteractorError>
}

final class GetCharactersInteractorDefault: GetCharactersInteractor {
    
    @Injected private var repository: CharactersRepository
    
    func execute() -> AnyPublisher<[Character], InteractorError> {
    
        return repository
            .getCharacters()
            .catch { error -> AnyPublisher<[Character], InteractorError> in
                return Fail<[Character], InteractorError>(error: .repositoryFail(error: error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
