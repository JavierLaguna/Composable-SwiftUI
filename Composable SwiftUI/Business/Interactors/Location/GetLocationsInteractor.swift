import Foundation
import Mockable

@Mockable
protocol GetLocationsInteractor: Sendable {
    func execute() async throws -> [Location]
}

struct GetLocationsInteractorFactory {

    static func build() -> any GetLocationsInteractor {
        GetLocationsInteractorDefault(
            locationRepository: LocationRepositoryFactory.build()
        )
    }
}

struct GetLocationsInteractorDefault: GetLocationsInteractor, ManagedErrorInteractor {

    let locationRepository: any LocationRepository

    func execute() async throws -> [Location] {
        do {
            return try await locationRepository.getLocations()

        } catch {
            throw manageError(error: error)
        }
    }
}
