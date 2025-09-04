//
//  Network+BreedList.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation

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

// MARK: - Data persistence & Cache

struct BreedsCache: Codable {
    let breeds: [String]
    let fetchedAt: Date
}

final class BreedListService {
    static let service = BreedListService()
    
    private let ttl: TimeInterval = 14 * 24 * 60 * 60
    private var cache: BreedsCache?
    private var cacheURL: URL {
        let base = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let dir = base.appendingPathComponent("BreedListService", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent("breeds.json")
    }
    
    func getBreedList() async throws -> [String] {
        if let cache = self.cache, !isStale(cache.fetchedAt) {
            return cache.breeds
        }
        
        if let localStorageData = try? loadFromLocalStorage(), !isStale(localStorageData.fetchedAt) {
            self.cache = localStorageData
            return localStorageData.breeds
        }
        
        do {
            let breedList = try await BreedList.fetchFromNetwork()
            let cache = BreedsCache(
                breeds: breedList.message.flatMap { key, values in
                    values.map {
                        "\(key) \($0)".capitalized
                    }
                },
                fetchedAt: Date()
            )
            try saveToLocalStorage(cache)
            self.cache = cache
            return cache.breeds
        } catch {
            throw error
        }
    }
    
    private func isStale(_ date: Date) -> Bool {
        Date().timeIntervalSince(date) > ttl
    }
    
    private func saveToLocalStorage(_ cache: BreedsCache) throws {
        let data = try JSONEncoder().encode(cache)
        try data.write(to: cacheURL, options: [.atomic])
    }
        
    private func loadFromLocalStorage() throws -> BreedsCache {
        let data = try Data(contentsOf: cacheURL)
        return try JSONDecoder().decode(BreedsCache.self, from: data)
    }
}
