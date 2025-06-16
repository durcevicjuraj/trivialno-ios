//
//  LeaderboardsViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 06.06.2025..
//

import Foundation
import FirebaseFirestore
import Combine

class LeaderboardsViewModel: ObservableObject {
    
    enum SortOption: String, CaseIterable {
        case elo = "ELO"
        case bestScore = "Best Score"
    }
    
    @Published var allUsers: [AppUser] = []
    @Published var filteredUsers: [AppUser] = []
    @Published var selectedCountry: String = "All"
    @Published var sortOption: SortOption = .elo
    @Published var countries: [String] = ["All"]

    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()

    init() {
        fetchUsers()
    }

    private func fetchUsers() {
        db.collection("users").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("❌ Error fetching users: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            do {
                let users = try documents.compactMap { try $0.data(as: AppUser.self) }
                DispatchQueue.main.async {
                    self?.allUsers = users
                    self?.countries.append(contentsOf: Set(users.map { $0.country }).sorted())
                    self?.applyFilters()
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
            }
        }
    }

    private func setupFiltering() {
        Publishers.CombineLatest3($selectedCountry, $sortOption, $allUsers)
            .sink { [weak self] _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }


    func applyFilters() {
        var users = allUsers

        if selectedCountry != "All" {
            users = users.filter { $0.country == selectedCountry }
        }

        switch sortOption {
        case .elo:
            users.sort { $0.elo > $1.elo }
        case .bestScore:
            users.sort { ($0.scores.map { $0.score }.max() ?? 0) > ($1.scores.map { $0.score }.max() ?? 0) }
        }
        
        print("🔁 Applying sort: \(sortOption), country: \(selectedCountry)")

        self.filteredUsers = users
    }

    func bestScore(for user: AppUser) -> Int {
        return user.scores.map { $0.score }.max() ?? 0
    }
}
