import Foundation

class HttpClient {
    
    func get<D: Decodable>(from url: URL) async throws -> D {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(D.self, from: data)
    }
    
    func post<D: Decodable, E: Encodable>(_ requestData: E, to url: URL) async throws -> D {
        let bodyData = try JSONEncoder().encode(requestData)
        var request = URLRequest(url: url)
        request.httpMethod = HttpConstants.postMethod
        request.httpBody = bodyData
        request.addValue(
            HttpConstants.Headers.applicationJson,
            forHTTPHeaderField: HttpConstants.Headers.contentType)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(D.self, from: responseData)
    }
}
