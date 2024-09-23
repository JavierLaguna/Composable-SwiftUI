import Resolver

struct LocationRepositoryDefault: LocationRepository {

    let service: LocationRemoteDatasource

    func getCharacterIdsFromLocation(locationId: Int) async throws -> [Int] {
        try await service.getLocation(locationId: locationId)
            .toDomain()
            .residents
    }

    func getLocation(locationId: Int) async throws -> Location {
        try await service.getLocation(locationId: locationId)
            .toDomain()
    }
}
