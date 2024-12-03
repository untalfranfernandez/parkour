import Foundation

protocol APIService {
    func execute(_ endpoint: APIEndpoint) async throws
    func execute<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryParameters: [String: String]?
    let body: Data?

    init(path: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         queryParameters: [String: String]? = nil,
         body: Data? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
