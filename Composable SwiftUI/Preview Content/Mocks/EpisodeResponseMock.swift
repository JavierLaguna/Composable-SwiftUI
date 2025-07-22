import Foundation

extension EpisodeResponse {

    static let mock = EpisodeResponse(
        id: 1,
        name: "Episode 1",
        airDate: "December 2, 2013",
        episode: "episode 1",
        characters: ["url/1", "url/2"],
        created: "2017-11-04T18:48:46.250Z"
    )

    static let mocks: [EpisodeResponse] = [
        mock,
        EpisodeResponse(
            id: 2,
            name: "Episode 2",
            airDate: "December 31, 2014",
            episode: "episode 2",
            characters: ["url/2", "url/3", "url/5"],
            created: "2017-11-04T18:48:46.250Z"
        )
    ]
}
