import UIKit

protocol GetEpisodeImageInteractor: Sendable {
    func execute(episode: Episode) async throws -> UIImage?
}

struct GetEpisodeImageInteractorFactory {

    static func build() -> any GetEpisodeImageInteractor {
        GetEpisodeImageInteractorDefault()
    }
}

struct GetEpisodeImageInteractorDefault: GetEpisodeImageInteractor, ManagedErrorInteractor {

    func execute(episode: Episode) async throws -> UIImage? {
        UIImage(named: "Episode_\(Int.random(in: 1...10))")
    }
}
