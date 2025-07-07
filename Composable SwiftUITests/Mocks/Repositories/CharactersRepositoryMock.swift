import Foundation
@testable import Composable_SwiftUI

struct CharactersRepositoryMock: CharactersRepository {

    var success: Bool = true
    var expectedResponse: [Character] = [
        Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [],
                  created: Date.now,
                  description: nil)
    ]
    var expectedError: RepositoryError = .invalidUrl

    func getCharacters() async throws -> [Character] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }

    func getCharacters(characterIds: [Int]) async throws -> [Character] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }

    func getCharacter(characterId: Int) async throws -> Character {
        if success {
            return expectedResponse.first!
        } else {
            throw expectedError
        }
    }

    func getTotalCharactersCount() async throws -> Int {
        if success {
            return 10
        } else {
            throw expectedError
        }
    }
}
