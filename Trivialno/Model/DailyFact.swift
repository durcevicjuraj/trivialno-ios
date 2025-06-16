//
//  DailyFact.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import Foundation

struct DailyFact: Codable, Identifiable {
    var id: String = UUID().uuidString
    var text: [String: String]           // e.g. ["en": "What is ...", "hr": "Koji je ..."]
}
