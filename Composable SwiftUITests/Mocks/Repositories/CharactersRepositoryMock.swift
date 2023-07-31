import Combine

@testable import Composable_SwiftUI

struct CharactersRepositoryMock: CharactersRepository {
    
    var success: Bool = true
    var expectedResponse: [Character] = [
        Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
    ]
    var expectedError: RepositoryError = .invalidUrl
    
    func getCharacters() -> AnyPublisher<[Character], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func getCharacters(characterIds: [Int]) -> AnyPublisher<[Character], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
}
