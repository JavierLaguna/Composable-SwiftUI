import Foundation

struct EpisodeResponse: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case created
    }

    func toDomain() -> Episode {
        let formatter = ISO8601DateFormatter() // TODO: JLI - Make reusable with only 1 init, lazy?
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        formatter2.dateFormat = "MMMM d, yyyy"

        return Episode(
            id: id,
            name: name,
            airDate: formatter2.date(from: airDate)!, // TODO: JLI
            episode: episode,
            characters: characters.compactMap { $0.getIdFromUrl() },
            created: formatter.date(from: created)!, // TODO: JLI
            image: nil
        )
    }
}
