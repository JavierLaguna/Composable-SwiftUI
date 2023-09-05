import Resolver

extension Resolver {

    static func registerDatasources() {
        registerRemoteDatasources()
    }
    
    static private func registerRemoteDatasources() {
        register { CharacterService() }.implements(CharacterRemoteDatasource.self)
        register(CharacterRemoteDatasource.self, name: "async") { _ in
            CharacterServiceAsync()
        }
        register { EpisodesService() }.implements(EpisodesRemoteDatasource.self)
        register { LocationService() }.implements(LocationRemoteDatasource.self)
        register(LocationRemoteDatasource.self, name: "async") { _ in
            LocationServiceAsync()
        }
    }
}
