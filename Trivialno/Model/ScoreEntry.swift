//
//  ScoreEntry.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation

struct ScoreEntry: Codable {
    var score: Int
    var date: Date
    var jokersUsed: Int
    var questionsAnswered: Int
}

