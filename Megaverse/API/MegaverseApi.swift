import Foundation

final class MegaverseApi {
    private let candidateID: String
    private let apiClient: APIService
    private static let baseURL = URL(string: "https://challenge.crossmint.io")!

    init(
        candidateID: String,
        apiClient: APIService = HTTPClient(baseURL: baseURL)
    ) {
        self.apiClient = apiClient
        self.candidateID = candidateID
    }

    func post(_ polyanet: Polyanet) async throws {
        let endpoint = APIEndpoint(
            path: "/api/polyanets",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(polyanet.x)", "column": "\(polyanet.y)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }

    func delete(_ polyanet: Polyanet) async throws {
        let endpoint = APIEndpoint(
            path: "/api/polyanets",
            method: .delete,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(polyanet.x)", "column": "\(polyanet.y)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }
    
    func post(_ soloon: Soloon) async throws {
        let endpoint = APIEndpoint(
            path: "/api/soloons",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(soloon.x)", "column": "\(soloon.y)", "color": "\(soloon.color)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }

    func delete(_ soloon: Soloon) async throws {
        let endpoint = APIEndpoint(
            path: "/api/soloon",
            method: .delete,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(soloon.x)", "column": "\(soloon.y)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }
    
    func post(_ cometh: Cometh) async throws {
        let endpoint = APIEndpoint(
            path: "/api/cometh",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(cometh.x)", "column": "\(cometh.y)", "direction": "\(cometh.direction)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }

    func delete(_ cometh: Cometh) async throws {
        let endpoint = APIEndpoint(
            path: "/api/cometh",
            method: .delete,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(
                ["row": "\(cometh.x)", "column": "\(cometh.y)", "candidateId": candidateID]
            )
        )
        try await apiClient.execute(endpoint)
    }
    
    func getMegaverse() async throws -> Megaverse {
        let endpoint = APIEndpoint(
            path: "api/map/\(candidateID)/goal",
            method: .get,
            headers: ["Content-Type": "application/json"]
        )
        return try await apiClient.execute(endpoint)
    }
}
