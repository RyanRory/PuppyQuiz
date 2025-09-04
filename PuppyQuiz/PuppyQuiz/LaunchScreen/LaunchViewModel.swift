//
//  LaunchViewModel.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI

@MainActor
class LaunchViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var hasError = false
    var initialQuizItems: [QuizItem] = []
    
    func loadInitialData() async {
        do {
            try await BreedListService.service.warmCache()
            
            let quizItems = try await withThrowingTaskGroup(of: QuizItem.self) { group -> [QuizItem] in
                for _ in 0..<3 {
                    group.addTask {
                        let randomImage = try await RandomImage.fetchFromNetwork()
                        return QuizItem(from: randomImage)
                    }
                }
                
                var results: [QuizItem] = []
                for try await quizItem in group {
                    results.append(quizItem)
                }
                return results
            }
            
            initialQuizItems = quizItems
            isLoading = false
        } catch {
            hasError = true
            isLoading = false
            print("Failed to fetch data: \(error)")
        }
    }
}
