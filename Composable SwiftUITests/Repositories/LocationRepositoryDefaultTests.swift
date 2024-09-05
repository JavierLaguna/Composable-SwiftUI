import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite(
    "LocationRepositoryDefault Tests",
    .serialized
)
final class LocationRepositoryDefaultTests: ResetTestDependencies {

    @Test
    func getCharacterIdsFromLocationSuccess() async {
        let datasource = LocationRemoteDatasourceMock()
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        do {
            let result = try await repository.getCharacterIdsFromLocation(locationId: 1)

            #expect(result == [1, 2])

        } catch {
            Issue.record("Test Fail")
        }
    }

    @Test
    func getCharacterIdsFromLocationFail() async {
        let datasource = LocationRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        do {
            _ = try await repository.getCharacterIdsFromLocation(locationId: 1)

            Issue.record("Test Fail")

        } catch {
            #expect(error as? RepositoryError == .invalidUrl)
        }
    }
}
