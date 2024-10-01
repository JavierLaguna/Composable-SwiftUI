protocol CharacterRemoteDatasource {
    func getCharacters(page: Int?) async throws -> GetCharactersResponse
    func getCharacter(by id: Int) async throws -> CharacterResponse
    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse]
}

struct CharacterRemoteDatasourceFactory {

    static func build() -> CharacterRemoteDatasource {
        CharacterService()
    }
}
