protocol GetCharacterInteractor: Sendable {
    func execute(id: Int) async throws -> Character
}

struct GetCharacterInteractorFactory {

    static func build() -> any GetCharacterInteractor {
        GetCharacterInteractorDefault(
            repository: CharactersRepositoryFactory.build(),
            getCharacterDescriptionInteractor: GetCharacterDescriptionInteractorFactory.build()
        )
    }
}

struct GetCharacterInteractorDefault: GetCharacterInteractor, ManagedErrorInteractor {

    let repository: any CharactersRepository
    let getCharacterDescriptionInteractor: any GetCharacterDescriptionInteractor

    func execute(id: Int) async throws -> Character {
        do {
            let character = try await repository.getCharacter(characterId: id)
            
            let description = try await getCharacterDescriptionInteractor.execute(character: character)
            
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                origin: character.origin,
                location: character.location,
                image: character.image,
                episodes: character.episodes,
                created: character.created,
                description: description
            )

        } catch {
            throw manageError(error: error)
        }
    }
}
