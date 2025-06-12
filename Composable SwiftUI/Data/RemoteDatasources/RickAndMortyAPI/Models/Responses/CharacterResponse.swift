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
    let created: Date

    func toDomain() -> Character {
        Character(
            id: self.id,
            name: self.name,
            status: CharacterStatus(rawValue: self.status) ?? .unknown,
            species: self.species,
            type: self.type,
            gender: CharacterGender(rawValue: self.gender) ?? .unknown,
            origin: self.origin.toDomain(),
            location: self.location.toDomain(),
            image: self.image,
            episodes: self.episode.compactMap { $0.getIdFromUrl() },
            created: self.created,
            description: nil
        )
    }
}
