struct GetEpisodesResponse: Codable {

    struct InfoResponse: Codable {
        let pages: Int
        let count: Int
    }

    let info: InfoResponse
    let results: [EpisodeResponse]
}
