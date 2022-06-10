import Resolver

extension Resolver {

    static func registerRepositories() {
        register { CharactersRepositoryDefault() }.implements(CharactersRepository.self)
        register { LocationRepositoryDefault() }.implements(LocationRepository.self)
        register { EpisodesRepositoryDefault() }.implements(EpisodesRepository.self)
    }
}
