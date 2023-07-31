import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterNeighborsView: View {
    
    private let store: Store<CharacterNeighborsReducer.State, CharacterNeighborsReducer.Action>
    
    init(store: Store<CharacterNeighborsReducer.State, CharacterNeighborsReducer.Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                switch(viewStore.locationDetail.state) {
                case .loading:
                    Text("LOADING")
                    
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


struct CharacterNeighborsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            CharacterNeighborsView(store: Store(
                initialState: .init(),
                reducer: CharacterNeighborsReducer(locationId: 1)
            ))
        }
    }
}
