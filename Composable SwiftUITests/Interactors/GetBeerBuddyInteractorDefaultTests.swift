import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

// TODO: JLI why?
@Suite(
    "GetBeerBuddyInteractorDefault Tests",
    .serialized
)
final class GetBeerBuddyInteractorDefaultTests: ResetTestDependencies {

    @Test
    func executeSuccess() async {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        Resolver.test.register { locationRepository as LocationRepository }

        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        Resolver.test.register { charactersRepository as CharactersRepository }

        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }

        let interactor = GetBeerBuddyInteractorDefault()

        do {
            let result = try await interactor.execute(character: rick)

            #expect(result?.character == rick)
            #expect(result?.buddy == morty)
            #expect(result?.firstEpisode == Episode(id: 1, name: "episode1", date: "10-10-2010"))
            #expect(result?.lastEpisode == Episode(id: 301, name: "episode301", date: "12-12-2012"))
            #expect(result?.count == 5)

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func executeBeerBuddyNotFoundMsgError() async {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [])
        Resolver.test.register { locationRepository as LocationRepository }

        let charactersRepository = CharactersRepositoryMock(success: true)
        Resolver.test.register { charactersRepository as CharactersRepository }

        let episodesRepository = EpisodesRepositoryMock(success: true)
        Resolver.test.register { episodesRepository as EpisodesRepository }

        let interactor = GetBeerBuddyInteractorDefault()

        do {
            let result = try await interactor.execute(character: rick)

            #expect(result == nil)

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func executeLocationRepositoryFail() async {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: false)
        Resolver.test.register { locationRepository as LocationRepository }

        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        Resolver.test.register { charactersRepository as CharactersRepository }

        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }

        let interactor = GetBeerBuddyInteractorDefault()

        do {
            _ = try await interactor.execute(character: rick)

            Issue.record("Test Fail")

        } catch {
            #expect(error as? InteractorError == .repositoryFail(error: .invalidUrl))
        }
    }

    @Test
    func executeCharacterRepositoryFail() async {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        Resolver.test.register { locationRepository as LocationRepository }

        let charactersRepository = CharactersRepositoryMock(success: false)
        Resolver.test.register { charactersRepository as CharactersRepository }

        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012")
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }

        let interactor = GetBeerBuddyInteractorDefault()

        do {
            _ = try await interactor.execute(character: rick)

            Issue.record("Test Fail")

        } catch {
            #expect(error as? InteractorError == .repositoryFail(error: .invalidUrl))
        }
    }

    @Test
    func executeEpisodesRepositoryFail() async {
        let location = CharacterLocation(id: 1, name: "Earth")

        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])

        let morty = Character(id: 2, name: "Morty Smith", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let beth = Character(id: 4, name: "Beth Smith", status: .alive, species: "Human", type: "", gender: .female, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", episodes: [1, 2, 15])

        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        Resolver.test.register { locationRepository as LocationRepository }

        let charactersRepository = CharactersRepositoryMock(success: true, expectedResponse: [morty, beth])
        Resolver.test.register { charactersRepository as CharactersRepository }

        let episodesRepository = EpisodesRepositoryMock(success: false)
        Resolver.test.register { episodesRepository as EpisodesRepository }

        let interactor = GetBeerBuddyInteractorDefault()

        do {
            _ = try await interactor.execute(character: rick)

            Issue.record("Test Fail")

        } catch {
            #expect(error as? InteractorError == .repositoryFail(error: .invalidUrl))
        }
    }
}
