import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class GetBeerBuddyInteractorDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testExecuteSuccess() async {
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
            Episode(id: 301, name: "episode301", date: "12-12-2012"),
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }
        
        let interactor = GetBeerBuddyInteractorDefault()
        
        do {
            let result = try await interactor.execute(character: rick)
            
            XCTAssertEqual(result?.character, rick)
            XCTAssertEqual(result?.buddy, morty)
            XCTAssertEqual(result?.firstEpisode, Episode(id: 1, name: "episode1", date: "10-10-2010"))
            XCTAssertEqual(result?.lastEpisode, Episode(id: 301, name: "episode301", date: "12-12-2012"))
            XCTAssertEqual(result?.count, 5)
            
        } catch {
            XCTFail("Test Fail")
        }
    }
    
    func testExecuteBeerBuddyNotFoundMsgError() async {
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
            
            XCTAssertNil(result)
            
        } catch {
            XCTFail("Test Fail")
        }
    }
    
    func testExecuteLocationRepositoryFail() async {
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
            Episode(id: 301, name: "episode301", date: "12-12-2012"),
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }
        
        let interactor = GetBeerBuddyInteractorDefault()
        
        do {
            _ = try await interactor.execute(character: rick)
            
            XCTFail("Test Fail")
            
        } catch {
            XCTAssertEqual(error as? InteractorError, .repositoryFail(error: .invalidUrl))
        }
    }
    
    func testExecuteCharacterRepositoryFail() async {
        let location = CharacterLocation(id: 1, name: "Earth")
        
        let rick = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [1, 2, 15, 22, 33, 200, 301])
        
        let locationRepository = LocationRepositoryMock(success: true, expectedResponse: [1, 2, 3, 4])
        Resolver.test.register { locationRepository as LocationRepository }
        
        let charactersRepository = CharactersRepositoryMock(success: false)
        Resolver.test.register { charactersRepository as CharactersRepository }
        
        let episodesRepository = EpisodesRepositoryMock(success: true, expectedResponse: [
            Episode(id: 1, name: "episode1", date: "10-10-2010"),
            Episode(id: 301, name: "episode301", date: "12-12-2012"),
        ])
        Resolver.test.register { episodesRepository as EpisodesRepository }
        
        let interactor = GetBeerBuddyInteractorDefault()
        
        do {
            _ = try await interactor.execute(character: rick)
            
            XCTFail("Test Fail")
            
        } catch {
            XCTAssertEqual(error as? InteractorError, .repositoryFail(error: .invalidUrl))
        }
    }
    
    func testExecuteEpisodesRepositoryFail() async {
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
            
            XCTFail("Test Fail")
            
        } catch {
            XCTAssertEqual(error as? InteractorError, .repositoryFail(error: .invalidUrl))
        }
    }
}
