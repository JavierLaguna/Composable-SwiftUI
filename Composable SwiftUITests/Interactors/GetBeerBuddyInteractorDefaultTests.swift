import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "GetBeerBuddyInteractorDefault Tests",
    .tags(.interactor)
)
struct GetBeerBuddyInteractorDefaultTests {

    @Test
    func executeSuccess() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: charactersRepository,
            episodesRepository: episodesRepository
        )

        let result = try #require(await interactor.execute(character: rick))

        #expect(result.character == rick)
        #expect(result.buddy == morty)
        #expect(result.firstEpisode == Episode(id: 1, name: "episode1", date: "10-10-2010"))
        #expect(result.lastEpisode == Episode(id: 301, name: "episode301", date: "12-12-2012"))
        #expect(result.count == 5)
    }

    @Test
    func executeBeerBuddyNotFoundMsgError() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [])
        let charactersRepository = CharactersRepositoryMock(success: true)
        let episodesRepository = EpisodesRepositoryMock(success: true)
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: charactersRepository,
            episodesRepository: episodesRepository
        )

        let result = try await interactor.execute(character: rick)

        #expect(result == nil)
    }

    @Test
    func executeLocationRepositoryFail() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: false)
        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: charactersRepository,
            episodesRepository: episodesRepository
        )

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute(character: rick)
        }
    }

    @Test
    func executeCharacterRepositoryFail() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let charactersRepository = CharactersRepositoryMock(success: false)
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: charactersRepository,
            episodesRepository: episodesRepository
        )

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute(character: rick)
        }
    }

    @Test
    func executeEpisodesRepositoryFail() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        let episodesRepository = EpisodesRepositoryMock(success: false)
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: charactersRepository,
            episodesRepository: episodesRepository
        )

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute(character: rick)
        }
    }
}
