import ComposableArchitecture
import Resolver

@Reducer
struct CharacterNeighborsReducer {

    @Injected private var getLocationInfoInteractor: GetLocationInfoInteractor

    private let locationId: Int

    init(locationId: Int) {
        self.locationId = locationId
    }

    @ObservableState
    struct State: Equatable {
        var locationDetail: StateLoadable<LocationDetail> = .init()
    }

    enum Action {
        case getLocationInfo
        case onGetLocationInfo(TaskResult<LocationDetail>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
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
}
