import Foundation

struct CharacterResponse: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterLocationResponse
    let location: CharacterLocationResponse
    let image: String
    let episode: [String]
    let created: String

    func toDomain() -> Character {
        let formatter = ISO8601DateFormatter() // TODO: JLI - Make reusable with only 1 init, lazy?
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return Character(
            id: id,
            name: name,
            status: CharacterStatus(rawValue: status) ?? .unknown,
            species: species,
            type: type,
            gender: CharacterGender(rawValue: gender) ?? .unknown,
            origin: origin.toDomain(),
            location: location.toDomain(),
            image: image,
            episodes: episode.compactMap { $0.getIdFromUrl() },
            created: formatter.date(from: created)!, // TODO: JLI
            description: nil
        )
    }
}
