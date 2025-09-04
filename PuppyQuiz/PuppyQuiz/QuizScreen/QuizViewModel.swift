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
                let randomImage = try await RandomImage.fetchFromNetwork()
                quizItemsCache.append(QuizItem(from: randomImage))
            } catch {
                print("Failed to fetch data: \(error)")
            }
        }
    }
}
