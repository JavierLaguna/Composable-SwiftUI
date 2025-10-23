import Foundation

extension GetCharactersResponse {

    static let mock = GetCharactersResponse(
        info: .init(
            pages: 12,
            count: CharacterResponse.mocks.count
        ),
        results: CharacterResponse.mocks
    )
}
