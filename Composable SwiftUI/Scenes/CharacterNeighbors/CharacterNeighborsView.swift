import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterNeighborsView: View {

    let store: StoreOf<CharacterNeighborsReducer>

    var body: some View {
        VStack {
            switch store.locationDetail.state {
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
                            store.send(.getLocationInfo)
                        })
                }
                .padding(.horizontal, Theme.Space.xxl)

            case .populated(let locationDetail):
                NeighborsListView(locationDetail: locationDetail)

            default:
                EmptyView()
            }
        }
        .background {
            R.image.ic_background.image
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            store.send(.getLocationInfo)
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
                CharacterNeighborsReducer.build(locationId: 1)
            }
        ))
    }
}
