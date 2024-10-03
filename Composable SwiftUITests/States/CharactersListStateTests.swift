import Testing

@testable import Composable_SwiftUI

@Suite(
    "CharactersListState",
    .tags(.state)
)
struct CharactersListStateTests {

    @Test
    func filteredCharacters() {
        let location = CharacterLocation(id: 1, name: "Earth")
        let characters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: []),
            Character(id: 4, name: "Morty rick", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar4.jpeg", episodes: [])
        ]
        let shouldFilteredcharacters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 4, name: "Morty rick", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar4.jpeg", episodes: [])
        ]

        var state = CharactersListReducer.State()
        #expect(state.filteredCharacters == nil)

        state.characters.state = .populated(data: characters)
        #expect(state.filteredCharacters?.count == 3)
        #expect(state.filteredCharacters == characters)

        state.searchText = "RICK"
        #expect(state.filteredCharacters?.count == 2)
        #expect(state.filteredCharacters == shouldFilteredcharacters)

        state.searchText = "QWERTY"
        #expect(state.filteredCharacters?.isEmpty ?? false)
        #expect(state.filteredCharacters == [])
    }
}
