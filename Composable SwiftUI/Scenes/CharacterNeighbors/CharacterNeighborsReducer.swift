import ComposableArchitecture
import Resolver

typealias CharacterNeighborsStore = Store<CharacterNeighborsReducer.State, CharacterNeighborsReducer.Action>

struct CharacterNeighborsReducer: Reducer {
    
    @Injected private var getLocationInfoInteractor: GetLocationInfoInteractor
    
    private let locationId: Int
    
    init(locationId: Int) {
        self.locationId = locationId
    }
    
    struct State: Equatable {
        var locationDetail: StateLoadable<LocationDetail> = .init()
    }
    
    enum Action: Equatable {
        case getLocationInfo
        case onGetLocationInfo(TaskResult<LocationDetail>)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .getLocationInfo:
            state.locationDetail.state = .loading
            
            return .run { send in
                await send(.onGetLocationInfo(TaskResult {
                    try await getLocationInfoInteractor.execute(locationId: locationId)
                }))
            }
            
        case .onGetLocationInfo(.success(let locationDetail)):
            state.locationDetail.state = .populated(data: locationDetail)
            return .none
            
        case .onGetLocationInfo(.failure(let error)):
            state.locationDetail.state = .error(error)
            return .none
        }
    }
}
