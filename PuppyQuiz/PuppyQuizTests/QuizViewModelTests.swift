//
//  QuizViewModelTests.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

@MainActor
struct QuizViewModelTests {
    // Helper to make a QuizItem without options (breed parsing fails so options are [])
    private func makeItem(_ url: String) -> QuizItem {
        let img = RandomImage(message: url, status: "success")
        return QuizItem(from: img)
    }

    @Test
    func init_setsCurrentItemToFirst() async {
        let items = [
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
        ]
        let vm = QuizViewModel(items)
        #expect(vm.currentQuizItem?.imageURLString == items[0].imageURLString)
        #expect(vm.quizItemsCache.count == 4)
    }

    @Test
    func loadNextQuizItem_advancesWithoutFetchingWhenCacheRemainsAtLeastThree() async {
        let items = [
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
            makeItem("https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg"),
        ]
        let vm = QuizViewModel(items)

        await vm.loadNextQuizItem()
        #expect(vm.quizItemsCache.count == 3)
        #expect(vm.currentQuizItem?.imageURLString == items[1].imageURLString)
    }
}
