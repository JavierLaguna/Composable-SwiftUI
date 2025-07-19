import Foundation

extension CharacterLocation {

    static let mock = CharacterLocation(id: 1, name: "Earth")

    static let mocks: [CharacterLocation] = (1...10).map { i in
        CharacterLocation(
            id: i,
            name: [
                "Earth",
                "Gazorpazorp",
                "Bird World",
                "Cronenberg World",
                "Froopyland",
                "Purge Planet",
                "Citadel of Ricks",
                "Anatomy Park",
                "Blips and Chitz",
                "Unity's Planet"
            ].randomElement()!
        )
    }
}
