@testable import Composable_SwiftUI

struct CharacterRemoteDatasourceMock: CharacterRemoteDatasource {

    var success: Bool = true
    var expectedResponseByPage: GetCharactersResponse = GetCharactersResponse(
        info: GetCharactersResponse.InfoResponse(pages: 12),
        results: [
            CharacterResponse(id: 1, name: "Rick", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"])
        ]
    )
    var expectedResponseByIds: [CharacterResponse] = [
        CharacterResponse(id: 1, name: "Rick", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"]),
        CharacterResponse(id: 2, name: "Morty", status: "alive", species: "", type: "", gender: "male", origin: CharacterLocationResponse(name: "earth", url: "urlLocation"), location: CharacterLocationResponse(name: "earth", url: "urlLocation"), image: "image", episode: ["url/1", "url/2"])
    ]
    var expectedError: RepositoryError = .invalidUrl

    func getCharacters(page: Int?) async throws -> Composable_SwiftUI.GetCharactersResponse {
        if success {
            return expectedResponseByPage
        } else {
            throw expectedError
        }
    }

    func getCharacter(by id: Int) async throws -> CharacterResponse {
        if success {
            return expectedResponseByIds.first!
        } else {
            throw expectedError
        }
    }

    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        if success {
            return expectedResponseByIds
        } else {
            throw expectedError
        }
    }
}
