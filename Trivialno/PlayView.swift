//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct PlayView: View {
    var body: some View {
        VStack(spacing: 24) {
            
        
            Spacer()

            // Question Card
            VStack(alignment: .leading, spacing: 8) {
                Text("Question N.")
                    .font(.headline)

                Text("Tekst tekst tekst tekst tekst tekst tekst")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal)

            // Power-up Buttons
            HStack(spacing: 32) {
                ForEach(["star.fill", "key.fill", "bolt.fill"], id: \.self) { icon in
                    Button(action: {
                        // Tool action
                    }) {
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.gray))
                    }
                }
            }

            Spacer()
            // Answer Buttons
            VStack(spacing: 16) {
                ForEach(["A. Answer", "B. Answer", "C. Answer", "D. Answer"], id: \.self) { answer in
                    Button(action: {
                        // Answer action
                    }) {
                        Text(answer)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 14)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // Score Box
            VStack(spacing: 4) {
                Text("Points: N")
                Text("Your best: N")
                Text("World best: N")
            }
            .font(.subheadline)
            .padding()

            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    PlayView()
}
