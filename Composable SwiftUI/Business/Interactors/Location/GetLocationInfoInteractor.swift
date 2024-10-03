protocol GetLocationInfoInteractor: Sendable {
    func execute(locationId: Int) async throws -> LocationDetail
}

struct GetLocationInfoInteractorFactory {

    static func build() -> GetLocationInfoInteractor {
        GetLocationInfoInteractorDefault(
            locationRepository: LocationRepositoryFactory.build(),
            charactersRepository: CharactersRepositoryFactory.build()
        )
    }
}

struct GetLocationInfoInteractorDefault: GetLocationInfoInteractor {

    let locationRepository: LocationRepository
    let charactersRepository: CharactersRepository

    func execute(locationId: Int) async throws -> LocationDetail {
        // Catch and map error if needed
        let location = try await locationRepository.getLocation(locationId: locationId)
        let characters = try await charactersRepository.getCharacters(characterIds: location.residents)

        return LocationDetail(
            id: location.id,
            name: location.name,
            type: location.type,
            dimension: location.dimension,
            residents: characters
        )
    }
}
