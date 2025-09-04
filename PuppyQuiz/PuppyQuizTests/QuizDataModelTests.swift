//
//  QuizDataModelTests.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

struct QuizDataModelTests {

    @Test
    func extractBreed_singleWordBreed() {
        let img = RandomImage(message: "https://images.dog.ceo/breeds/malinois/n02105162_4120.jpg", status: "success")
        #expect(img.extractBreed() == "Malinois")
    }

    @Test
    func extractBreed_hyphenatedSubbreed() {
        let img = RandomImage(message: "https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg", status: "success")
        #expect(img.extractBreed() == "Hound Plott")
    }
}
