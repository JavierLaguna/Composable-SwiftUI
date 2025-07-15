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

    func toDomain() -> Character? {
        guard let created = created.dateFromApiDateString() else {
            return nil
        }

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
            created: created,
            description: nil
        )
    }
}
