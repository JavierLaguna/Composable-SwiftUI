import Testing

@testable import Composable_SwiftUI

@Suite("ResponseMapper Tests")
struct ResponseMapperTests {

    @Test
    func locationResponseToDomain() {
        let response = LocationResponse(
            id: 1,
            name: "Earth",
            type: "Spacecraft",
            dimension: "dimension",
            residents: ["url/1", "url/3"]
        )

        let domainDto = Location(
            id: 1,
            name: "Earth",
            type: .spacecraft,
            dimension: "dimension",
            residents: [1, 3]
        )

        #expect(response.toDomain() == domainDto)
    }

    @Test
    func characterResponseToDomain() {
        let locationResponse = CharacterLocationResponse(
            name: "Earth",
            url: "url/1"
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

        let domainDto = Character(
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

        #expect(response.toDomain() == domainDto)
    }
}
