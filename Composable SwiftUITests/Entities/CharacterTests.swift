import Testing

@testable import Composable_SwiftUI

@Suite("Character Tests")
struct CharacterTests {

    @Test
    func matchedEpisodes() {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let matchedEpisodes = rick.matchedEpisodes(with: morty)

        #expect(matchedEpisodes?.character == rick)
        #expect(matchedEpisodes?.count == 5)
        #expect(matchedEpisodes?.diff == 300)
        #expect(matchedEpisodes?.firstEpisode == 1)
        #expect(matchedEpisodes?.lastEpisode == 301)
    }

    @Test
    func matchedEpisodesReturnNil() {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2])

        let matchedEpisodes = rick.matchedEpisodes(with: morty)

        #expect(matchedEpisodes == nil)
    }
}
