//
//  Network+BreedList.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation

protocol Response: Codable {
    static func fetchFromNetwork() async throws -> Self
}

// MARK: - BreedList

struct BreedList: Response {
    let message: [String: [String]]
    let status: String
    
    static func fetchFromNetwork() async throws -> BreedList {
        let breedslist = try await Network.client.fetchData(
            endpoint: .allBreeds,
            responseType: BreedList.self
        )
        
        return breedslist
    }
}

// MARK: - RandomImage

struct RandomImage: Response {
    let message: String
    let status: String
    
    static func fetchFromNetwork() async throws -> RandomImage {
        let randomImage = try await Network.client.fetchData(
            endpoint: .randomImage,
            responseType: RandomImage.self
        )
        
        return randomImage
    }
}
