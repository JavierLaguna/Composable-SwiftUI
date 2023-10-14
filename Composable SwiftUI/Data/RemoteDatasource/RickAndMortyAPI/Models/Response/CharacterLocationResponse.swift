struct CharacterLocationResponse: Codable {
    let name: String
    let url: String

    func toDomain() -> CharacterLocation {
        CharacterLocation(
            id: self.url.getIdFromUrl() ?? 0,
            name: self.name
        )
    }
}
