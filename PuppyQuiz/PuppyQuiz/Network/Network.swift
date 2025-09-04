//
//  Network.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

class Network {
    static let client = Network()
    
    private let baseURL: String = "https://dog.ceo/api/breeds/"

    func fetchData<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard let url: URL = URL(string: "\(baseURL)\(endpoint.path)") else {
            throw URLError(.badURL)
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension Network {
    enum Endpoint {
        case allBreeds
        case randomImage
        
        var path: String {
            switch self {
                case .allBreeds:
                    return "list/all"
                case .randomImage:
                    return "image/random"
            }
        }
    }
}

// MARK: - Response

protocol Response: Codable {
    static func fetchFromNetwork() async throws -> Self
}
