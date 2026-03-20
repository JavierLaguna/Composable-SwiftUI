import SwiftUI
import ComposableArchitecture

final class LocationsCoordinator: Coordinator<LocationsCoordinator.Routes, LocationsCoordinator.Sheet> {

    @MainActor private let locationsListStore: StoreOf<LocationsListReducer> = Store(
        initialState: .init(),
        reducer: { LocationsListReducer.build() }
    )
}

// MARK: Routes
extension LocationsCoordinator {

    enum Routes: Hashable {
        case root
    }

    @MainActor
    @ViewBuilder
    func view(for route: Routes) -> some View {
        switch route {
        case .root:
            LocationsListView(store: locationsListStore)
        }
    }
}

// MARK: Sheets
extension LocationsCoordinator {

    enum Sheet: Hashable, View {
        case empty

        var body: some View {
            switch self {
            case .empty:
                EmptyView()
            }
        }
    }
}
