//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

//
//  PlayView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct PlayView: View {
    @StateObject private var viewModel = PlayViewModel()
    
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        if viewModel.gameFinished {
            ResultView(
                score: viewModel.score,
                timeLeft: viewModel.timeRemaining,
                used5050: viewModel.used5050,
                usedSkip: viewModel.usedSkip,
                usedDoublePoints: viewModel.usedDoublePointsOverall
            ) {
                viewModel.resetGame()
            }
        } else {
            ZStack {
                AdaptiveBackgroundView()
                
                ShakeListener {
                    viewModel.shuffleAnswersForCurrentQuestion()
                }


                VStack(spacing: 24) {
                    Spacer().frame(height: 200)

                    if let question = viewModel.currentQuestion,
                       let lang = Locale.current.language.languageCode?.identifier,
                       let text = question.question[lang],
                       let answers = question.all_answers[lang] {

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 0) {
                                Text("question")
                                    .font(.headline)
                                Text(" \(viewModel.currentIndex + 1).")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            Text(text)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 130, alignment: .topLeading)
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? Color.darkBG.opacity(0.75) : Color.lightBG.opacity(0.75))
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.purple.opacity(0.15))
                            }
                        )
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        Spacer().frame(height: 20)

                        // Jokers
                        HStack(spacing: 32) {
                            Button(action: viewModel.use5050) {
                                Image(systemName: "circle.lefthalf.filled.inverse")
                                    .resizable()
                                    .foregroundStyle(viewModel.used5050 ? .gray : .pink)
                                    .frame(width: 40, height: 40)
                            }.disabled(viewModel.used5050)

                            Button(action: viewModel.useSkip) {
                                Image(systemName: "arrowshape.right.circle")
                                    .resizable()
                                    .foregroundStyle(viewModel.usedSkip ? .gray : .pink)
                                    .frame(width: 40, height: 40)
                            }.disabled(viewModel.usedSkip)

                            Button(action: viewModel.useDoublePoints) {
                                Image(systemName: "figure.american.football.circle")
                                    .resizable()
                                    .foregroundStyle(viewModel.usedDoublePointsOverall ? .gray : .pink)
                                    .frame(width: 40, height: 40)
                            }.disabled(viewModel.usedDoublePointsOverall)
                        }

                        Spacer().frame(height: 20)
                        
                        // Answers
                        VStack(spacing: 16) {
                            ForEach(Array(answers.enumerated()), id: \.offset) { i, answer in
                                Button(action: {
                                    viewModel.selectAnswer(text: answer)
                                }) {
                                    Text(answer)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: 300)
                                        .padding()
                                        .background(buttonColor(for: answer, index: i))
                                        .cornerRadius(30)
                                        .fontWeight(.bold)
                                }
                                .disabled(viewModel.showAnswers || viewModel.hiddenAnswers.contains(i))
                                .opacity(viewModel.hiddenAnswers.contains(i) ? 0.4 : 1.0)
                            }
                        }
                        .padding(.horizontal)

                        Spacer().frame(height: 20)


                        VStack(spacing: 4) {
                            Text("points") + Text(": \(viewModel.score)")
                            Text("timeLeft") + Text(": \(viewModel.timeRemaining)s")
                        }
                        .font(.subheadline)
                        .padding()

                    } else {
                        ProgressView("Loading...")
                            .onAppear { viewModel.fetchQuestions() }
                    }

                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                viewModel.userManager = userManager
            }
            .onDisappear {
                if !viewModel.gameFinished {
                    viewModel.resetGame()
                }
            }
        }
    }

    func buttonColor(for answer: String, index: Int) -> Color {
        guard
            viewModel.showAnswers,
            let question = viewModel.currentQuestion,
            let lang = Locale.current.language.languageCode?.identifier,
            let correct = question.correct_answer[lang]
        else {
            return viewModel.hiddenAnswers.contains(index) ? Color.gray : Color.purple
        }

        if answer == correct {
            return Color.green
        } else if let selected = viewModel.selectedAnswer,
                  question.all_answers[lang]?[selected] == answer {
            return Color.red
        } else {
            return Color.gray
        }
    }
}

#Preview {
    PlayView()
        .environmentObject(UserManager())
}
