struct APIConstants {
    static let baseURL = "https://rickandmortyapi.com"
    static let characterPath = "/character"
    static let locationPath = "/location"
    static let episodePath = "/episode"

    struct Headers {
        static let applicationJson = "application/json"
        static let contentType = "Content-Type"
        static let multipartFormDataContentType = "multipart/form-data"
    }
}

// MARK: APIVersion
extension APIConstants {

    /// Enum defining different versions of the API.
    enum APIVersion: String {
        /// Version 1 of the API.
        case v1 = "/api"
    }
}
