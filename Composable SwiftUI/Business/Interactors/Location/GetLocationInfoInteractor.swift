import Resolver

protocol GetLocationInfoInteractor {
    func execute(locationId: Int) async throws -> LocationDetail
}

struct GetLocationInfoInteractorDefault: GetLocationInfoInteractor {
    
    @Injected private var locationRepository: LocationRepository
    @Injected private var charactersRepository: CharactersRepository
    
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

