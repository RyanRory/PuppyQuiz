//
//  Item.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

extension RandomItem {
    func extractBreed() -> String? {
        guard let url = URL(string: message) else { return nil }
        let components = url.pathComponents
        guard
            let breedsIndex = components.firstIndex(of: "breeds"),
            breedsIndex + 1 < components.count
        else {
            return nil
        }
        let breed = components[breedsIndex + 1]

        return breed.replacingOccurrences(of: "-", with: " ").capitalized
    }
}

struct QuizItem {
    struct Option: Equatable, Identifiable {
        var id: String { "\(answer)-\(option)-\(uuid.uuidString)" }
        let uuid: UUID = UUID()
        let option: String
        let answer: String
    }
    
    var imageURLString: String
    var breed: String?
    var options: [Option]
    
    init(from randomItem: RandomItem) {
        self.imageURLString = randomItem.message
        self.breed = randomItem.extractBreed()
        if let breed = self.breed {
            self.options = (BreedList.cache.filter { $0 != breed }.shuffled().prefix(3) + [breed])
                .shuffled()
                .map { Option(option: $0, answer: breed) }
        } else {
            self.options = []
        }
        
    }
}
