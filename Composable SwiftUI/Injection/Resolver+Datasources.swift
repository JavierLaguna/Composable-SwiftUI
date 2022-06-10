import Resolver

extension Resolver {

    static func registerDatasources() {
        registerRemoteDatasources()
    }
    
    static private func registerRemoteDatasources() {
        register { CharacterService() }.implements(CharacterRemoteDatasource.self)
        register { EpisodesService() }.implements(EpisodesRemoteDatasource.self)
        register { LocationService() }.implements(LocationRemoteDatasource.self)
    }
}
