import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@MainActor
final class CharacterNeighborsReducerTests: ReducerTestCase {
    
    func test_getLocationInfo_whenInteractorSuccess_returnsLocationInfoData() async {
        let interactor = GetLocationInfoInteractorMock()
        Resolver.test.register { interactor as GetLocationInfoInteractor }
        
        let store = TestStore(
            initialState: CharacterNeighborsReducer.State()
        ) {
            CharacterNeighborsReducer(locationId: 1)
        }
        
        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }
        
        await store.receive(.onGetLocationInfo(.success(interactor.expectedResponse))) {
            $0.locationDetail.state = .populated(data: interactor.expectedResponse)
        }
    }
    
    func test_getLocationInfo_whenInteractorFail_returnsInteractorError() async {
        let interactor = GetLocationInfoInteractorMock(success: false)
        Resolver.test.register { interactor as GetLocationInfoInteractor }
        
        let store = TestStore(
            initialState: CharacterNeighborsReducer.State()
        ) {
            CharacterNeighborsReducer(locationId: 1)
        }
        
        await store.send(.getLocationInfo) {
            $0.locationDetail.state = .loading
        }
        
        await store.receive(.onGetLocationInfo(.failure(interactor.expectedError))) {
            $0.locationDetail.state = .error(interactor.expectedError)
        }
    }
}

