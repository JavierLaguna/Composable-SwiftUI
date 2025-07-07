import Foundation
@testable import Composable_SwiftUI

struct GetLocationInfoInteractorMock: GetLocationInfoInteractor {

    var success: Bool = true
    var expectedResponse = LocationDetail(
        id: 1,
        name: "Earth",
        type: .planet,
        dimension: "dimension",
        residents: [
            Character(
                id: 1,
                name: "Rick",
                status: .alive,
                species: "human",
                type: "type",
                gender: .male,
                origin: .init(id: 1, name: "Earth"),
                location: .init(id: 1, name: "Earth"),
                image: "image",
                episodes: [1, 2, 3],
                created: Date.now,
                description: nil
            )
        ]
    )
    var expectedError: InteractorError = .generic(message: "mock error")

    func execute(locationId: Int) async throws -> LocationDetail {
        guard success else {
            throw expectedError
        }

        return expectedResponse
    }
}
