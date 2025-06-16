//
//  BrowseUsersView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//
import SwiftUI

struct BrowseUsersView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel = BrowseUsersViewModel()
    @State private var selectedUser: AppUser?

    var body: some View {
        NavigationView {
            let users = userManager.allUsers
            let countries = Array(Set(users.map { $0.country })).sorted()

            Form {
                Section(header: Text("filters")) {
                    TextField("searchUsername", text: $viewModel.searchText)

                    Picker("country", selection: $viewModel.selectedCountry) {
                        Text("all").tag(nil as String?)
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(Optional(country))
                        }
                    }

                    Picker("rank", selection: $viewModel.selectedRank) {
                        Text("All").tag(nil as UserRank?)
                        ForEach(UserRank.allCases, id: \.self) {
                            Text($0.rawValue).tag(Optional($0))
                        }
                    }

                    HStack {
                        Text("maxElo") + Text(": \(viewModel.eloRange.upperBound)")
                        Slider(value: Binding(get: {
                            Double(viewModel.eloRange.upperBound)
                        }, set: { new in
                            viewModel.eloRange = viewModel.eloRange.lowerBound...Int(new)
                            viewModel.applyFilters()
                        }), in: 0...1500)
                    }
                }

                Section(header: Text("Users")) {
                    ForEach(viewModel.filteredUsers, id: \.uid) { user in
                        HStack(spacing: 12) {
                            if let url = URL(string: user.profileImageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            }

                            VStack(alignment: .leading) {
                                HStack {
                                    Text(user.username).bold()
                                    Image(user.rank.imageName)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("\(user.elo)")
                                        .font(.caption)
                                        .foregroundStyle(user.rank.color)
                                }
                                Text("\(user.country.flagEmoji) \(user.country)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            selectedUser = user
                        }
                    }
                }
            }
            .navigationTitle("browseUsers")
            .onAppear {
                userManager.fetchAllUsers { _ in
                    viewModel.setUsers(userManager.allUsers)
                }
            }
        }
        .sheet(item: $selectedUser) { user in
            EditUserSheet(user: user) { updatedUser in
                userManager.updateUser(updatedUser) { result in
                    if case .success = result {
                        selectedUser = nil
                        viewModel.setUsers(userManager.allUsers) // update locally
                    }
                }
            }
        }
    }
}
