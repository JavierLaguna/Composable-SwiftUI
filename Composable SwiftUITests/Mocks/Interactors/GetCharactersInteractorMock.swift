import Combine

@testable import Composable_SwiftUI

struct GetCharactersInteractorMock: GetCharactersInteractor {

    var success: Bool = true
    var expectedResponse: [Character] = [
        Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
    ]
    
    func execute() -> AnyPublisher<[Character], InteractorError> {
        guard success else {
            return Fail(error: .generic(message: "mock error"))
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
}
