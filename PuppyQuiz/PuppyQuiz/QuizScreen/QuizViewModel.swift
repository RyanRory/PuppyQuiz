//
//  QuizViewModel.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

@MainActor
class QuizViewModel: ObservableObject {
    @Published var currentQuizItem: QuizItem?
    var quizItemsCache: [QuizItem] = []
    
    init(_ quizItemsCache: [QuizItem]) {
        self.quizItemsCache = quizItemsCache
        self.currentQuizItem = quizItemsCache.first
    }
    
    func loadNextQuizItem() async {
        quizItemsCache.remove(at: 0)
        currentQuizItem = quizItemsCache.first
        
        if quizItemsCache.count < 3 {
            do {
                let newQuizItem = try await loadRandomQuizItem()
                quizItemsCache.append(newQuizItem)
            } catch {
                print("Failed to fetch data: \(error)")
            }
        }
    }
    
    func loadRandomQuizItem() async throws -> QuizItem {
        let randomItem = try await Network.client.fetchData(
            endpoint: .randomImage,
            responseType: RandomItem.self
        )
        return QuizItem(from: randomItem)
    }
}
