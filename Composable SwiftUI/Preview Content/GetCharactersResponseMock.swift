import Foundation

extension GetCharactersResponse {

    static let mock = CharacterResponse(
        id: 1,
        name: "Rick",
        status: "alive",
        species: "",
        type: "",
        gender: "male",
        origin: CharacterLocationResponse(
            name: "earth",
            url: "urlLocation"
        ),
        location: CharacterLocationResponse(
            name: "earth",
            url: "urlLocation"
        ),
        image: "image",
        episode: [
            "url/1",
            "url/2"
        ],
        created: "2017-11-04T18:48:46.250Z"
    )

    static let mocks: [CharacterResponse] = [
        Self.mock,
        CharacterResponse(
            id: 2,
            name: "Morty",
            status: "alive",
            species: "",
            type: "",
            gender: "male",
            origin: CharacterLocationResponse(
                name: "earth",
                url: "urlLocation"
            ),
            location: CharacterLocationResponse(
                name: "earth",
                url: "urlLocation"
            ),
            image: "image",
            episode: [
                "url/1",
                "url/2"
            ],
            created: "2017-11-04T18:48:46.250Z"
        )
    ]
}
