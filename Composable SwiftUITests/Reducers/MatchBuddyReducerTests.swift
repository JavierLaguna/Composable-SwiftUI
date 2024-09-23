// import Testing
// import ComposableArchitecture
// import Resolver
//
// @testable import Composable_SwiftUI
//
// @MainActor
// @Suite("MatchBuddyReducer Tests", .tags(.reducer))
// final class MatchBuddyReducerTests: ResetTestDependencies {
//
//    @Test
//    func getBeerBuddySuccess() async {
//        let interactor = GetBeerBuddyInteractorMock()
//        Resolver.test.register { interactor as GetBeerBuddyInteractor }
//
//        let location = CharacterLocation(id: 1, name: "Earth")
//        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
//
//        let store = TestStore(
//            initialState: MatchBuddyReducer.State(),
//            reducer: {
//                MatchBuddyReducer()
//            }
//        )
//
//        await store.send(.getBeerBuddy(of: character)) {
//            $0.beerBuddy.state = .loading
//        }
//
//        await store.receive(\.onGetBeerBuddy.success) {
//            $0.beerBuddy.state = .populated(data: interactor.expectedResponse!)
//        }
//    }
//
//    @Test
//    func getBeerBuddyNotFoundSuccess() async {
//        let interactor = GetBeerBuddyInteractorMock(success: true, expectedResponse: nil)
//        Resolver.test.register { interactor as GetBeerBuddyInteractor }
//
//        let location = CharacterLocation(id: 1, name: "Earth")
//        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
//
//        let store = TestStore(
//            initialState: MatchBuddyReducer.State(),
//            reducer: {
//                MatchBuddyReducer()
//            }
//        )
//
//        await store.send(.getBeerBuddy(of: character)) {
//            $0.beerBuddy.state = .loading
//        }
//
//        await store.receive(\.onGetBeerBuddy.success) {
//            $0.beerBuddy.state = .empty
//        }
//    }
//
//    @Test
//    func getBeerBuddyFail() async {
//        Resolver.test.register { GetBeerBuddyInteractorMock(success: false) as GetBeerBuddyInteractor }
//
//        let location = CharacterLocation(id: 1, name: "Earth")
//        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
//
//        let store = TestStore(
//            initialState: MatchBuddyReducer.State(),
//            reducer: {
//                MatchBuddyReducer()
//            }
//        )
//
//        await store.send(.getBeerBuddy(of: character)) {
//            $0.beerBuddy.state = .loading
//        }
//
//        await store.receive(\.onGetBeerBuddy.failure) {
//            $0.beerBuddy.state = .error(InteractorError.generic(message: "mock error"))
//        }
//    }
// }
