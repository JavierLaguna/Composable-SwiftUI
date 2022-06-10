import XCTest

@testable import Composable_SwiftUI

final class CharacterTests: XCTestCase {
    
    func testMatchedEpisodes() {
        let location = CharacterLocation(id: 1, name: "Earth", residents: [])
        
        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])
        
        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])
        
        let matchedEpisodes = rick.matchedEpisodes(with: morty)
        
        XCTAssertEqual(matchedEpisodes?.character, rick)
        XCTAssertEqual(matchedEpisodes?.count, 5)
        XCTAssertEqual(matchedEpisodes?.diff, 300)
        XCTAssertEqual(matchedEpisodes?.firstEpisode, 1)
        XCTAssertEqual(matchedEpisodes?.lastEpisode, 301)
    }
    
    func testMatchedEpisodesReturnNil() {
        let location = CharacterLocation(id: 1, name: "Earth", residents: [])
        
        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [200, 301])
        
        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2])
        
        let matchedEpisodes = rick.matchedEpisodes(with: morty)
        
        XCTAssertNil(matchedEpisodes)
    }
}
