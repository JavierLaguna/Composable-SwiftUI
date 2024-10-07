struct GetCharactersResponse: Codable {

    struct InfoResponse: Codable {
        let pages: Int
    }

    let info: InfoResponse
    let results: [CharacterResponse]
}
