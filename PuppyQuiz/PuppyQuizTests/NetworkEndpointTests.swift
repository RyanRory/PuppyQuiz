//
//  NetworkEndpointTests.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

struct NetworkEndpointTests {
    @Test
    func endpoint_paths() {
        #expect(Network.Endpoint.allBreeds.path == "list/all")
        #expect(Network.Endpoint.randomImage.path == "image/random")
    }
}
