import ComposableArchitecture

@Reducer
struct LocationsListReducer {

    let getLocationsInteractor: any GetLocationsInteractor

    @ObservableState
    struct State: Equatable {
        var locations: StateLoadable<[Location]>

        init() {
            locations = .init()
        }
    }

    enum Action {
        case onAppear
        case getLocations
        case getMoreLocations
        case onReceiveLocations(Result<[Location], any Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .getMoreLocations:
                return .send(.getLocations)

            case .getLocations:
                state.locations.state = .loading

                return .run { send in
                    await send(.onReceiveLocations(Result {
                        try await getLocationsInteractor.execute()
                    }))
                }

            case .onReceiveLocations(.success(let newLocations)):
                var locations = state.locations.data
                locations?.append(contentsOf: newLocations)
                state.locations.state = .populated(data: locations ?? newLocations)
                return .none

            case .onReceiveLocations(.failure(let error)):
                state.locations.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension LocationsListReducer {

    static func build() -> LocationsListReducer {
        LocationsListReducer(
            getLocationsInteractor: GetLocationsInteractorFactory.build()
        )
    }
}
