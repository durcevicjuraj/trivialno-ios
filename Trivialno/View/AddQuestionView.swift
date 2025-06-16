//
//  AddQuestionView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import SwiftUI

struct AddQuestionView: View {
    @StateObject private var viewModel = AddQuestionViewModel()
    
    // English
    @State private var questionTextEN = ""
    @State private var allAnswersEN: [String] = ["", "", "", ""]
    @State private var correctAnswerIndexEN: Int = 0

    // Croatian
    @State private var questionTextHR = ""
    @State private var allAnswersHR: [String] = ["", "", "", ""]
    @State private var correctAnswerIndexHR: Int = 0

    @State private var selectedCategory: QuestionCategory = .general
    @State private var selectedType: QuestionType = .multipleChoice
    @State private var selectedDifficulty: QuestionDifficulty = .easy
    @State private var statusMessage: String?

    var body: some View {
        NavigationView {
            
            Form {
                // English section
                Section(header: Text("English")) {
                    TextField("Question (EN)", text: $questionTextEN)
                    ForEach(0..<4, id: \.self) { index in
                        TextField("Answer \(index + 1)", text: $allAnswersEN[index])
                    }
                    Picker("Correct Answer (EN)", selection: $correctAnswerIndexEN) {
                        ForEach(0..<4, id: \.self) {
                            Text("Answer \($0 + 1)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Croatian section
                Section(header: Text("Hrvatski")) {
                    TextField("Pitanje (HR)", text: $questionTextHR)
                    ForEach(0..<4, id: \.self) { index in
                        TextField("Odgovor \(index + 1)", text: $allAnswersHR[index])
                    }
                    Picker("Točan odgovor (HR)", selection: $correctAnswerIndexHR) {
                        ForEach(0..<4, id: \.self) {
                            Text("Odgovor \($0 + 1)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Options")) {
                    Picker("category", selection: $selectedCategory) {
                        ForEach(QuestionCategory.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }

                    Picker("type", selection: $selectedType) {
                        ForEach(QuestionType.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }

                    Picker("difficulty", selection: $selectedDifficulty) {
                        ForEach(QuestionDifficulty.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }
                }

                Button("addQuestion") {
                    let question = Question(
                        category: selectedCategory,
                        type: selectedType,
                        difficulty: selectedDifficulty,
                        question: [
                            "en": questionTextEN,
                            "hr": questionTextHR
                        ],
                        correct_answer: [
                            "en": allAnswersEN[correctAnswerIndexEN],
                            "hr": allAnswersHR[correctAnswerIndexHR]
                        ],
                        all_answers: [
                            "en": allAnswersEN,
                            "hr": allAnswersHR
                        ]
                    )

                    viewModel.addQuestion(question) { result in
                        switch result {
                        case .success:
                            statusMessage = "✅ Question added successfully."
                            clearForm()
                        case .failure(let error):
                            statusMessage = "❌ Error: \(error.localizedDescription)"
                        }
                    }
                }
                .disabled(!isFormValid)
            }

            if let message = statusMessage {
                Text(message)
                    .foregroundColor(message.contains("Error") ? .red : .green)
                    .padding()
            }
        }
        .navigationTitle("addQuestion")
    }

    private var isFormValid: Bool {
        !questionTextEN.isEmpty &&
        !questionTextHR.isEmpty &&
        !allAnswersEN.contains(where: { $0.isEmpty }) &&
        !allAnswersHR.contains(where: { $0.isEmpty })
    }

    private func clearForm() {
        questionTextEN = ""
        questionTextHR = ""
        allAnswersEN = ["", "", "", ""]
        allAnswersHR = ["", "", "", ""]
        correctAnswerIndexEN = 0
        correctAnswerIndexHR = 0
        selectedCategory = .general
        selectedType = .multipleChoice
        selectedDifficulty = .easy
    }
}



#Preview {
    AddQuestionView()
}
