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
            GetCharacterDescriptionInteractorLoremIpsum()
        }
    }
}

@available(iOS 26.0, *)
struct GetCharacterDescriptionInteractorByAppleIntelligence: GetCharacterDescriptionInteractor, ManagedErrorInteractor {

    private let session = LanguageModelSession()

    func execute(character: Character) async throws -> String {
        do {
            let response = try await session.respond(
                to: "Create a good description for a Rick, the character of the famous rick and morty Tv program"
            )
            print("Response", response)
            return response.content
        } catch {
            print(error)
        }

        return ""
    }
}

struct GetCharacterDescriptionInteractorLoremIpsum: GetCharacterDescriptionInteractor, ManagedErrorInteractor {

    func execute(character: Character) async throws -> String {
        if Bool.random() {
           """
              Lorem ipsum dolor sit amet consectetur adipiscing, elit cubilia maecenas inceptos rutrum hac, sed faucibus interdum commodo curabitur. Gravida felis leo ut habitant eget in nam turpis vitae, quam taciti nullam aliquet rhoncus quisque dictumst fusce mattis, vel dui maecenas enim morbi sociosqu himenaeos erat. Fusce penatibus dictum pellentesque odio sagittis lobortis fermentum hendrerit mattis placerat, vel sociis facilisi tortor quisque tempus nisi mus primis, iaculis nisl ac egestas leo pulvinar ante quam vulputate.
              """

        } else {
           """
              Lorem ipsum dolor sit amet consectetur adipiscing, elit cubilia maecenas inceptos rutrum hac, sed faucibus interdum commodo curabitur. Gravida felis leo ut habitant eget in nam turpis vitae, quam taciti nullam aliquet rhoncus quisque dictumst fusce mattis, vel dui maecenas enim morbi sociosqu himenaeos erat. Fusce penatibus dictum pellentesque odio sagittis lobortis fermentum hendrerit mattis placerat, vel sociis facilisi tortor quisque tempus nisi mus primis, iaculis nisl ac egestas leo pulvinar ante quam vulputate.

              Augue pretium sodales vestibulum lectus interdum scelerisque, orci convallis curabitur feugiat phasellus, curae imperdiet mollis volutpat aliquet. Placerat augue tempus integer dui ante mus vitae, litora urna interdum nulla elementum massa, est sociis porttitor volutpat laoreet viverra. Orci diam conubia nisl quisque eu ornare nulla, faucibus pulvinar congue rhoncus purus dapibus, turpis justo aliquam nullam eleifend vulputate.
              """
        }
    }
}
