//
//  QuizItemOptionsTests.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

struct QuizItemOptionsTests {

    @Test
    func quizItem_buildsFourOptions_whenBreedListCached() {
        let cachedBreeds = ["malinois", "beagle", "pug", "poodle", "husky", "akita", "samoyed"]
        let cache = BreedsCache(breeds: cachedBreeds, fetchedAt: Date())
        BreedListService.service.updateCache(cache)

        let img = RandomImage(message: "https://images.dog.ceo/breeds/malinois/n02105162_4120.jpg", status: "success")
        let item = QuizItem(from: img)

        #expect(item.options.count == 4)
        #expect(item.options.contains(where: { $0.option == "Malinois" }))

        // Ensure options are unique
        let unique = Set(item.options.map { $0.option })
        #expect(unique.count == 4)
    }
}
