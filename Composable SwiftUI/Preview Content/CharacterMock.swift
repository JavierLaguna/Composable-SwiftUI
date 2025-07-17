import Foundation

extension Character {

    static let mock = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        type: "Planet",
        gender: .male,
        origin: CharacterLocation.mock,
        location: CharacterLocation.mock,
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodes: [1, 2, 5, 7, 12, 23, 67],
        created: "2015-05-20".dateFromYearMothDayString()!,
        description: CharacterDescriptionMock.description
    )

    static let mocks: [Character] = (1...10).map { i in
        Character(
            id: i,
            name: [
                "Rick Sanchez",
                "Morty Smith",
                "Summer Smith",
                "Beth Smith",
                "Jerry Smith",
                "Birdperson",
                "Squanchy",
                "Mr. Meeseeks",
                "Evil Morty",
                "Abradolf Lincler"
            ].randomElement()!,
            status: CharacterStatus.allCases.randomElement()!,
            species: [
                "Human",
                "Alien",
                "Robot",
                "Cronenberg",
                "Gromflomite"
            ].randomElement()!,
            type: [
                "",
                "Planet",
                "Clone",
                "Parasite",
                "Cyborg"
            ].randomElement()!,
            gender: CharacterGender.allCases.randomElement()!,
            origin: CharacterLocation.mocks.randomElement()!,
            location: CharacterLocation.mocks.randomElement()!,
            image: "https://rickandmortyapi.com/api/character/avatar/\(i).jpeg",
            episodes: (1...Int.random(in: 3...8)).map { _ in Int.random(in: 1...70)
            }.sorted(),
            created: Date(timeIntervalSince1970: TimeInterval(Int.random(in: 1_400_000_000...1_700_000_000))),
            description: Bool.random() ? CharacterDescriptionMock.description : nil
        )
    }
}
