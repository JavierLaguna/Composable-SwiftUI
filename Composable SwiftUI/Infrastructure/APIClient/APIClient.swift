import Foundation

/// A protocol defining the methods for making API requests.
protocol APIClient: Sendable {

    /// Sends a request to the specified endpoint and decodes the response into a given type.
    ///
    /// - Parameters:
    ///   - apiRequest: All request info..
    ///   - decoder: The `JSONDecoder` to use for decoding the response.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: An error if the request fails or if decoding fails.
    /// - Note: The type `T` must conform to `Codable` and `Sendable`.
    ///
    func request<T: Codable & Sendable>(
        _ apiRequest: APIRequest,
        decoder: JSONDecoder
    ) async throws -> T

    /// Sends a request that does not return the response body.
    ///
    /// - Parameters:
    ///   - apiRequest: All request info.
    ///   - decoder: The `JSONDecoder` to use for decoding the response.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: An error if the request fails or if decoding fails.
    /// - This method can be used for various HTTP methods that we are not interested in the response/return value but only if it succeed or fails, such as `POST`, `DELETE`, and `PATCH` and more.
    ///
    func requestVoid(
        _ apiRequest: APIRequest
    ) async throws

    /// Sends a request to the specified endpoint and returns the raw data with the upload progress.
    ///
    /// - Parameters:
    ///   - apiRequest: All request info.
    ///   - progressDelegate: An optional delegate for tracking upload progress.
    /// - Returns: The raw `Data` received from the request, or `nil` if no data is received.
    /// - Throws: An error if the request fails.
    ///
    @discardableResult
    func requestWithProgress(
        _ apiRequest: APIRequest,
        progressDelegate: (any UploadProgressDelegateProtocol)?
    ) async throws -> Data?
}

extension APIClient {

    // With default decoder parameter: JSONDecoder()
    @discardableResult
    func request<T: Codable & Sendable>(_ apiRequest: APIRequest) async throws -> T {
        try await request(apiRequest, decoder: JSONDecoder())
    }

    // With default delegate parameter: nil
    @discardableResult
    func requestData(
        _ apiRequest: APIRequest
    ) async throws -> Data? {
        try await requestWithProgress(apiRequest, progressDelegate: nil)
    }
}
