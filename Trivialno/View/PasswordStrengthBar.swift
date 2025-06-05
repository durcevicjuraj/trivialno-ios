//
//  PasswordStrengthBar.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import SwiftUI

struct PasswordStrengthBar: View {
    var password: String

    private var strength: Double {
        let rulesPassed = [
            password.range(of: #".{8,}"#, options: .regularExpression) != nil,
            password.range(of: #"[A-Z]"#, options: .regularExpression) != nil,
            password.range(of: #"[a-z]"#, options: .regularExpression) != nil,
            password.range(of: #"\d"#, options: .regularExpression) != nil,
            password.range(of: #"[!@#$%^&*(),.?\":{}|<>]"#, options: .regularExpression) != nil
        ].filter { $0 }.count

        return Double(rulesPassed) / 5.0
    }

    private var color: Color {
        switch strength {
        case 1...: return .green
        case 0.8..<1: return .yellow
        case 0.6..<0.8: return .orange
        case 0.4..<0.6: return Color(red: 1.0, green: 0.25, blue: 0.0)
        case 0.2..<0.4:return .red
        default: return .gray

        }
    }


    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 6)
                .foregroundColor(.gray.opacity(0.3))
                .cornerRadius(3)

            Rectangle()
                .frame(width: CGFloat(strength) * 200, height: 6)
                .foregroundColor(color)
                .cornerRadius(3)
                .animation(.easeInOut(duration: 0.3), value: strength)
        }
        .frame(width: 200)
    }
}

