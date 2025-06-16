//
//  ScoreEntry.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation

struct ScoreEntry: Codable, Identifiable {
    var id: String = UUID().uuidString
    var score: Int
    var date: Date
    var used5050: Bool
    var usedSkip: Bool
    var usedDP: Bool
    var questionsAnswered: Int
}

