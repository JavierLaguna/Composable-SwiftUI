import Mockable

@Mockable
protocol CharactersRepository: Sendable {
    func getCharacters() async throws -> [Character]
    func getCharacter(characterId: Int) async throws -> Character
    func getCharacters(characterIds: [Int]) async throws -> [Character]
    func getTotalCharactersCount() async throws -> Int
}

struct CharactersRepositoryFactory {

    static func build() -> any CharactersRepository {
        CharactersRepositoryDefault(
            service: CharacterRemoteDatasourceFactory.build()
        )
    }
}
