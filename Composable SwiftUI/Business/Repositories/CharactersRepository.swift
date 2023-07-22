import Combine

protocol CharactersRepository {
    func getCharacters() -> AnyPublisher<[Character], RepositoryError>
    func getCharacters(characterIds: [Int]) -> AnyPublisher<[Character], RepositoryError>
    func getCharacters(characterIds: [Int]) async throws -> [Character]
}
