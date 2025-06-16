//
//  BrowseQuestionsViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import Foundation
import FirebaseFirestore

class BrowseQuestionsViewModel: ObservableObject {
    @Published var allQuestions: [Question] = []
    @Published var filteredQuestions: [Question] = []

    @Published var selectedCategory: QuestionCategory? = nil
    @Published var selectedType: QuestionType? = nil
    @Published var selectedDifficulty: QuestionDifficulty? = nil
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }

    private var db = Firestore.firestore()

    init() {
        fetchQuestions()
    }
    
    func updateQuestion(_ question: Question, completion: @escaping (Result<Void, Error>) -> Void) {
        let id = question.id

        do {
            try db.collection("questions").document(id).setData(from: question) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.fetchQuestions()
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }


    func fetchQuestions() {
        db.collection("questions").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching questions: \(error)")
                return
            }

            self.allQuestions = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Question.self)
            } ?? []

            self.applyFilters()
        }
    }

    func applyFilters() {
        print("🔎 Filtering for category: \(selectedCategory?.rawValue ?? "nil")")

        filteredQuestions = allQuestions.filter { question in
            let matchesCategory = selectedCategory == nil || question.category == selectedCategory

            if !matchesCategory {
                print("⛔️ Rejected: \(question.category.rawValue) != \(selectedCategory?.rawValue ?? "nil")")
            }

            let matchesType = selectedType == nil || question.type == selectedType
            let matchesDifficulty = selectedDifficulty == nil || question.difficulty == selectedDifficulty
            let matchesSearch = searchText.isEmpty || question.question["en"]?.localizedCaseInsensitiveContains(searchText) == true

            return matchesCategory && matchesType && matchesDifficulty && matchesSearch
        }
    }
}
