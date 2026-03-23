import SwiftUI
import ComposableArchitecture

struct CharactersListView: View {

    @Bindable private var store: StoreOf<CharactersListReducer>

    init(store: StoreOf<CharactersListReducer>) {
        self.store = store
    }

    var body: some View {
        VStack {
            if let error = store.characters.error {
                VStack {
                    ErrorView(
                        error: error,
                        onRetry: {
                            store.send(.getCharacters)
                        })
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
                .padding(.vertical, Theme.Space.xl)
                .padding(.horizontal, Theme.Space.xxl)

            } else if let characters = store.filteredCharacters {
                Group {
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
                        .contentMargins(.bottom, Theme.Space.tabBarHeight)
                    }
                }
                .searchable(
                    text: $store.searchText,
                    prompt: R.string.localizable.charactersListSearch()
                )

            } else if store.characters.isLoading {
                List {
                    SkeletonRows(numberOfRows: BusinessConstants.skeletonRowEmptyData)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(R.string.localizable.charactersListTitle())
        .backgroundImage(R.image.ic_background.image)
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
