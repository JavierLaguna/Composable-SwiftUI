
struct Location: Equatable {
    let id: Int
    let name: String
    let type: LocationType
    let dimension: String
    let residents: [Int]
}

enum LocationType: String, Equatable {
    case planet = "Planet"
    case microverse = "Microverse"
    case cluster = "Cluster"
    case spaceStation = "Space station"
    case TV = "TV"
    case resort = "Resort"
    case fantasyTown = "Fantasy town"
    case dimension = "Dimension"
    case menagerie = "Menagerie"
    case daycare = "Daycare"
    case citadel = "Citadel"
    case spacecraft = "Spacecraft"
    case satellite = "Satellite"
    case unknown = "Unknown"
}
