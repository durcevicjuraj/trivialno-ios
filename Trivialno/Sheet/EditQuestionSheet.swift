//
//  EditQuestionSheet.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import SwiftUI

struct EditQuestionSheet: View {
    @State var question: Question
    var onSave: (Question) -> Void

    @State private var correctEN = 0
    @State private var correctHR = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("English")) {
                    TextField("Question (EN)", text: Binding(
                        get: { question.question["en"] ?? "" },
                        set: { question.question["en"] = $0 }
                    ))

                    ForEach(0..<question.all_answers["en", default: []].count, id: \.self) { i in
                        TextField("Answer \(i + 1)", text: Binding(
                            get: { question.all_answers["en"]?[i] ?? "" },
                            set: { question.all_answers["en"]?[i] = $0 }
                        ))
                    }

                    Picker("Correct Answer", selection: $correctEN) {
                        ForEach(0..<4) {
                            Text("Answer \($0 + 1)").tag($0)
                        }
                    }.onAppear {
                        if let index = question.all_answers["en"]?.firstIndex(of: question.correct_answer["en"] ?? "") {
                            correctEN = index
                        }
                    }
                }

                Section(header: Text("Hrvatski")) {
                    TextField("Pitanje (HR)", text: Binding(
                        get: { question.question["hr"] ?? "" },
                        set: { question.question["hr"] = $0 }
                    ))

                    ForEach(0..<question.all_answers["hr", default: []].count, id: \.self) { i in
                        TextField("Odgovor \(i + 1)", text: Binding(
                            get: { question.all_answers["hr"]?[i] ?? "" },
                            set: { question.all_answers["hr"]?[i] = $0 }
                        ))
                    }

                    Picker("Točan Odgovor", selection: $correctHR) {
                        ForEach(0..<4) {
                            Text("Odgovor \($0 + 1)").tag($0)
                        }
                    }.onAppear {
                        if let index = question.all_answers["hr"]?.firstIndex(of: question.correct_answer["hr"] ?? "") {
                            correctHR = index
                        }
                    }
                }

                Section(header: Text("Options")) {
                    Picker("Category", selection: $question.category) {
                        ForEach(QuestionCategory.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }

                    Picker("Type", selection: $question.type) {
                        ForEach(QuestionType.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }

                    Picker("Difficulty", selection: $question.difficulty) {
                        ForEach(QuestionDifficulty.allCases, id: \.self) {
                            Text($0.localizedName)
                        }
                    }
                }

                Button("Save Changes") {
                    question.correct_answer["en"] = question.all_answers["en"]?[correctEN] ?? ""
                    question.correct_answer["hr"] = question.all_answers["hr"]?[correctHR] ?? ""
                    onSave(question)
                }
            }
            .navigationTitle("Edit Question")
        }
    }
}
