struct APIConstants {
    static let baseURL = "https://rickandmortyapi.com"
    static let characterPath = "/character" // TODO: JLI - user enum?
    static let locationPath = "/location" // TODO: JLI - user enum?
    static let episodePath = "/episode" // TODO: JLI - user enum?

    struct Headers {
        static let applicationJson = "application/json" // TODO: JLI use it
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
