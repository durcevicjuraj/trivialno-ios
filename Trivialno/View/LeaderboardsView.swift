//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct LeaderboardsView: View {
    // Dummy leaderboard data
    struct Entry: Identifiable {
        let id = UUID()
        let username: String
        let points: Int
        let date: String
    }

    let entries: [Entry] = [
        .init(username: "Username", points: 120, date: "Date"),
        .init(username: "Username", points: 110, date: "Date"),
        .init(username: "Username", points: 95, date: "Date"),
        .init(username: "Username", points: 80, date: "Date")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(entries) { entry in
                    HStack {
                        // Avatar
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.purple)
                            .background(Circle().fill(Color.purple.opacity(0.2)))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.username)
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Text("Points: \(entry.points)")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.7))
                        }

                        Spacer()

                        Text(entry.date)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(Color(.systemBackground))
    }
}
