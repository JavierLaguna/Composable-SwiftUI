import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "CharacterNeighborsReducer",
    .tags(.reducer)
)
struct CharacterNeighborsReducerTests {

    @Test
    func getLocationInfo_whenInteractorSuccess_returnsLocationInfoData() async {
        let mockInteractor = MockGetLocationInfoInteractor()
        let mockResponse = LocationDetail.mock
        let store = await TestStore(
            initialState: .init(),
            reducer: {
                CharacterNeighborsReducer(
                    getLocationInfoInteractor: mockInteractor,
                    locationId: 1
                )
            }
        )

        given(mockInteractor)
            .execute(locationId: .any)
            .willReturn(mockResponse)

        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }

        await store.receive(\.onGetLocationInfo.success) {
            $0.locationDetail.state = .populated(data: mockResponse)
        }

        verify(mockInteractor)
            .execute(locationId: .value(1))
            .called(.once)
    }

    @Test
    func getLocationInfo_whenInteractorFail_returnsInteractorError() async {
        let mockInteractor = MockGetLocationInfoInteractor()
        let mockError: InteractorError = .generic(message: "mock error")
        let store = await TestStore(
            initialState: .init(),
            reducer: {
                CharacterNeighborsReducer(
                    getLocationInfoInteractor: mockInteractor,
                    locationId: 1
                )
            }
        )

        given(mockInteractor)
            .execute(locationId: .any)
            .willThrow(mockError)

        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }

        await store.receive(\.onGetLocationInfo.failure) {
            $0.locationDetail.state = .error(mockError)
        }

        verify(mockInteractor)
            .execute(locationId: .value(1))
            .called(.once)
    }
}
