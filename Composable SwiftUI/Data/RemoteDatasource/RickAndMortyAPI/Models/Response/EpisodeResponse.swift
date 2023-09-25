struct EpisodeResponse: Codable {
    let id: Int
    let name: String
    let episode: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case date = "air_date"
    }

    func toDomain() -> Episode {
        Episode(
            id: self.id,
            name: self.name,
            date: self.date
        )
    }
}
