protocol CharactersRepository: Sendable {
    func getCharacters() async throws -> [Character]
    func getCharacters(characterIds: [Int]) async throws -> [Character]
}

struct CharactersRepositoryFactory {

    static func build() -> CharactersRepository {
        CharactersRepositoryDefault(
            service: CharacterRemoteDatasourceFactory.build()
        )
    }
}
