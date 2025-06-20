import Foundation

struct APIClientFactory {

    static func build() -> any APIClient {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)

        return URLSessionAPIClient(session: session)
    }
}
