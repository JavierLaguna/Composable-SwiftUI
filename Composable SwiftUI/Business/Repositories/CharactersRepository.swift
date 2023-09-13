
protocol CharactersRepository {
    func getCharacters() async throws -> [Character]
    func getCharacters(characterIds: [Int]) async throws -> [Character]
}
