//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @State private var showImagePicker = false
    @State private var showConfirmation = false
    @State private var selectedImage: UIImage?
    
    @StateObject private var profileVM = ProfileViewModel()

    
    var body: some View {
        VStack(spacing: 24) {

            Spacer().frame(height: 40)

            
            Button {
                showConfirmation = true
            } label: {
                if let user = userManager.currentUser,
                   let url = URL(string: user.profileImageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
            }
            .alert("Upload a new profile picture?", isPresented: $showConfirmation) {
                Button("Choose from Library", role: .none) {
                    showImagePicker = true
                }
                Button("Cancel", role: .cancel) {}
            }


            // Username
            Text(userManager.currentUser!.username)
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
        .sheet(isPresented: $showImagePicker) {
            ImagePickerSheet(selectedImage: $selectedImage)
                .onDisappear {
                    if let image = selectedImage {
                        profileVM.uploadProfileImage(image, userManager: userManager)
                    }
                }
        }
    }
}

#Preview {
    let mockUserManager = UserManager()
    mockUserManager.currentUser = AppUser(
        uid: "12345",
        username: "TestUser",
        dateOfBirth: Date(),
        country: "DE",
        profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/trivialno-e3b8a.firebasestorage.app/o/default-avatar.png?alt=media&token=d0d18e6c-5cbb-4474-aaa7-376eb549f7ad", // or use any placeholder URL
        rank: .silver,
        elo: 1350,
        bestScores: [],
        friends: [],
        type: .player
    )

    return ProfileView()
        .environmentObject(mockUserManager)
}
