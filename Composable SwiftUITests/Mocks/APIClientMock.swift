import Foundation

@testable import Composable_SwiftUI

final class APIClientMock: APIClient, @unchecked Sendable {

    var usedApiRequest: APIRequest?

    // MARK: - Methods -
    func request<T: Decodable & Sendable>(
        _ apiRequest: APIRequest,
        decoder: JSONDecoder
    ) async throws -> T {
        usedApiRequest = apiRequest

        throw APIClientMockError.notImplemented
    }

    func requestVoid(_ apiRequest: APIRequest) async throws {
        usedApiRequest = apiRequest

        throw APIClientMockError.notImplemented
    }

    @discardableResult
    func requestWithProgress(
        _ apiRequest: APIRequest,
        progressDelegate: (
            UploadProgressDelegateProtocol
        )?
    ) async throws -> Data? {
        usedApiRequest = apiRequest

        throw APIClientMockError.notImplemented
    }
}

// MARK: Error
enum APIClientMockError: Error {
    case notImplemented
}
