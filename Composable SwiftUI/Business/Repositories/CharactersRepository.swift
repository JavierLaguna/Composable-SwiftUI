protocol CharactersRepository {
    func getCharacters() async throws -> [Character]
    func getCharacters(characterIds: [Int]) async throws -> [Character]
}

// TODO: JLI - donde pongo esto?
struct CharactersRepositoryFactory {

    static func build() -> CharactersRepository {
        CharactersRepositoryDefault(
            service: CharacterRemoteDatasourceFactory.build()
        )
    }
}
