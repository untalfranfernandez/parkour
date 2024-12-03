import Foundation

final class HTTPClient: APIService {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    private func _execute(_ endpoint: APIEndpoint) async throws -> Data{
        let url = try buildURL(for: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            if httpResponse.statusCode == 429 {
                throw APIError.tooManyRequests
            }
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    func execute(_ endpoint: APIEndpoint) async throws {
        _ = try await _execute(endpoint)
    }

    func execute<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let data = try await _execute(endpoint)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }

    private func buildURL(for endpoint: APIEndpoint) throws -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        components?.queryItems = endpoint.queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        return url
    }
}

enum APIError: Error {
    case unknown
    case invalidURL
    case tooManyRequests
    case invalidResponse(statusCode: Int)
    case decodingFailed
}
