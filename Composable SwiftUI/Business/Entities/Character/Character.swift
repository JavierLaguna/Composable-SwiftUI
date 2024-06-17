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
}
