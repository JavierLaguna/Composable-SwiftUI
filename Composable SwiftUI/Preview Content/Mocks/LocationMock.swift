import Foundation

extension Location {

    static let mock = Location(
        id: 21,
        name: "Testicle Monster Dimension",
        type: .dimension,
        dimension: "Testicle Monster Dimension",
        residents: [1, 4]
    )

    static let mocks: [Location] = (1...10).map { index in
        Location(
            id: index,
            name: "Location \(index)",
            type: .planet,
            dimension: "Dimension C-\(index)",
            residents: Array(1...Int.random(in: 1...20))
        )
    }
}
