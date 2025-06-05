//
//  AppUser.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation

enum UserType: String, Codable {
    case player = "Player"
    case admin = "Admin"
}

enum UserRank: String, Codable, CaseIterable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case master = "Master"
    case quizmaster = "Quizmaster"

    var localizedName: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}



struct AppUser: Codable, Identifiable {
    var id: String { uid } // Computed only
    var uid: String // For Firebase Authentication
    var username: String
    var dateOfBirth: Date
    var country: String
    var profileImageUrl: String
    var rank: UserRank
    var elo: Int
    var bestScores: [ScoreEntry]
    var friends: [String]
    var type: UserType // "Player" or "Admin"
}

