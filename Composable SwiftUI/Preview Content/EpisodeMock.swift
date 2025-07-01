import UIKit

extension Episode {

    static let mock: Episode = Episode(
        id: 1,
        name: "Pilot",
        airDate: Date(timeIntervalSince1970: 1385980800), // December 2, 2013
        code: "S01E01",
        characters: [1, 2, 35, 38],
        created: Date(),
        image: UIImage(named: "Episode_1")
    )

    static let mocks: [Episode] = (1...10).map { index in
        Episode(
            id: index,
            name: "Episode \(index)",
            airDate: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: index)) ?? .distantPast,
            code: "S01E\(String(format: "%02d", index))",
            characters: (1...5).map { $0 + index },
            created: Date(timeIntervalSince1970: 1700000000 + TimeInterval(index * 86400)),
            image: UIImage(named: "Episode_\(Int.random(in: 1...10))")
        )
    }
}
