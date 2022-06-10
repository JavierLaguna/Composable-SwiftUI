import SwiftUI
import ComposableArchitecture
import Resolver

struct CharactersListView: View {
    
    @Injected(name: "scoped") var store: Store<CharactersListState, CharactersListAction>
    
    @EnvironmentObject private var charactersListRouter: CharactersListCoordinator.Router
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                
                if viewStore.characters.error == nil {
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.Colors.primary)
                            
                            TextField(R.string.localizable.charactersListSearch(), text: viewStore.binding(\.$searchText))
                                .foregroundColor(Theme.Colors.primary)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.Colors.primary, lineWidth: 2)
                        )
                        .padding()
                    }
                    .background(Theme.Colors.background)
                }
                
                if let characters = viewStore.filteredCharacters {
                    
                    if characters.isEmpty {
                        VStack {
                            Text(R.string.localizable.charactersListNoResults())
                                .foregroundColor(Theme.Colors.secondaryText)
                                .font(Theme.Fonts.title2)
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .top
                        )
                        .padding(.top, Theme.Space.xl)
                        
                    } else {
                        
                        CharactersList(
                            characters: characters,
                            showLoadingMoreCharacters: viewStore.characters.isLoading,
                            onEndReached: {
                                viewStore.send(.getCharacters)
                            },
                            onTapCharacter: {
                                charactersListRouter.route(to: \.character, $0)
                            }
                        )
                    }
                }
                
                switch viewStore.characters.state {
                case .loading:
                    if viewStore.characters.data == nil {
                        List {
                            SkeletonRows(numberOfRows: BusinessConstants.skeletonRowEmptyData)
                        }
                        .listStyle(.plain)
                    }
                    
                case .error(let error):
                    VStack {
                        ErrorView(
                            error: error,
                            onRetry: {
                                viewStore.send(.getCharacters)
                            })
                    }
                    .padding(.horizontal, Theme.Space.xxl)
                    
                default:
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .background {
                R.image.ic_background.image
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .task {
                viewStore.send(.getCharacters)
            }
        }
    }
}

private struct CharactersList: View {
    let characters: [Character]
    let showLoadingMoreCharacters: Bool
    let onEndReached: () -> Void
    let onTapCharacter: (Character) -> Void
    
    var body: some View {
        List {
            ForEach(characters) { character in
                
                CharacterCellView(character: character)
                    .onAppear {
                        if characters.last == character {
                            onEndReached()
                        }
                    }
                    .onTapGesture {
                        onTapCharacter(character)
                    }
                
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(vertical: Theme.Space.xxl, horizontal: Theme.Space.xl))
            
            if showLoadingMoreCharacters {
                SkeletonRows(numberOfRows: BusinessConstants.skeletonRowWithData)
            }
        }
        .listStyle(.plain)
    }
}

private struct SkeletonRows: View {
    let numberOfRows: Int
    
    var body: some View {
        ForEach((1...numberOfRows), id: \.self) { _ in
            CharacterCellView(character: nil)
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(vertical: Theme.Space.xxl, horizontal: Theme.Space.xl))
    }
}

struct CharactersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharactersListView()
    }
}
