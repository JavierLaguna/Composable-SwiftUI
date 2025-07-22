import Foundation

extension BeerBuddy {

    static let mock = BeerBuddy(
        count: 1,
        buddy: Character.mock,
        character: Character(
            id: 3,
            name: "Morty",
            status: .dead,
            species: "Alien",
            type: "",
            gender: .male,
            origin: CharacterLocation(
                id: 1,
                name: "Earth"
            ),
            location: CharacterLocation(
                id: 1,
                name: "Earth"
            ),
            image: "https://rickandmortyapi.com/api/character/avatar3.jpeg",
            episodes: [],
            created: Date.now,
            description: nil
        ),
        firstEpisode: Episode.mock,
        lastEpisode: Episode.mock
    )
}
