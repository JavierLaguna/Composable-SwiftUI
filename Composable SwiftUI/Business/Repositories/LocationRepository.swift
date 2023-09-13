
protocol LocationRepository {
    func getCharacterIdsFromLocation(locationId: Int) async throws -> [Int]
    func getLocation(locationId: Int) async throws -> Location
}
