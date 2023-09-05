import Resolver

extension Resolver {

    static func registerInteractors() {
        register { GetCharactersInteractorDefault() }.implements(GetCharactersInteractor.self)
        register { GetBeerBuddyInteractorDefault() }.implements(GetBeerBuddyInteractor.self)
        register { GetLocationInfoInteractorDefault() }.implements(GetLocationInfoInteractor.self)
    }
}
