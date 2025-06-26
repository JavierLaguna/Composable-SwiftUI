import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "CharacterDetailReducer",
    .tags(.reducer)
)
struct CharacterDetailReducerTests {

    @Test
    func getLocationInfo_whenInteractorFail_returnsInteractorError() async {
        let interactor = GetLocationInfoInteractorMock(success: false)
        let store = await TestStore(
            initialState: .init(),
            reducer: {
                CharacterDetailReducer(
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
