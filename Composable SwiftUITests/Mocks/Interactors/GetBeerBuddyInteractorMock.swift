import Combine

@testable import Composable_SwiftUI

struct GetBeerBuddyInteractorMock: GetBeerBuddyInteractor {

    var success: Bool = true
    var expectedResponse: BeerBuddy? = BeerBuddy(
        count: 1,
        buddy: Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
        character: Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: []),
        firstEpisode: Episode(id: 1, name: "First Episode", date: "11-11-2011"),
        lastEpisode: Episode(id: 1, name: "First Episode", date: "11-11-2011")
    )
    
    func execute(character: Character) -> AnyPublisher<BeerBuddy?, InteractorError> {
        guard success else {
            return Fail(error: .generic(message: "mock error"))
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
}
