//
//  ContentViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import Foundation
import FirebaseFirestore

class ContentViewModel: ObservableObject {
    @Published var dailyFact: DailyFact?

    private let db = Firestore.firestore()

    init() {
        fetchRandomFact()
    }

    func fetchRandomFact() {
        db.collection("dailyFacts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching dailyFacts: \(error)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            let facts: [DailyFact] = documents.compactMap { doc in
                guard let text = doc.data()["text"] as? [String: String] else { return nil }
                return DailyFact(id: doc.documentID, text: text)
            }

            DispatchQueue.main.async {
                self.dailyFact = facts.randomElement()
            }
        }
    }

    func localizedFact(for locale: String) -> String {
        dailyFact?.text[locale] ?? dailyFact?.text["en"] ?? "Did you know?"
    }
}


