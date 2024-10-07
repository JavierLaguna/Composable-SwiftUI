protocol LocationRemoteDatasource: Sendable {
    func getLocation(locationId: Int) async throws -> LocationResponse
}

struct LocationRemoteDatasourceFactory {

    static func build() -> any LocationRemoteDatasource {
        LocationService(
            apiClient: APIClientFactory.build()
        )
    }
}
