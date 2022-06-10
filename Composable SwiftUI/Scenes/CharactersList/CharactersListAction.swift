import ComposableArchitecture

enum CharactersListAction: BindableAction, Equatable {
    case binding(BindingAction<CharactersListState>)
    case getCharacters
    case onGetCharacters(Result<[Character], InteractorError>)
}
