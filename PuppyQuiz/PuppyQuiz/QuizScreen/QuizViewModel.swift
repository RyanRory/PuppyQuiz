//
//  QuizViewModel.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var currentQuizItem: QuizItem?
    var quizItemsCache: [QuizItem] = []
    
    init(_ quizItemsCache: [QuizItem]) {
        self.quizItemsCache = quizItemsCache
        self.currentQuizItem = quizItemsCache.first
    }
    
    func loadNextQuizItem() {
        quizItemsCache.remove(at: 0)
        currentQuizItem = quizItemsCache.first
    }
}
