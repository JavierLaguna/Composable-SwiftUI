struct LocationResponse: Codable {
    let name: String
    let url: String
    let residents: [String]?
    
    func toDomain() -> CharacterLocation {
        return CharacterLocation(
            id: self.url.getIdFromUrl() ?? 0,
            name: self.name,
            residents: self.residents?.compactMap { $0.getIdFromUrl() } ?? []
        )
    }
}
