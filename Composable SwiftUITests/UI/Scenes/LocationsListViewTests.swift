import Testing
import SwiftUI
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "LocationsListView",
    .tags(.UI, .UIScene)
)
final class LocationsListViewTests: SceneSnapshotUITest {

    override var file: StaticString {
        #filePath
    }

    private var store: StoreOf<LocationsListReducer>!

    @Test(
        "Loading State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingState(variant: SceneSnapshotUITest.Variant) {
        loadingStateSetUp()

        execute(
            name: "locationsListView_loadingState",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Loading State With Data",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func loadingStateWithData(variant: SceneSnapshotUITest.Variant) {
        loadingStateWithDataSetUp()

        execute(
            name: "locationsListView_loadingStateWithData",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Populated State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func populatedState(variant: SceneSnapshotUITest.Variant) {
        populatedStateSetUp()

        execute(
            name: "locationsListView_populatedState",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Populated State Unknown Dimension",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func populatedStateUnknownDimension(variant: SceneSnapshotUITest.Variant) {
        populatedStateUnknownDimensionSetUp()

        execute(
            name: "locationsListView_populatedStateUnknownDimension",
            view: view,
            variant: variant
        )
    }

    @Test(
        "Error State",
        arguments: SceneSnapshotUITest.Variant.allVariants
    )
    func errorState(variant: SceneSnapshotUITest.Variant) {
        errorStateSetUp()

        execute(
            name: "locationsListView_errorState",
            view: view,
            variant: variant
        )
    }
}

// MARK: Private methods
private extension LocationsListViewTests {

    var view: some View {
        NavigationStack {
            LocationsListView(store: store)
        }
        .allEnvironmentsInjected
    }

    var locations: [Location] {
        [
            Location(
                id: 1,
                name: "Earth (C-137)",
                type: .planet,
                dimension: "Dimension C-137",
                residents: [1, 2, 3]
            ),
            Location(
                id: 2,
                name: "Abadango",
                type: .cluster,
                dimension: "Abadango Cluster",
                residents: [4, 5]
            )
        ]
    }

    var locationsWithUnknownDimension: [Location] {
        [
            Location(
                id: 3,
                name: "Citadel of Ricks",
                type: .spaceStation,
                dimension: "unknown",
                residents: [8, 9, 10, 11]
            )
        ]
    }

    func loadingStateSetUp() {
        var state = LocationsListReducer.State()
        state.locations.state = .loading
        configureStore(with: state)
    }

    func loadingStateWithDataSetUp() {
        var state = LocationsListReducer.State()
        state.locations.state = .populated(data: locations)
        state.locations.state = .loading
        configureStore(with: state)
    }

    func populatedStateSetUp() {
        var state = LocationsListReducer.State()
        state.locations.state = .populated(data: locations)
        configureStore(with: state)
    }

    func populatedStateUnknownDimensionSetUp() {
        var state = LocationsListReducer.State()
        state.locations.state = .populated(data: locationsWithUnknownDimension)
        configureStore(with: state)
    }

    func errorStateSetUp() {
        let error = InteractorError.generic(message: "")
        var state = LocationsListReducer.State()
        state.locations.state = .error(error)
        configureStore(with: state)
    }

    func configureStore(with state: LocationsListReducer.State) {
        store = StoreOf<LocationsListReducer>(
            initialState: state,
            reducer: {
                // Intentionally empty
            }
        )
    }
}
