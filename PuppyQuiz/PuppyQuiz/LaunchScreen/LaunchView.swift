//
//  LaunchView.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct LaunchScreen: View {
    @StateObject private var viewModel = LaunchViewModel()
    let onFinish: ([QuizItem]) -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accent.opacity(0.12), Color.darkYellow.opacity(0.12)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Image("Icon")
                    .resizable()
                    .frame(width: 100, height: 100)

                LoadingIndicator(
                    animation: .bar,
                    color: .accent,
                    size: .large
                )
            }
        }
        .task {
            await viewModel.loadInitialData()
            onFinish(viewModel.initialQuizItems)
        }
    }
}


#Preview {
    LaunchScreen() { _ in }
}
