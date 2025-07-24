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
        let mockDate = Date.now
        let rick = Character.rick.copy(episodes: [1, 2, 15, 22, 33, 200, 301])
        let morty = Character.morty.copy(episodes: [1, 2, 15, 44, 35, 200, 301, 304])
        let beth = Character.beth.copy(episodes: [1, 2, 15])

        let mockLocationRepository = MockLocationRepository()
        let mockCharactersRepository = MockCharactersRepository()
        let mockEpisodeRepository = MockEpisodesRepository()
        let mockEpisodesResponse = [
            Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil),
            Episode(id: 2, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil)
        ]
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: mockLocationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: mockEpisodeRepository
        )

        given(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .willReturn([1, 2, 3, 4])

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willReturn([morty, beth])

        given(mockEpisodeRepository)
            .getEpisodesFromList(ids: .any)
            .willReturn(mockEpisodesResponse)

        let result = try #require(await interactor.execute(character: rick))

        #expect(result.character == rick)
        #expect(result.buddy == morty)
        #expect(result.firstEpisode == Episode(id: 1, name: "episode1", airDate: mockDate, code: "code-1", characters: [1, 2], created: mockDate, image: nil))
        #expect(result.lastEpisode == Episode(id: 2, name: "episode2", airDate: mockDate, code: "code-1", characters: [2, 3, 4], created: mockDate, image: nil))
        #expect(result.count == 5)

        verify(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .value(1))
            .called(.once)

        verify(mockLocationRepository)
            .getLocation(locationId: .any)
            .called(.never)

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

        verify(mockEpisodeRepository)
            .getEpisodesFromList(ids: .value([1, 301]))
            .called(.once)

        verify(mockEpisodeRepository)
            .getEpisodes()
            .called(.never)
    }

    @Test
    func executeBeerBuddyNotFoundMsgError() async throws {
        let mockLocationRepository = MockLocationRepository()
        let mockCharactersRepository = MockCharactersRepository()
        let mockEpisodeRepository = MockEpisodesRepository()
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: mockLocationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: mockEpisodeRepository
        )

        given(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .willReturn([])

        let result = try await interactor.execute(character: Character.mock)

        #expect(result == nil)

        verify(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .value(1))
            .called(.once)

        verify(mockLocationRepository)
            .getLocation(locationId: .any)
            .called(.never)

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

        verify(mockEpisodeRepository)
            .getEpisodesFromList(ids: .any)
            .called(.never)

        verify(mockEpisodeRepository)
            .getEpisodes()
            .called(.never)
    }

    @Test
    func executeLocationRepositoryFail() async throws {
        let mockLocationRepository = MockLocationRepository()
        let mockError = InteractorError.repositoryFail(error: .invalidUrl)
        let mockCharactersRepository = MockCharactersRepository()
        let mockEpisodeRepository = MockEpisodesRepository()
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: mockLocationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: mockEpisodeRepository
        )

        given(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await interactor.execute(character: Character.mock)
        }

        verify(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .value(1))
            .called(.once)

        verify(mockLocationRepository)
            .getLocation(locationId: .any)
            .called(.never)

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

        verify(mockEpisodeRepository)
            .getEpisodesFromList(ids: .any)
            .called(.never)

        verify(mockEpisodeRepository)
            .getEpisodes()
            .called(.never)
    }

    @Test
    func executeCharacterRepositoryFail() async throws {
        let mockLocationRepository = MockLocationRepository()
        let mockCharactersRepository = MockCharactersRepository()
        let mockError = InteractorError.repositoryFail(error: .invalidUrl)
        let mockEpisodeRepository = MockEpisodesRepository()
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: mockLocationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: mockEpisodeRepository
        )

        given(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .willReturn([1, 2, 3, 4])

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await interactor.execute(character: Character.mock)
        }

        verify(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .value(1))
            .called(.once)

        verify(mockLocationRepository)
            .getLocation(locationId: .any)
            .called(.never)

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

        verify(mockEpisodeRepository)
            .getEpisodesFromList(ids: .any)
            .called(.never)

        verify(mockEpisodeRepository)
            .getEpisodes()
            .called(.never)
    }

    @Test
    func executeEpisodesRepositoryFail() async throws {
        let mockDate = Date.now
        let rick = Character.rick.copy(episodes: [1, 2, 15, 22, 33, 200, 301])
        let morty = Character.morty.copy(episodes: [1, 2, 15, 44, 35, 200, 301, 304])
        let beth = Character.beth.copy(episodes: [1, 2, 15])

        let mockLocationRepository = MockLocationRepository()
        let mockCharactersRepository = MockCharactersRepository()
        let mockEpisodeRepository = MockEpisodesRepository()
        let mockError = InteractorError.repositoryFail(error: .invalidUrl)
        let interactor = GetBeerBuddyInteractorDefault(
            locationRepository: mockLocationRepository,
            charactersRepository: mockCharactersRepository,
            episodesRepository: mockEpisodeRepository
        )

        given(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .willReturn([1, 2, 3, 4])

        given(mockCharactersRepository)
            .getCharacters(characterIds: .any)
            .willReturn([morty, beth])

        given(mockEpisodeRepository)
            .getEpisodesFromList(ids: .any)
            .willThrow(mockError)

        try await #require(throws: mockError) {
            try await interactor.execute(character: rick)
        }

        verify(mockLocationRepository)
            .getCharacterIdsFromLocation(locationId: .value(1))
            .called(.once)

        verify(mockLocationRepository)
            .getLocation(locationId: .any)
            .called(.never)

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

        verify(mockEpisodeRepository)
            .getEpisodesFromList(ids: .value([1, 301]))
            .called(.once)

        verify(mockEpisodeRepository)
            .getEpisodes()
            .called(.never)
    }
}
