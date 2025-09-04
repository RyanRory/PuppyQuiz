//
//  Network+Response.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

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
