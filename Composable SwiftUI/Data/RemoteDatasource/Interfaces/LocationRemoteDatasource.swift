protocol LocationRemoteDatasource {
    func getLocation(locationId: Int) async throws -> LocationResponse
}

struct LocationRemoteDatasourceFactory {

    static func build() -> LocationRemoteDatasource {
        LocationService()
    }
}
