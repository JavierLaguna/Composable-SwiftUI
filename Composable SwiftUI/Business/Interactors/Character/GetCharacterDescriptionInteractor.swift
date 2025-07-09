import Foundation
import Mockable
import FoundationModels

@Mockable
protocol GetCharacterDescriptionInteractor: Sendable {
    func execute(character: Character) async throws -> String
}

struct GetCharacterDescriptionInteractorFactory {

    static func build() -> any GetCharacterDescriptionInteractor {
        GetCharacterDescriptionInteractorDefault()
    }
}

struct GetCharacterDescriptionInteractorDefault: GetCharacterDescriptionInteractor, ManagedErrorInteractor {

    private let session = LanguageModelSession()

    func execute(character: Character) async throws -> String {
        let response = try await session.respond(
            to: "Create a good description for a Rick, the character of the famous rick and morty Tv program"
        )

        print("Response", response)
        return response.content
    }
}
