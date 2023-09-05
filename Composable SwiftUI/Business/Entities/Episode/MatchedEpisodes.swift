struct MatchedEpisodes {
    let character: Character
    let count: Int
    let diff: Int
    let firstEpisode: Int
    let lastEpisode: Int
}

extension MatchedEpisodes: Comparable {
    
    static func < (lhs: MatchedEpisodes, rhs: MatchedEpisodes) -> Bool {
        if (lhs.count == rhs.count && lhs.diff == rhs.diff) {
            return lhs.character.id == rhs.character.id
        } else if (lhs.count == rhs.count && lhs.diff != rhs.diff) {
            return lhs.diff == rhs.diff
        } else {
            return lhs.count == rhs.count
        }
    }
}
