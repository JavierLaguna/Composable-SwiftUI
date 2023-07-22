struct LocationResponse: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    
    func toDomain() -> Location {
        return Location(
            id: self.id,
            name: self.name,
            type: LocationType(rawValue: self.type) ?? .unknown,
            dimension: self.dimension,
            residents: self.residents.compactMap { $0.getIdFromUrl() }
        )
    }
}
