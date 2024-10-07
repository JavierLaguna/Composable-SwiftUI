import ComposableArchitecture

@Reducer
struct CharacterNeighborsReducer {

    let getLocationInfoInteractor: any GetLocationInfoInteractor
    let locationId: Int

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

// MARK: Builder
extension CharacterNeighborsReducer {

    static func build(locationId: Int) -> CharacterNeighborsReducer {
        CharacterNeighborsReducer(
            getLocationInfoInteractor: GetLocationInfoInteractorFactory.build(),
            locationId: locationId
        )
    }
}
