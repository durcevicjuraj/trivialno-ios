//
//  BrowseQuestionsView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import SwiftUI

struct BrowseQuestionsView: View {
    @StateObject private var viewModel = BrowseQuestionsViewModel()
    
    @State private var selectedQuestion: Question? = nil
    @State private var isEditing = false


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("searchAndFilter")) {
                    TextField("searchQuestionEN", text: $viewModel.searchText)

                    Picker("category", selection: $viewModel.selectedCategory) {
                        Text("all").tag(nil as QuestionCategory?)
                        ForEach(QuestionCategory.allCases, id: \.self) { category in
                            Text(category.localizedName).tag(Optional(category))
                        }
                    }
                    .onChange(of: viewModel.selectedCategory) { _,_ in
                        viewModel.applyFilters()
                    }

                    Picker("type", selection: $viewModel.selectedType) {
                        Text("all").tag(nil as QuestionType?)

                        ForEach(QuestionType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(Optional(type))
                        }
                    }
                    .onChange(of: viewModel.selectedType) { _,_ in
                        viewModel.applyFilters()
                    }


                    Picker("difficulty", selection: $viewModel.selectedDifficulty) {
                        Text("all").tag(nil as QuestionDifficulty?)

                        ForEach(QuestionDifficulty.allCases, id: \.self) { diff in
                            Text(diff.localizedName).tag(Optional(diff))
                        }
                    }
                    .onChange(of: viewModel.selectedDifficulty) { _,_ in
                        viewModel.applyFilters()
                    }

                }

                Section(header: Text("questions")) {
                    if viewModel.filteredQuestions.isEmpty {
                        Text("No questions found.")
                    } else {
                        ForEach(viewModel.filteredQuestions, id: \.id) { question in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(question.question["en"] ?? "No EN text")
                                    .font(.headline)
                                Text("category") + Text(": \(question.category.localizedName)")

                                Text("type") + Text(": \(question.type.localizedName)")
                                
                                Text("difficulty") + Text(": \(question.difficulty.localizedName)")
                            }
                            .onTapGesture {
                                selectedQuestion = question
                                isEditing = true
                            }
                            .padding(.vertical, 4)
                        }

                    }
                }
            }
            .navigationTitle("browseQuestions")
            .sheet(item: $selectedQuestion) { question in
                EditQuestionSheet(
                    question: question,
                    onSave: { updated in
                        viewModel.updateQuestion(updated) { result in
                            switch result {
                            case .success:
                                self.selectedQuestion = nil
                            case .failure(let error):
                                print("❌ Failed to update: \(error)")
                            }
                        }
                    }
                )
            }
        }
    }
}


#Preview {
    BrowseQuestionsView()
}
