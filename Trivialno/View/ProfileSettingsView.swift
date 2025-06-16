//
//  ProfileSettingsView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel = ProfileSettingsViewModel()

    @State private var showConfirmation = false
    @State private var showImagePicker = false
    @State private var showCountryPicker = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("profileImage")) {
                    Button {
                        showConfirmation = true
                    } label: {
                        if let url = URL(string: userManager.currentUser?.profileImageUrl ?? "") {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .contentShape(Circle())
                        }
                    }
                    .listRowBackground(Color.clear)
                    .alert("uploadNewImageQuestion", isPresented: $showConfirmation) {
                        Button("chooseFromLibrary", role: .none) {
                            showImagePicker = true
                        }
                        Button("cancel", role: .cancel) {}
                    }
                }

                Section(header: Text("Info")) {
                    TextField("Username", text: $viewModel.username)

                    HStack {
                        Text("country")
                        Spacer()
                        Button {
                            showCountryPicker = true
                        } label: {
                            Text(viewModel.country.uppercased())
                        }
                    }

                    DatePicker("dateOfBirth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                }

                Section {
                    Button("saveChanges") {
                        viewModel.updateProfile(userManager: userManager) { success in
                            if success { dismiss() }
                        }
                    }
                }
            }
            .navigationTitle("profileSettings")
            .onAppear {
                if let user = userManager.currentUser {
                    viewModel.load(from: user)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerSheet(selectedImage: $viewModel.selectedImage)
            }
            .sheet(isPresented: $showCountryPicker) {
                CountryPickerSheet(
                    selectedCountry: $viewModel.country,
                    isPresented: $showCountryPicker
                )
            }
        }
    }
}
