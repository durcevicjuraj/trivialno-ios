//
//  Question.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import Foundation

enum QuestionDifficulty: String, Codable, CaseIterable {
    case easy, medium, hard

    var localizedName: String {
        NSLocalizedString(rawValue, comment: "")
    }
}

enum QuestionCategory: String, Codable, CaseIterable {
    case general, geography, science, history, popCulture,
         sports, art, literature, music, cooking, film, videoGames,
         animals, technology, biology, medicine, chemistry, physics,
         religion

    var localizedName: String {
        NSLocalizedString(rawValue, comment: "")
    }
}

enum QuestionType: String, Codable, CaseIterable {
    case multipleChoice

    var localizedName: String {
        NSLocalizedString(rawValue, comment: "")
    }
}


struct Question: Codable, Identifiable {
    var id: String = UUID().uuidString
    var category: QuestionCategory
    var type: QuestionType
    var difficulty: QuestionDifficulty
    
    var question: [String: String]           // e.g. ["en": "What is ...", "hr": "Koji je ..."]
    var correct_answer: [String: String]     // e.g. ["en": "Paris", "hr": "Pariz"]
    var all_answers: [String: [String]]      // e.g. ["en": [...], "hr": [...]]

    var points: Int {
        switch difficulty {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 30
        }
    }
}

