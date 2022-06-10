import XCTest

@testable import Composable_SwiftUI

final class ResponseMapperTests: XCTestCase {

    func testEpisodeResponseToDomain() throws {
        let response = EpisodeResponse(
            id: 1,
            name: "name",
            episode: "episode",
            date: "22-12-2022"
        )
        
        let domainDto = Episode (
            id: 1,
            name: "name",
            date: "22-12-2022"
        )
        
        XCTAssertEqual(response.toDomain(), domainDto)
    }
    
    func testLocationResponseToDomain() throws {
        let response = LocationResponse(
            name: "Earth",
            url: "url/id/1",
            residents: ["url/1", "url/3"]
        )
        
        let domainDto = CharacterLocation (
            id: 1,
            name: "Earth",
            residents: [1, 3]
        )
        
        XCTAssertEqual(response.toDomain(), domainDto)
    }
    
    func testCharacterResponseToDomain() throws {
        let locationResponse = LocationResponse(
            name: "Earth",
            url: "url/id/1",
            residents: ["url/1", "url/3"]
        )
        
        let response = CharacterResponse(
            id: 1,
            name: "Rick",
            status: "Dead",
            species: "",
            type: "Human",
            gender: "Male",
            origin: locationResponse,
            location: locationResponse,
            image: "url/image",
            episode: ["episode/1", "epidose/200"]
        )
        
        let domainDto = Character (
            id: 1,
            name: "Rick",
            status: .dead,
            species: "",
            type: "Human",
            gender: .male,
            origin: locationResponse.toDomain(),
            location: locationResponse.toDomain(),
            image: "url/image",
            episodes: [1, 200]
        )
        
        XCTAssertEqual(response.toDomain(), domainDto)
    }
}
