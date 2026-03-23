actor LocationRepositoryDefault: LocationRepository {

    private let service: any LocationRemoteDatasource
    private(set) var nextPage: Int?
    private(set) var totalPages: Int?

    init(service: any LocationRemoteDatasource) {
        self.service = service
    }

    func getLocations() async throws -> [Location] {
        if let nextPage, let totalPages, nextPage > totalPages {
            return []
        }

        let response = try await service.getLocations(page: nextPage)

        if let nextPage {
            self.nextPage = nextPage + 1
        } else {
            nextPage = 2
        }

        totalPages = response.info.pages

        return response.results.map { $0.toDomain() }
    }

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
