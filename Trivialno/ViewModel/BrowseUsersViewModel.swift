//
//  BrowseUsersViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import Foundation

class BrowseUsersViewModel: ObservableObject {
    @Published var filteredUsers: [AppUser] = []

    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    @Published var selectedCountry: String? = nil {
        didSet { applyFilters() }
    }

    @Published var selectedRank: UserRank? = nil {
        didSet { applyFilters() }
    }
    
    @Published var eloRange: ClosedRange<Int> = 0...1500

    private var allUsers: [AppUser] = []

    func setUsers(_ users: [AppUser]) {
        self.allUsers = users
        applyFilters()
    }

    func applyFilters() {
        filteredUsers = allUsers.filter { user in
            let matchesSearch = searchText.isEmpty || user.username.lowercased().contains(searchText.lowercased())
            let matchesCountry = selectedCountry == nil || user.country == selectedCountry
            let matchesRank = selectedRank == nil || user.rank == selectedRank
            let matchesElo = eloRange.contains(user.elo)
            return matchesSearch && matchesCountry && matchesRank && matchesElo
        }
    }
}
