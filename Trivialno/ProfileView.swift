//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 24) {

            Spacer().frame(height: 40)

            // Profile icon
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.purple)
                .background(Circle().fill(Color.purple.opacity(0.2)))
                .padding(.bottom, 4)

            // Username
            Text("Username")
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4))
                )

            // Highlighted Scores Button
           
                
                Label("Your best scores", systemImage: "checkmark")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
             

            // Score Entries
            VStack(spacing: 12) {
                ForEach(1...3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(index).")
                            .font(.headline)

                        HStack {
                            Text("Points:")
                            Spacer()
                            Text("Jokers used:")
                            Spacer()
                            Text("Date:")
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview{
    ProfileView()
}
