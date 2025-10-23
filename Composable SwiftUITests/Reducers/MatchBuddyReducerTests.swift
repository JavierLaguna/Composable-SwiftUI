import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "MatchBuddyReducer",
    .tags(.reducer)
)
struct MatchBuddyReducerTests {

    @Test
    func getBeerBuddySuccess() async {
        let mockInteractor = MockGetBeerBuddyInteractor()
        let mockResponse = BeerBuddy.mock

        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute(character: .any)
            .willReturn(mockResponse)

        await store.send(.getBeerBuddy(of: Character.mock)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.success) {
            $0.beerBuddy.state = .populated(data: mockResponse)
        }

        verify(mockInteractor)
            .execute(character: .value(Character.mock))
            .called(.once)
    }

    @Test
    func getBeerBuddyNotFoundSuccess() async {
        let mockInteractor = MockGetBeerBuddyInteractor()

        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute(character: .any)
            .willReturn(nil)

        await store.send(.getBeerBuddy(of: Character.mock)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.success) {
            $0.beerBuddy.state = .empty
        }

        verify(mockInteractor)
            .execute(character: .value(Character.mock))
            .called(.once)
    }

    @Test
    func getBeerBuddyFail() async {
        let mockInteractor = MockGetBeerBuddyInteractor()
        let mockError = InteractorError.generic(message: "mock error")
        let store = await TestStore(
            initialState: .init(),
            reducer: {
                MatchBuddyReducer(
                    getBeerBuddyInteractor: mockInteractor
                )
            }
        )

        given(mockInteractor)
            .execute(character: .any)
            .willThrow(mockError)

        await store.send(.getBeerBuddy(of: Character.mock)) {
            $0.beerBuddy.state = .loading
        }

        await store.receive(\.onGetBeerBuddy.failure) {
            $0.beerBuddy.state = .error(mockError)
        }

        verify(mockInteractor)
            .execute(character: .value(Character.mock))
            .called(.once)
    }
}
