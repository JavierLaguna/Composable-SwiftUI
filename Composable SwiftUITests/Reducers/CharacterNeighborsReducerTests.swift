import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@MainActor
@Suite("CharacterNeighborsReducer Tests")
final class CharacterNeighborsReducerTests: ResetTestDependencies {

    @Test
    func getLocationInfo_whenInteractorSuccess_returnsLocationInfoData() async {
        let interactor = GetLocationInfoInteractorMock()
        Resolver.test.register { interactor as GetLocationInfoInteractor }

        let store = TestStore(
            initialState: CharacterNeighborsReducer.State(),
            reducer: {
                CharacterNeighborsReducer(locationId: 1)
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
        Resolver.test.register { interactor as GetLocationInfoInteractor }

        let store = TestStore(
            initialState: CharacterNeighborsReducer.State(),
            reducer: {
                CharacterNeighborsReducer(locationId: 1)
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
