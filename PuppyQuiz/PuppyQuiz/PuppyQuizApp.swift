//
//  PuppyQuizApp.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI

@main
struct PuppyQuizApp: App {
    var body: some Scene {
        WindowGroup {
            QuizView(viewModel: QuizViewModel([]))
        }
    }
}
