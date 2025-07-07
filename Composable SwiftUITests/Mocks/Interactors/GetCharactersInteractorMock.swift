import Foundation
@testable import Composable_SwiftUI

struct GetCharactersInteractorMock: GetCharactersInteractor {

    var success: Bool = true
    var expectedResponse: [Character] = [
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: CharacterLocation(id: 1, name: "Earth"),
            location: CharacterLocation(id: 1, name: "Earth"),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episodes: [],
            created: Date.now,
            description: nil
        )
    ]

    func execute() async throws -> [Character] {
        if success {
            return expectedResponse
        } else {
            throw InteractorError.generic(message: "mock error")
        }
    }

    func execute(id: Int) async throws -> Character {
        if success {
            return expectedResponse.first!
        } else {
            throw InteractorError.generic(message: "mock error")
        }
    }

    func execute(ids: [Int]) async throws -> [Character] {
        if success {
            return expectedResponse
        } else {
            throw InteractorError.generic(message: "mock error")
        }
    }
}
