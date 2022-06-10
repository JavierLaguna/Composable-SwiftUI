enum MatchBuddyAction: Equatable {
    case getBeerBuddy(of: Character)
    case onGetBeerBuddy(Result<BeerBuddy?, InteractorError>)
}
