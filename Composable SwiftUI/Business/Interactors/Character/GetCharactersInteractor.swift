protocol GetCharactersInteractor: Sendable {
    func execute() async throws -> [Character]
    func execute(id: Int) async throws -> Character
    func execute(ids: [Int]) async throws -> [Character]
}

struct GetCharactersInteractorFactory {

    static func build() -> any GetCharactersInteractor {
         GetCharactersInteractorDefault(
            repository: CharactersRepositoryFactory.build()
        )
    }
}

struct GetCharactersInteractorDefault: GetCharactersInteractor, ManagedErrorInteractor {

    let repository: any CharactersRepository

    func execute() async throws -> [Character] {
        do {
            return try await repository.getCharacters()

        } catch {
            throw manageError(error: error)
        }
    }

    func execute(id: Int) async throws -> Character {
        do {
            return try await repository.getCharacter(characterId: id)

        } catch {
            throw manageError(error: error)
        }
    }

    func execute(ids: [Int]) async throws -> [Character] {
        do {
            return try await repository.getCharacters(characterIds: ids)

        } catch {
            throw manageError(error: error)
        }
    }
}
