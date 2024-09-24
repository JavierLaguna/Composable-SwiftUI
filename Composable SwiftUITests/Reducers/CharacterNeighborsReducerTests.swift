import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@MainActor
@Suite("CharacterNeighborsReducer Tests", .tags(.reducer))
struct CharacterNeighborsReducerTests {

    @Test
    func getLocationInfo_whenInteractorSuccess_returnsLocationInfoData() async {
        let interactor = GetLocationInfoInteractorMock()
        let store = TestStore(
            initialState: .init(),
            reducer: {
                CharacterNeighborsReducer(
                    getLocationInfoInteractor: interactor,
                    locationId: 1
                )
            }
        )

        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }

        await store.receive(\.onGetLocationInfo.success) {
            $0.locationDetail.state = .populated(data: interactor.expectedResponse)
        }
    }

    @Test
    func getLocationInfo_whenInteractorFail_returnsInteractorError() async {
        let interactor = GetLocationInfoInteractorMock(success: false)
        let store = TestStore(
            initialState: .init(),
            reducer: {
                CharacterNeighborsReducer(
                    getLocationInfoInteractor: interactor,
                    locationId: 1
                )
            }
        )

        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }

        await store.receive(\.onGetLocationInfo.failure) {
            $0.locationDetail.state = .error(interactor.expectedError)
        }
    }
}
