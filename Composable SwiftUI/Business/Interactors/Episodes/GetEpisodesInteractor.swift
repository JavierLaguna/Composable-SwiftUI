import Foundation

protocol GetEpisodesInteractor: Sendable {
    func execute(id: Int) async throws -> Episode
    func execute(ids: [Int]) async throws -> [Episode]
    func execute() async throws -> [Episode]
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
                            code: episode.code,
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

    func execute() async throws -> [Episode] {
        do {
            let episodes = try await episodesRepository.getEpisodes()

            return try await withThrowingTaskGroup(of: Episode.self) { group in
                for episode in episodes {
                    group.addTask {
                        let image = try await getEpisodeImageInteractor.execute(episode: episode)
                        return Episode(
                            id: episode.id,
                            name: episode.name,
                            airDate: episode.airDate,
                            code: episode.code,
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
