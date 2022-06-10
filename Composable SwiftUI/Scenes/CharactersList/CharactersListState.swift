import ComposableArchitecture

struct CharactersListState: Equatable {
    @BindableState var searchText = ""
    var characters: StateLoadable<[Character]> = StateLoadable()
}

// MARK: Computed properties
extension CharactersListState {
    
    var filteredCharacters: [Character]? {
        guard let characters = characters.data else {
            return nil
        }
        
        guard !searchText.isEmpty else {
            return characters
        }
        
        return characters.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
}
