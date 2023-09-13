import Resolver

protocol GetCharactersInteractor {
    func execute() async throws -> [Character]
}

final class GetCharactersInteractorDefault: GetCharactersInteractor, ManagedErrorInteractor {
    
    @Injected private var repository: CharactersRepository
    
    func execute() async throws -> [Character] {
        do {
            let response = try await repository.getCharacters()
            return response
            
        } catch {
            throw manageError(error: error)
        }
    }
}


// TODO: JLI
protocol ManagedErrorInteractor {
    func manageError(error: Error) -> Error
}

extension ManagedErrorInteractor {
    
    func manageError(error: Error) -> Error {
        guard let repositoryError = error as? RepositoryError else {
            return error
        }
        
        return InteractorError.repositoryFail(error: repositoryError)
    }
}
