import Foundation

struct APIClientFactory {

    static func build() -> APIClient {
        URLSessionAPIClient()
    }
}
