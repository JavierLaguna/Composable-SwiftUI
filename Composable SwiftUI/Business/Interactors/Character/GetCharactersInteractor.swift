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
