//
//  Network+Response.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

struct RandomItem: Codable {
    let message: String
    let status: String
}

struct BreedList: Codable {
    let message: [String: [String]]
    let status: String
}

extension BreedList {
    static private(set) var cache: [String] = []
    
    static func updateCache(_ breedList: [String: [String]]) {
        cache = breedList.flatMap { key, values in
            values.map {
                "\(key) \($0)".capitalized
            }
        }
    }
}
