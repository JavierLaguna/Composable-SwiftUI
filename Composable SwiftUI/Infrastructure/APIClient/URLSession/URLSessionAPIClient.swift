import Foundation

struct URLSessionAPIClient: APIClient {

    // MARK: - Properties -
    private let token: String?
    private let session: URLSession

    // MARK: - Initialization -
    init(token: String? = nil, session: URLSession = .shared) {
        self.token = token
        self.session = session
    }

    // MARK: - Methods -
    func request<T: Decodable & Sendable>(
        _ apiRequest: APIRequest,
        decoder: JSONDecoder
    ) async throws -> T {
        guard let request = apiRequest.urlRequest else {
            throw APIClientError.invalidURL
        }

        // Perform the network request and decode the data
        let data = try await performRequest(request)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // Handle decoding errors
            throw APIClientError.decodingFailed(error)
        }
    }

    func requestVoid(
        _ apiRequest: APIRequest
    ) async throws {
        guard let request = apiRequest.urlRequest else {
            throw APIClientError.invalidURL
        }

        // Perform the network request
       try await performRequest(request)
    }

    @discardableResult
    func requestWithProgress(
        _ apiRequest: APIRequest,
        progressDelegate: (
            UploadProgressDelegateProtocol
        )?
    ) async throws -> Data? {
        guard let request = apiRequest.urlRequest else {
            throw APIClientError.urlRequestIsEmpty
        }

        do {
            let data = try await performRequest(request, progressDelegate: progressDelegate)
            return data
        } catch {
            throw error
        }
    }
}

// MARK: Private methods
private extension URLSessionAPIClient {

    @discardableResult
    private func performRequest(
        _ request: URLRequest,
        progressDelegate: (UploadProgressDelegateProtocol)? = nil
    ) async throws -> Data {
        // Inject token if available
        if let token = token {
            var mutableRequest = request
            mutableRequest.addValue(.tokenWithSpace + String(token), forHTTPHeaderField: .authorization)
        }

        // Configure session
        let session: URLSession
        if let progressDelegate {
            session = URLSession(configuration: .default, delegate: progressDelegate, delegateQueue: nil)
        } else {
            session = self.session
        }

        do {
            // Perform the network request
            let (data, response) = try await session.data(for: request)

            // Ensure the response is an HTTP URL response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse(data)
            }

            // Validate HTTP status code
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.statusCode(httpResponse.statusCode)
            }

            return data
        } catch {
            // Handle specific errors
            if let urlError = error as? URLError {
                throw APIClientError.networkError(urlError)
            } else {
                throw APIClientError.requestFailed(error)
            }
        }
    }
}

private extension String {
    static let tokenWithSpace = "Token "
    static let authorization = "Authorization"
}
