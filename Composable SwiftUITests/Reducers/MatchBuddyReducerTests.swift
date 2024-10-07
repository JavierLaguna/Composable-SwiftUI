import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "MatchBuddyReducer",
    .tags(.reducer)
)
struct MatchBuddyReducerTests {

    @Test
    func getBeerBuddySuccess() async {
        let interactor = GetBeerBuddyInteractorMock()
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])

        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: interactor
                )
            }
        )

        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.success) {
            $0.beerBuddy.state = .populated(data: interactor.expectedResponse!)
        }
    }

    @Test
    func getBeerBuddyNotFoundSuccess() async {
        let interactor = GetBeerBuddyInteractorMock(success: true, expectedResponse: nil)
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])

        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: interactor
                )
            }
        )

        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.success) {
            $0.beerBuddy.state = .empty
        }
    }

    @Test
    func getBeerBuddyFail() async {
        let interactor = GetBeerBuddyInteractorMock(success: false)
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])

        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: interactor
                )
            }
        )

        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.failure) {
            $0.beerBuddy.state = .error(InteractorError.generic(message: "mock error"))
        }
    }
}
