//
//  EditUserSheet.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import SwiftUI

struct EditUserSheet: View {
    @State var user: AppUser
    var onSave: (AppUser) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("basicInfo")) {
                    TextField("Username", text: $user.username)

                    TextField("Country", text: $user.country)

                    DatePicker("Date of Birth", selection: $user.dateOfBirth, displayedComponents: .date)
                }

                Section(header: Text("gameInfo")) {
                    Picker("rank", selection: $user.rank) {
                        ForEach(UserRank.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }

                    Stepper("ELO: \(user.elo)", value: $user.elo, in: 0...5000)

                    Picker("type", selection: $user.type) {
                        ForEach(UserType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                }

                Section {
                    Button("saveChanges") {
                        onSave(user)
                    }
                }
            }
            .navigationTitle("editUser")
        }
    }
}
