//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//
import SwiftUI

struct LeaderboardsView: View {
    @StateObject private var viewModel = LeaderboardsViewModel()
    @EnvironmentObject var userManager: UserManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filters
                
                HStack {
                    Picker("", selection: $viewModel.selectedCountry) {
                        ForEach(viewModel.countries, id: \.self) { country in
                            Text(country == "All" ? "🌍 All" : "\(country.flagEmoji) \(country)")
                                .tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Sort by", selection: $viewModel.sortOption) {
                        ForEach(LeaderboardsViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                }

                // Leaderboard List
                List {
                    
                    // Leaderboard List
                    
                    ForEach(Array(viewModel.filteredUsers.enumerated()), id: \.element.id) { index, user in
                        HStack(alignment: .center) {
                            Text("\(index + 1).")
                                .frame(width: 30, alignment: .leading)

                            ZStack {
                                AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                                Image(user.rank.imageName)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .offset(x: -12, y: 20)
                            }

                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                    .foregroundColor(
                                        user.uid == userManager.currentUser?.uid ? .yellow : .primary
                                    )
                                Text("\(user.country.flagEmoji) \(user.country)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack {
                                Text("ELO")
                                Text("\(user.elo)")
                                    .foregroundStyle(user.rank.color)
                            }
                            .frame(width: 60)

                            VStack {
                                Text("Best")
                                Text("\(viewModel.bestScore(for: user))")
                            }
                            .frame(width: 60)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? Color.darkBG.opacity(0.75) : Color.lightBG.opacity(0.75))
                            }
                        )
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("leaderboards")
            .background(AdaptiveBackgroundView())
        }
        .onChange(of: viewModel.selectedCountry) { _, _ in
            viewModel.applyFilters()
        }
        .onChange(of: viewModel.sortOption) { _, _ in
            viewModel.applyFilters()
        }
    }
}
