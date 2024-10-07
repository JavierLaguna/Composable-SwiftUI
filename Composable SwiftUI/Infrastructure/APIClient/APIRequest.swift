import Foundation

/////
///// - `baseURL`: The base URL for the API.
///// - `apiVersion`: The version of the API being used.
///// - `path`: The specific path for the endpoint relative to the base URL.
///// - `urlParams`: A dictionary of query parameters to include in the URL. The values must conform to `CustomStringConvertible`.
///// - `method`: The HTTP method to be used for the request (e.g., GET, POST).
///// - `headers`: A dictionary of HTTP headers to include in the request.
///// - `body`: The body of the request, if any, as `Data`.
///// - `urlRequest`: A computed `URLRequest` based on the provided components. Returns `nil` if the URL cannot be constructed.
/////
struct APIRequest {

    let baseURL: String
    let apiVersion: APIConstants.APIVersion
    let path: String
    let urlParams: [String: any CustomStringConvertible]
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?

    init(
        baseURL: String,
        apiVersion: APIConstants.APIVersion,
        path: String,
        urlParams: [String: any CustomStringConvertible] = [:],
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.path = path
        self.urlParams = urlParams
        self.method = method
        self.headers = headers
        self.body = body
    }

    /// A computed property that constructs and returns a `URLRequest` for the endpoint.
    ///
    /// This property assembles a `URLRequest` by combining the base URL, API version, and path. It adds any query parameters and sets the HTTP method, headers, and body as specified by the endpoint.
    ///
    /// - Returns: A `URLRequest` if the URL components can be successfully created, otherwise `nil`.
    ///
    /// ### Example
    /// ```swift
    /// let request = endpoint.urlRequest
    /// // Use the request with URLSession or any networking library.
    /// ```
    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + apiVersion.rawValue + path)
        if !urlParams.isEmpty {
            components?.queryItems = urlParams.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }
}
