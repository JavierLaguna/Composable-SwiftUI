import SwiftUI
import ComposableArchitecture

struct CharactersListView: View {

    @Bindable private var store: StoreOf<CharactersListReducer>

    init(store: StoreOf<CharactersListReducer>) {
        self.store = store
    }

    var body: some View {
        VStack {
            if store.characters.error == nil {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField(
                            R.string.localizable.charactersListSearch(),
                            text: $store.searchText
                        )
                    }
                    .foregroundColor(Theme.Colors.primary)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.Colors.primary, lineWidth: 2)
                    )
                    .padding()
                }
                .background(Theme.Colors.backgroundSecondary)
            }

            if let characters = store.filteredCharacters {

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
                        showLoadingMoreCharacters: store.characters.isLoading,
                        onEndReached: {
                            store.send(.getCharacters)
                        }
                    )
                }
            }

            switch store.characters.state {
            case .loading:
                if store.characters.data == nil {
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
                            store.send(.getCharacters)
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
            store.send(.getCharacters)
        }
    }
}

private struct CharactersList: View {

    @Environment(CharactersCoordinator.self)
    private var charactersCoordinator

    let characters: [Character]
    let showLoadingMoreCharacters: Bool
    let onEndReached: () -> Void

    var body: some View {
        List {
            ForEach(characters) { character in
                Button {
                    charactersCoordinator.navigateToCharacterDetail(character: character)
                } label: {
                    CharacterCellView(character: character)
                        .onAppear {
                            if characters.last == character {
                                onEndReached()
                            }
                        }
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

#Preview {
    let store: StoreOf<CharactersListReducer> = Store(
        initialState: .init(),
        reducer: {
            CharactersListReducer.build()
        }
    )

    NavigationStack {
        CharactersListView(store: store)
    }
    .allEnvironmentsInjected
}
