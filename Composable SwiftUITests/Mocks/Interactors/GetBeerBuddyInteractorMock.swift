import Foundation
@testable import Composable_SwiftUI

struct GetBeerBuddyInteractorMock: GetBeerBuddyInteractor {

    var success: Bool = true
    var expectedResponse: BeerBuddy? = BeerBuddy(
        count: 1,
        buddy: Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: [],
                         created: Date.now,
                         description: nil),
        character: Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: [],
                             created: Date.now,
                             description: nil),
        firstEpisode: Episode(id: 1, name: "First Episode", airDate: Date.now, code: "code-1", characters: [1, 2], created: Date.now, image: nil),
        lastEpisode: Episode(id: 1, name: "First Episode", airDate: Date.now, code: "code-1", characters: [1, 2], created: Date.now, image: nil)
    )

    func execute(character: Character) async throws -> BeerBuddy? {
        if success {
            return expectedResponse
        } else {
            throw InteractorError.generic(message: "mock error")
        }
    }
}
