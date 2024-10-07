import Foundation

struct APIClientFactory {

    static func build() -> any APIClient {
        URLSessionAPIClient()
    }
}
