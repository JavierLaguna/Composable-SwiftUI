protocol GetCharacterInteractor: Sendable {
    func execute(id: Int) async throws -> Character
}

struct GetCharacterInteractorFactory {

    static func build() -> any GetCharacterInteractor {
        GetCharacterInteractorDefault(
            repository: CharactersRepositoryFactory.build()
        )
    }
}

struct GetCharacterInteractorDefault: GetCharacterInteractor, ManagedErrorInteractor {

    let repository: any CharactersRepository

    func execute(id: Int) async throws -> Character {
        do {
            return try await repository.getCharacter(characterId: id)

        } catch {
            throw manageError(error: error)
        }
    }
}
