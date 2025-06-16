//
//  AddQuestionViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import Foundation
import FirebaseFirestore

class AddQuestionViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func addQuestion(_ question: Question, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "id": question.id,
            "category": question.category.rawValue,
            "type": question.type.rawValue,
            "difficulty": question.difficulty.rawValue,
            "question": question.question,  // [String: String]
            "correct_answer": question.correct_answer,  // [String: String]
            "all_answers": question.all_answers,  // [String: [String]]
            "points": question.points
        ]
        
        db.collection("questions").document(question.id).setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


