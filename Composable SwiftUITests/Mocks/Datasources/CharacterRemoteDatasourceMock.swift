import Combine

@testable import Composable_SwiftUI

struct CharacterRemoteDatasourceMock: CharacterRemoteDatasource {
    
    var success: Bool = true
    var expectedResponseByPage: GetCharactersResponse = GetCharactersResponse(
        info: GetCharactersResponse.InfoResponse(pages: 12),
        results: [
            CharacterResponse(id: 1, name: "Rick", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"])
        ]
    )
    var expectedResponseByIds: [CharacterResponse] = [
        CharacterResponse(id: 1, name: "Rick", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"]),
        CharacterResponse(id: 2, name: "Morty", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"])
    ]
    var expectedError: RepositoryError = .invalidUrl
    
    
    func getCharacters(page: Int?) -> AnyPublisher<GetCharactersResponse, RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponseByPage)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func getCharacter(by id: Int) -> AnyPublisher<CharacterResponse, RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponseByIds.first!)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func getCharacters(by characterIds: [Int]) -> AnyPublisher<[CharacterResponse], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponseByIds)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func getCharacter(by id: Int) async throws -> CharacterResponse {
        expectedResponseByIds.first!
    }
    
    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        expectedResponseByIds
    }
}
