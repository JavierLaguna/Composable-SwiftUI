protocol GetCharactersInteractor {
    func execute() async throws -> [Character]
}

struct GetCharactersInteractorFactory {

    static func build() -> GetCharactersInteractor {
         GetCharactersInteractorDefault(
            repository: CharactersRepositoryFactory.build()
        )
    }
}

struct GetCharactersInteractorDefault: GetCharactersInteractor, ManagedErrorInteractor {

    let repository: CharactersRepository

    func execute() async throws -> [Character] {
        do {
            return try await repository.getCharacters()

        } catch {
            throw manageError(error: error)
        }
    }
}
