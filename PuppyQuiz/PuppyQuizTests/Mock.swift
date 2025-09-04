//
//  Mock.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

final class MockNetwork: Network {
    var randomImages: [RandomImage] = []
    var providedBreedList: BreedList = BreedList(message: [:], status: "success")

    override func fetchData<T>(endpoint: Network.Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        switch endpoint {
        case .allBreeds:
            // Encode/decode dance to satisfy generic T
            let data = try JSONEncoder().encode(providedBreedList)
            return try JSONDecoder().decode(T.self, from: data)
        case .randomImage:
            guard !randomImages.isEmpty else {
                throw NSError(domain: "MockNetwork", code: 1, userInfo: [NSLocalizedDescriptionKey: "No more stubbed images"])
            }
            let img = randomImages.removeFirst()
            let data = try JSONEncoder().encode(img)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

final class FailingBreedListService: BreedListService {
    enum Err: Error { case fail }
    override func warmCache() async throws {
        throw Err.fail
    }
}
