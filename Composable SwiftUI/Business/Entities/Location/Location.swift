struct Location: Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let type: LocationType
    let dimension: String
    let residents: [Int]
}
