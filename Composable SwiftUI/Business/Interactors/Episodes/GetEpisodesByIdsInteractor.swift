import Foundation

protocol GetEpisodesByIdsInteractor: Sendable {
    func execute(id: Int) async throws -> Episode
    func execute(ids: [Int]) async throws -> [Episode]
}

struct GetEpisodesByIdsInteractorFactory {

    static func build() -> any GetEpisodesByIdsInteractor {
        GetEpisodesByIdsInteractorDefault(
            episodesRepository: EpisodesRepositoryFactory.build(),
            getEpisodeImageInteractor: GetEpisodeImageInteractorFactory.build()
        )
    }
}

struct GetEpisodesByIdsInteractorDefault: GetEpisodesByIdsInteractor, ManagedErrorInteractor {

    let episodesRepository: any EpisodesRepository
    let getEpisodeImageInteractor: any GetEpisodeImageInteractor

    func execute(id: Int) async throws -> Episode {
        guard let episode = try await execute(ids: [id]).first else {
            throw InteractorError.generic(message: "Empty response")
        }

        return episode
    }

    func execute(ids: [Int]) async throws -> [Episode] {
        do {
            let episodes = try await episodesRepository.getEpisodesFromList(ids: ids)

            return try await withThrowingTaskGroup(of: Episode.self) { group in
                for episode in episodes {
                    group.addTask {
                        let image = try await getEpisodeImageInteractor.execute(episode: episode)
                        return Episode(
                            id: episode.id,
                            name: episode.name,
                            airDate: episode.airDate,
                            episode: episode.episode,
                            characters: episode.characters,
                            created: episode.created,
                            image: image
                        )
                    }
                }

                var episodesWithImage: [Episode] = []
                for try await episode in group {
                    episodesWithImage.append(episode)
                }

                return episodesWithImage
            }

        } catch {
            throw manageError(error: error)
        }
    }
}
