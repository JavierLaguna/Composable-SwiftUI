import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterNeighborsView: View {

    private let store: CharacterNeighborsStore

    init(store: CharacterNeighborsStore) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                switch viewStore.locationDetail.state {
                case .loading:
                    VStack {
                        LoadingView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error(let error):
                    VStack {
                        ErrorView(
                            error: error,
                            onRetry: {
                                viewStore.send(.getLocationInfo)
                            })
                    }
                    .padding(.horizontal, Theme.Space.xxl)

                case .populated(let locationDetail):
                    NeighborsListView(locationDetail: locationDetail)

                default:
                    Color.clear
                }

            }
            .background {
                R.image.ic_background.image
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .task {
                viewStore.send(.getLocationInfo)
            }
        }
    }
}

#Preview {
    NavigationView {
        CharacterNeighborsView(store: Store(
            initialState: .init(
                locationDetail: .init(state: .loading)
            ),
            reducer: {
                CharacterNeighborsReducer(locationId: 1)
            }
        ))
    }
}
