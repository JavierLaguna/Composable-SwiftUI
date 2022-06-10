import XCTest

@testable import Composable_SwiftUI

final class CharactersListStateTests: XCTestCase {

    func testFilteredCharacters() throws {
        let location = CharacterLocation(id: 1, name: "Earth", residents: [])
        let characters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: []),
            Character(id: 4, name: "Morty rick", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar4.jpeg", episodes: [])
        ]
        let shouldFilteredcharacters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 4, name: "Morty rick", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar4.jpeg", episodes: [])
        ]
        
        var state = CharactersListState()
        XCTAssertNil(state.filteredCharacters)
        
        state.characters.state = .populated(data: characters)
        XCTAssertEqual(state.filteredCharacters?.count, 3)
        XCTAssertEqual(state.filteredCharacters, characters)
        
        state.searchText = "RICK"
        XCTAssertEqual(state.filteredCharacters?.count, 2)
        XCTAssertEqual(state.filteredCharacters, shouldFilteredcharacters)
        
        state.searchText = "QWERTY"
        XCTAssertEqual(state.filteredCharacters?.count, 0)
        XCTAssertEqual(state.filteredCharacters, [])
    }
}
