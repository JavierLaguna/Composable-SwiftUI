protocol LocationRepository: Sendable {
    func getCharacterIdsFromLocation(locationId: Int) async throws -> [Int]
    func getLocation(locationId: Int) async throws -> Location
}

struct LocationRepositoryFactory {

    static func build() -> LocationRepository {
        LocationRepositoryDefault(
            service: LocationRemoteDatasourceFactory.build()
        )
    }
}
