//
//  ContentView.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 3/9/2025.
//

import SwiftUI
import Kingfisher
import LucideIcons
import SwiftfulLoadingIndicators

struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    @State private var animateOptions = false
    @State private var isOptionsEnabled = true
    
    init(_ viewModel: QuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accent.opacity(0.12), Color.darkYellow.opacity(0.12)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if
                let quizItem: QuizItem = viewModel.currentQuizItem,
                quizItem.options.count > 1
            {
                GeometryReader { geo in
                    VStack(spacing: 16) {
                        ZStack {
                            KFImage(URL(string: quizItem.imageURLString))
                                .placeholder {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.accent.opacity(0.5))
                                            .frame(
                                                width: geo.size.width - 2 * 16,
                                                height: geo.size.height / 2
                                            )
                                        
                                        LoadingIndicator(
                                            animation: .bar,
                                            color: .accent,
                                            size: .large
                                        )
                                    }
                                }
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
                        .frame(height: geo.size.height / 2)
                        .animation(
                            .spring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2),
                            value: quizItem.imageURLString
                        )
                        
                        ForEach(Array(quizItem.options.enumerated()), id: \.element.id) { index, option in
                            OptionView(
                                isEnabled: $isOptionsEnabled,
                                option: option.option,
                                answer: option.answer
                            ) {
                                Task {
                                    await viewModel.loadNextQuizItem()
                                }
                                isOptionsEnabled = true
                            }
                            .accessibilityIdentifier("optionButton_\(index)")
                            .scaleEffect(animateOptions ? 1.0 : 0.9)
                            .animation(
                                .interpolatingSpring(stiffness: 200, damping: 15).delay(Double(index) * 0.05),
                                value: animateOptions
                            )
                        }
                    }
                    .padding(.top)
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
                    .onAppear {
                        animateOptions = true
                        SoundManager.shared.preload()
                    }
                }
                
            }
            else {
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
        }
    }
}

// MARK: - ErrorCard

private struct ErrorCard: View {
    let size: CGSize
    var retry: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.25), lineWidth: 1)
                )
                .frame(width: size.width, height: size.height)
            
            VStack(spacing: 8) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.red.opacity(0.9))
                Text("Couldn’t load image")
                    .font(.headline)
                Button("Retry", action: retry)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .padding(.horizontal)
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
    @Binding var isEnabled: Bool
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
        .disabled(!isEnabled)
    }
    
    private func selected() {
        if option == answer {
            status = OptionView.Status.right
            isEnabled = false
            SoundManager.shared.playCorrectBark()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
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
        QuizViewModel(
            [
                QuizItem(
                    from: RandomImage(
                        message: "https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg",
                        status: "success"
                    )
                ),
                QuizItem(
                    from: RandomImage(
                        message: "https://images.dog.ceo/breeds/malinois/n02105162_4120.jpg",
                        status: "success"
                    )
                )
            ]
        )
    )
}
