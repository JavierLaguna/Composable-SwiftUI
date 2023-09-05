import Foundation
import Combine

class HttpClient {
    
    private let agent = Agent()
    
    func get<D: Decodable>(from url: URL) -> AnyPublisher<D, Error> {
        run(URLRequest(url: url))
    }
    
    func post<D: Decodable, E: Encodable>(_ data: E, to url: URL) -> AnyPublisher<D, Error> {
        
        do {
            let data = try JSONEncoder().encode(data)
            var request = URLRequest(url: url)
            request.httpMethod = HttpConstants.postMethod
            request.httpBody = data
            request.addValue(
                HttpConstants.Headers.applicationJson,
                forHTTPHeaderField: HttpConstants.Headers.contentType)
            return run(request)
        } catch {
            return Fail(error: NSError(domain: "\(error)", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    private func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

private struct Agent {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        
        print("REQUEST ====> \(request)")
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                print("RESPONSE ====> \(result.response)")
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
