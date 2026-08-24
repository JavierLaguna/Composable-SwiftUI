import Foundation
import Mockable
import FoundationModels

@Mockable
protocol GetCharacterDescriptionInteractor: Sendable {
    func execute(character: Character) async throws -> String
}

struct GetCharacterDescriptionInteractorFactory {

    static func build() -> any GetCharacterDescriptionInteractor {
        if #available(iOS 26.0, *) {
            GetCharacterDescriptionInteractorByAppleIntelligence()
        } else {
            GetCharacterDescriptionInteractorNotAvailable()
        }
    }
}

@available(iOS 26.0, *)
struct CharacterDescriptionSessionClient: Sendable {

    var isResponding: @Sendable () -> Bool
    var respond: @Sendable (String) async throws -> CharacterDescription

    init(
        isResponding: @escaping @Sendable () -> Bool,
        respond: @escaping @Sendable (String) async throws -> CharacterDescription
    ) {
        self.isResponding = isResponding
        self.respond = respond
    }

    static func live(session: LanguageModelSession) -> Self {
        Self(
            isResponding: { session.isResponding },
            respond: { prompt in
                let response = try await session.respond(
                    to: prompt,
                    generating: CharacterDescription.self,
                    options: GenerationOptions(sampling: .greedy)
                )
                return response.content
            }
        )
    }
}

@available(iOS 26.0, *)
struct GetCharacterDescriptionInteractorByAppleIntelligence: GetCharacterDescriptionInteractor {

    static private let model = SystemLanguageModel.default
    static private let instructions = """
        You are a Rick and Morty expert. Describe characters using only facts clearly shown in the show. Never invent details, jobs, relationships, or names. Never include meta-information like voice actors or episode numbers. Be punchy and true to the show's tone. Max 60 words.
        """

    static var isAvailable: Bool {
        Self.model.isAvailable
    }

    static var availabilityReason: SystemLanguageModel.Availability {
        Self.model.availability
    }

    private let sessionClient: CharacterDescriptionSessionClient
    private let waitDuration: Duration
    private let isAvailableOverride: Bool?

    init() {
        self.init(
            sessionClient: .live(session: LanguageModelSession(model: Self.model)),
            waitDuration: .seconds(2),
            isAvailableOverride: nil
        )
    }

    init(
        sessionClient: CharacterDescriptionSessionClient,
        waitDuration: Duration = .seconds(2),
        isAvailableOverride: Bool? = nil
    ) {
        self.sessionClient = sessionClient
        self.waitDuration = waitDuration
        self.isAvailableOverride = isAvailableOverride
    }

    func execute(character: Character) async throws -> String {
        guard isAvailableOverride ?? Self.isAvailable else {
            throw AppleIntelligenceNotAvailableError(from: Self.availabilityReason)
        }

        if sessionClient.isResponding() {
            try await Task.sleep(for: waitDuration)
        }

        try Task.checkCancellation()

        let prompt = "Give me a short, canon-accurate description of \(character.name) from Rick and Morty. "
            + "Only include facts clearly established in the show. Do not invent or assume anything."
        let response = try await sessionClient.respond(prompt)

        try Task.checkCancellation()
        return response.text
    }
}

struct GetCharacterDescriptionInteractorNotAvailable: GetCharacterDescriptionInteractor {

    func execute(character: Character) async throws -> String {
        throw AppleIntelligenceNotAvailableError.deviceNotEligible
    }
}

struct GetCharacterDescriptionInteractorLoremIpsum: GetCharacterDescriptionInteractor {

    func execute(character: Character) async throws -> String {
        try await Task.sleep(nanoseconds: 5_000_000_000)

        if Bool.random() {
            return """
               Lorem ipsum dolor sit amet consectetur adipiscing, elit cubilia maecenas inceptos rutrum hac, sed faucibus interdum commodo curabitur. Gravida felis leo ut habitant eget in nam turpis vitae, quam taciti nullam aliquet rhoncus quisque dictumst fusce mattis, vel dui maecenas enim morbi sociosqu himenaeos erat. Fusce penatibus dictum pellentesque odio sagittis lobortis fermentum hendrerit mattis placerat, vel sociis facilisi tortor quisque tempus nisi mus primis, iaculis nisl ac egestas leo pulvinar ante quam vulputate.
               """
        } else {
            return """
               Lorem ipsum dolor sit amet consectetur adipiscing, elit cubilia maecenas inceptos rutrum hac, sed faucibus interdum commodo curabitur. Gravida felis leo ut habitant eget in nam turpis vitae, quam taciti nullam aliquet rhoncus quisque dictumst fusce mattis, vel dui maecenas enim morbi sociosqu himenaeos erat. Fusce penatibus dictum pellentesque odio sagittis lobortis fermentum hendrerit mattis placerat, vel sociis facilisi tortor quisque tempus nisi mus primis, iaculis nisl ac egestas leo pulvinar ante quam vulputate.

               Augue pretium sodales vestibulum lectus interdum scelerisque, orci convallis curabitur feugiat phasellus, curae imperdiet mollis volutpat aliquet. Placerat augue tempus integer dui ante mus vitae, litora urna interdum nulla elementum massa, est sociis porttitor volutpat laoreet viverra. Orci diam conubia nisl quisque eu ornare nulla, faucibus pulvinar congue rhoncus purus dapibus, turpis justo aliquam nullam eleifend vulputate.
               """
        }
    }
}
