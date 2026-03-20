import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "LocationsListReducer",
    .tags(.reducer)
)
struct LocationsListReducerTests {

    @Test
    func onAppearSuccess() async {
        let mockInteractor = MockGetLocationsInteractor()
        let mockResponse = [Location.mock]
        let store = await TestStore(
            initialState: LocationsListReducer.State(),
            reducer: {
                LocationsListReducer(getLocationsInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(mockResponse)

        await store.send(.onAppear)

        await store.receive(\.getLocations) {
            $0.locations.state = .loading
        }

        await store.receive(\.onReceiveLocations.success) {
            $0.locations.state = .populated(data: mockResponse)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)
    }

    @Test
    func getMoreLocationsSuccessAndAppend() async {
        let mockInteractor = MockGetLocationsInteractor()
        let initialLocations = [
            Location(
                id: 1,
                name: "Earth (C-137)",
                type: .planet,
                dimension: "Dimension C-137",
                residents: [1, 2]
            )
        ]
        let newLocations = [
            Location(
                id: 2,
                name: "Abadango",
                type: .cluster,
                dimension: "unknown",
                residents: [6, 7, 8]
            )
        ]
        var initialState = LocationsListReducer.State()
        initialState.locations.state = .populated(data: initialLocations)

        let store = await TestStore(
            initialState: initialState,
            reducer: {
                LocationsListReducer(getLocationsInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(newLocations)

        await store.send(.getMoreLocations)

        await store.receive(\.getLocations) {
            $0.locations.state = .loading
        }

        await store.receive(\.onReceiveLocations.success) {
            $0.locations.state = .populated(data: initialLocations + newLocations)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)
    }

    @Test
    func onAppearFail() async {
        let mockInteractor = MockGetLocationsInteractor()
        let mockError = InteractorError.generic(message: "mock error")
        let store = await TestStore(
            initialState: LocationsListReducer.State(),
            reducer: {
                LocationsListReducer(getLocationsInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willThrow(mockError)

        await store.send(.onAppear)

        await store.receive(\.getLocations) {
            $0.locations.state = .loading
        }

        await store.receive(\.onReceiveLocations.failure) {
            $0.locations.state = .error(mockError)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)
    }
}
