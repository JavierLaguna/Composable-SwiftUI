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

    func toDomain() -> Episode? {
        guard let created = created.dateFromApiFullDateString(),
              let airDate = airDate.dateFromApiMonthDayYearDateString() else {
            return nil
        }

        return Episode(
            id: id,
            name: name,
            airDate: airDate,
            code: episode,
            characters: characters.compactMap { $0.getIdFromUrl() },
            created: created,
            image: nil
        )
    }
}
