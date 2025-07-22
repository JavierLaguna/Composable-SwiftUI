import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "GetBeerBuddyInteractorDefault",
    .tags(.interactor)
)
struct GetBeerBuddyInteractorDefaultTests {

    @Test
    func executeSuccess() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")
        let mockDate = Date.now

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301],
                             created: mockDate,
                             description: nil)

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304],
                              created: mockDate,
                              description: nil)

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15],
                             created: mockDate,
                             description: nil)

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let mockCharactersRepository = MockCharactersRepository()
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil),
            Episode(id: 2, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil)
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: episodesRepository
        )

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willReturn([morty, beth])

        let result = try #require(await interactor.execute(character: rick))

        #expect(result.character == rick)
        #expect(result.buddy == morty)
        #expect(result.firstEpisode == Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil))
        #expect(result.lastEpisode == Episode(id: 2, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil))
        #expect(result.count == 5)

        verify(mockCharactersRepository)
            .getCharacters(characterIds: .value([2, 3, 4]))
            .called(.once)

        verify(mockCharactersRepository)
            .getCharacters()
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getTotalCharactersCount()
            .called(.never)
    }

    @Test
    func executeBeerBuddyNotFoundMsgError() async throws {
        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [])
        let mockCharactersRepository = MockCharactersRepository()
        let episodesRepository = EpisodesRepositoryMock(success: true)
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: episodesRepository
        )

        let result = try await interactor.execute(character: Character.mock)

        #expect(result == nil)

        verify(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacters()
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getTotalCharactersCount()
            .called(.never)
    }

    @Test
    func executeLocationRepositoryFail() async throws {
        let mockDate = Date.now
        let locationRepository = LocationRepositoryMock(success: false)
        let mockCharactersRepository = MockCharactersRepository()
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil),
            Episode(id: 301, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil)
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: episodesRepository
        )

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute(character: Character.mock)
        }

        verify(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacters()
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getTotalCharactersCount()
            .called(.never)
    }

    @Test
    func executeCharacterRepositoryFail() async throws {
        let mockDate = Date.now
        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let mockCharactersRepository = MockCharactersRepository()
        let mockError = InteractorError.repositoryFail(error: .invalidUrl)
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil),
            Episode(id: 2, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil)
        ])
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: episodesRepository
        )

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await interactor.execute(character: Character.mock)
        }

        verify(mockCharactersRepository)
            .getCharacters(characterIds: .value([2, 3, 4]))
            .called(.once)

        verify(mockCharactersRepository)
            .getCharacters()
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getTotalCharactersCount()
            .called(.never)
    }

    @Test
    func executeEpisodesRepositoryFail() async throws {
        let location = CharacterLocation(id: 1, name: "Earth")
        let mockDate = Date.now

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301],
                             created: mockDate,
                             description: nil)

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304],
                              created: mockDate,
                              description: nil)

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15],
                             created: mockDate,
                             description: nil)

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        let mockCharactersRepository = MockCharactersRepository()
        let episodesRepository = EpisodesRepositoryMock(success: false)
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: locationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: episodesRepository
        )

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willReturn([morty, beth])

        try await #require(throws: InteractorError.repositoryFail(error: .invalidUrl)) {
            try await interactor.execute(character: rick)
        }

        verify(mockCharactersRepository)
            .getCharacters(characterIds: .value([2, 3, 4]))
            .called(.once)

        verify(mockCharactersRepository)
            .getCharacters()
            .called(.never)

        verify(mockCharactersRepository)
            .getCharacter(characterId: .any)
            .called(.never)

        verify(mockCharactersRepository)
            .getTotalCharactersCount()
            .called(.never)
    }
}
