protocol LocationRemoteDatasource {
    func getLocation(locationId: Int) async throws -> LocationResponse
}
