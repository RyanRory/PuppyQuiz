//
//  ContentView.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI
import Kingfisher
import LucideIcons

struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    @State private var animateOptions = false

    var body: some View {
        ZStack {
            if
                let quizItem: QuizItem = viewModel.currentQuizItem,
                quizItem.options.count > 1
            {
                VStack(spacing: 16) {
                    ZStack {
                        KFImage(URL(string: quizItem.imageURLString))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 6)
                            .padding()
                            .id(quizItem.imageURLString)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2),
                        value: quizItem.imageURLString
                    )
                    
                    ForEach(Array(quizItem.options.enumerated()), id: \.element.id) { idx, option in
                        OptionView(option: option.option, answer: option.answer) {
                            viewModel.loadNextQuizItem()
                        }
                        .scaleEffect(animateOptions ? 1.0 : 0.9)
                        .animation(
                            .interpolatingSpring(stiffness: 200, damping: 15).delay(Double(idx) * 0.05),
                            value: animateOptions
                        )
                    }
                }
                .frame(
                    maxHeight: .infinity,
                    alignment: .top
                )
                .onChange(of: quizItem.imageURLString) {
                    animateOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        animateOptions = true
                    }
                    
                }
                .onAppear { animateOptions = true }
            }
            else {
                
            }
        }
    }
}

// MARK: - Option View

struct OptionView: View {
    enum Status {
        case right
        case wrong
        case notSelected
        
        var color: (background: Color, border: Color) {
            switch self {
                case .right:
                    return (background: Color.rightGreen, border: Color.darkGreen)
                case .wrong:
                    return (background: Color.wrongRed, border: Color.darkRed)
                case .notSelected:
                    return (background: Color.accent, border: Color.darkYellow)
            }
        }
    }
    
    @State var status: Status = .notSelected
    let option: String
    let answer: String
    let onCorrectAnswerSelected: () -> Void
    
    var body: some View {
        Button {
            selected()
        } label: {
            HStack(spacing: 16) {
                Image(uiImage: Lucide.bone)
                    .renderingMode(.template)
                Text(option)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Image(uiImage: Lucide.bone)
                    .renderingMode(.template)
            }
            .padding()
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(status.color.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(status.color.border, lineWidth: 2)
                    )
            )
            .padding(.horizontal)
        }
    }
    
    private func selected() {
        if option == answer {
            status = OptionView.Status.right
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                onCorrectAnswerSelected()
            }
        } else {
            status = OptionView.Status.wrong
        }
    }
}

// MARK: Quiz Screen Preview

#Preview {
    QuizView(
        viewModel: QuizViewModel(
            [
                QuizItem(
                    from: RandomItem(
                        message: "https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg",
                        status: "success"
                    )
                ),
                QuizItem(
                    from: RandomItem(
                        message: "https://images.dog.ceo/breeds/malinois/n02105162_4120.jpg",
                        status: "success"
                    )
                )
            ]
        )
    )
}
