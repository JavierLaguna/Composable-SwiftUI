import Foundation

struct Character: Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: String
    let episodes: [Int]
    let created: Date
    let description: String?

    func matchedEpisodes(with selectedCharacter: Character) -> MatchedEpisodes? {
        let filterEpisodes = self.episodes.filter {
            selectedCharacter.episodes.contains($0)
        }.sorted()

        guard let firstEpisode = filterEpisodes.first,
              let lastEpisode = filterEpisodes.last else {
            return nil
        }

        return MatchedEpisodes(
            character: self,
            count: filterEpisodes.count,
            diff: lastEpisode - firstEpisode,
            firstEpisode: firstEpisode,
            lastEpisode: lastEpisode
        )
    }

    func withDescription(_ description: String?) -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episodes: episodes,
            created: created,
            description: description
        )
    }
}
