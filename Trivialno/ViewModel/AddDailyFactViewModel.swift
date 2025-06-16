//
//  AddDailyFactViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import Foundation
import FirebaseFirestore

class AddDailyFactViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func addFact(_ fact: DailyFact, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [
            "text": fact.text,
            "id" : fact.id
        ]
        
        db.collection("dailyFacts").document(fact.id).setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

}
