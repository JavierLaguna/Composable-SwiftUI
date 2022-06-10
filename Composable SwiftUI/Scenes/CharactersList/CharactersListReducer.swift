import ComposableArchitecture

let charactersListReducer: Reducer<CharactersListState, CharactersListAction, CharactersListEnvironment> = .init { state, action, environment in
    switch action {
    case .binding:
        return .none
        
    case .binding(\.$searchText):
        return .none
        
    case .getCharacters:
        state.characters.state = .loading
        
        return environment.getCharactersInteractor
            .execute()
            .eraseToEffect()
            .catchToEffect()
            .map(CharactersListAction.onGetCharacters)
        
    case let .onGetCharacters(.success(response)):
        var newData = state.characters.data
        newData?.append(contentsOf: response)
        state.characters.state = .populated(data: newData ?? response)
        return .none
        
    case let .onGetCharacters(.failure(error)):
        state.characters.state = .error(error)
        return .none
        
    }
}
.binding()
