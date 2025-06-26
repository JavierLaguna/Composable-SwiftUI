import Foundation

extension Character {

    static let mock: Character = {
        let location = CharacterLocation(id: 1, name: "Earth")

        return Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "Planet",
            gender: .male,
            origin: location,
            location: location,
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episodes: [1, 2, 5, 7, 12, 23, 67],
            created: Date(),
            description: CharacterDescriptionMock.description
        )
    }()
}
