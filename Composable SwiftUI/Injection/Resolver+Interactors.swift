import Resolver

extension Resolver {

    static func registerInteractors() {
        register { GetLocationInfoInteractorDefault() }.implements(GetLocationInfoInteractor.self)
    }
}
