//
//  AppUser.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation
import SwiftUICore

enum UserType: String, Codable, CaseIterable {
    case player = "Player"
    case admin = "Admin"
}

enum UserRank: String, Codable, CaseIterable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case quizmaster = "Quizmaster"

    var localizedName: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
    
    var imageName: String {
        switch self {
        case .bronze: return "Bronze"
        case .silver: return "Silver"
        case .gold: return "Gold"
        case .platinum: return "Platinum"
        case .diamond: return "Diamond"
        case .quizmaster: return "Quizmaster"
        }
    }
    
    var color: Color {
        switch self {
        case .bronze: return Color.bronze
        case .silver: return Color.silver
        case .gold: return Color.gold
        case .platinum: return Color.platinum
        case .diamond: return Color.diamond
        case .quizmaster: return Color.quizmaster
        }
    }
}



struct AppUser: Codable, Identifiable {
    var id: String { uid } // Computed only
    var uid: String
    var username: String
    var dateOfBirth: Date
    var country: String
    var profileImageUrl: String
    var rank: UserRank
    var elo: Int
    var scores: [ScoreEntry]
    var friends: [String]
    var type: UserType
}

