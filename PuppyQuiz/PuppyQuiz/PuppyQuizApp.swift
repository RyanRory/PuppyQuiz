//
//  PuppyQuizApp.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI

@main
struct PuppyQuizApp: App {
    enum AppRoute {
        case launch
        case quiz(initialItems: [QuizItem])
    }
    
    @State private var route: AppRoute = .launch
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch route {
                    case .launch:
                        LaunchScreen { initialItems in
                            withAnimation(.easeInOut(duration: 0.35)) {
                                route = .quiz(initialItems: initialItems)
                            }
                        }

                    case .quiz(let items):
                        QuizView(QuizViewModel(items))
                    }
            }
        }
    }
}
