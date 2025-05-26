//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct DailyView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 40)

            // Question card
            VStack(alignment: .leading, spacing: 8) {
                Text("Daily Question N.")
                    .font(.headline)
                    .foregroundColor(.black)

                Text("Tekst tekst tekst tekst tekst tekst tekst")
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(24)
            .padding(.horizontal)

            // Answer buttons
            VStack(spacing: 16) {
                ForEach(["A. Answer", "B. Answer", "C. Answer", "D. Answer"], id: \.self) { answer in
                    Button(action: {
                        // Answer action
                    }) {
                        Text(answer)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // Results box
            VStack(spacing: 12) {
                Text("How many people guessed today: N.")
                    .bold()
                Text("How many guessed correctly: N.")
                    .bold()
            }
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4))
            )
            .padding(.horizontal)

            Spacer(minLength: 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


#Preview{
    DailyView()
}
