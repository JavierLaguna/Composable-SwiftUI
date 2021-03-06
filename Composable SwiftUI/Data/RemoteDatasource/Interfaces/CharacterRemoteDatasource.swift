import Combine

protocol CharacterRemoteDatasource {
    func getCharacters(page: Int?) -> AnyPublisher<GetCharactersResponse, RepositoryError>
    func getCharacter(by id: Int) -> AnyPublisher<CharacterResponse, RepositoryError>
    func getCharacters(by characterIds: [Int]) -> AnyPublisher<[CharacterResponse], RepositoryError>
}
