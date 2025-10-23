import UIKit
import Mockable

@Mockable
protocol GetEpisodesInteractor: Sendable {
    func execute() async throws -> [Episode]
    func execute(id: Int) async throws -> Episode
    func execute(ids: [Int]) async throws -> [Episode]
}

struct GetEpisodesInteractorFactory {

    static func build() -> any GetEpisodesInteractor {
        GetEpisodesInteractorDefault(
            episodesRepository: EpisodesRepositoryFactory.build(),
            getEpisodeImageInteractor: GetEpisodeImageInteractorFactory.build()
        )
    }
}

struct GetEpisodesInteractorDefault: GetEpisodesInteractor, ManagedErrorInteractor {

    let episodesRepository: any EpisodesRepository
    let getEpisodeImageInteractor: any GetEpisodeImageInteractor

    func execute() async throws -> [Episode] {
        do {
            let episodes = try await episodesRepository.getEpisodes()
            let episodesWithImages = try await episodesWithImages(for: episodes)
            return sorted(episodes: episodesWithImages)

        } catch {
            throw manageError(error: error)
        }
    }

    func execute(id: Int) async throws -> Episode {
        guard let episode = try await execute(ids: [id]).first else {
            throw InteractorError.generic(message: "Empty response")
        }

        return episode
    }

    func execute(ids: [Int]) async throws -> [Episode] {
        do {
            let episodes = try await episodesRepository.getEpisodesFromList(ids: ids)
            let episodesWithImages = try await episodesWithImages(for: episodes)
            return sorted(episodes: episodesWithImages)

        } catch {
            throw manageError(error: error)
        }
    }
}

// MARK: Private methods
private extension GetEpisodesInteractorDefault {

    func episodesWithImages(for episodes: [Episode]) async throws -> [Episode] {
        try await withThrowingTaskGroup(of: Episode.self) { group in
            for episode in episodes {
                group.addTask {
                    let image = try await getEpisodeImageInteractor.execute(episode: episode)
                    return episode.copy(image: image)
                }
            }

            var episodesWithImage: [Episode] = []
            for try await episode in group {
                episodesWithImage.append(episode)
            }

            return episodesWithImage
        }
    }

    func sorted(episodes: [Episode]) -> [Episode] {
        episodes.sorted(by: { $0.id < $1.id })
    }
}
