//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showImagePicker = false
    @State private var showConfirmation = false
    @State private var selectedImage: UIImage?
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            AdaptiveBackgroundView()

            VStack(spacing: 24) {
                Spacer().frame(height: 200)

                HStack {
                    VStack(spacing: 15) {
                        ZStack {
                            Button {
                                showConfirmation = true
                            } label: {
                                if let user = userManager.currentUser,
                                   let url = URL(string: user.profileImageUrl) {
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
                            .alert("uploadNewImageQuestion", isPresented: $showConfirmation) {
                                Button("chooseFromLibrary", role: .none) {
                                    showImagePicker = true
                                }
                                Button("cancel", role: .cancel) {}
                            }

                            Text(userManager.currentUser!.country.flagEmoji)
                                .font(.system(size: 40))
                                .offset(x: 0, y: 45)
                        }

                        Text(userManager.currentUser!.username)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? Color.darkBG: Color.lightBG)
                                        .stroke(colorScheme == .dark ? Color.white : Color.black)
                                )
                    }

                    VStack(spacing: 15) {
                        Image(userManager.currentUser!.rank.imageName)
                            .resizable()
                            .foregroundStyle(.tint)
                            .frame(width: 100, height: 100)
                            .offset(y: -10)

                        Text(String(userManager.currentUser!.elo))
                            .foregroundStyle(userManager.currentUser?.rank.color ?? .gray)
                            .fontWeight(.bold)
                    }
                }

                Text("bestScores")
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? Color.darkBG : Color.lightBG)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple.opacity(0.15))
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 12) {
                    if let topScores = userManager.currentUser?.scores.sorted(by: { $0.score > $1.score }).prefix(5) {
                        ForEach(Array(topScores.enumerated()), id: \.1.id) { index, score in
                            HStack {
                                Text("\(score.score) pts")
                                Spacer()
                                HStack(spacing: 10) {
                                    Spacer(minLength: 28)
                                    Image(systemName: "circle.lefthalf.filled.inverse")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(score.used5050 ? .green : .gray)

                                    Image(systemName: "arrowshape.right.circle")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(score.usedSkip ? .green : .gray)

                                    Image(systemName: "figure.american.football.circle")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(score.usedDP ? .green : .gray)

                                    Spacer(minLength: 0)
                                }
                                .frame(maxWidth: 100)
                                Spacer()
                                Text("\(viewModel.formatDate(score.date))")
                            }
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: 350)
                            .background(
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? Color.darkBG.opacity(0.75) : Color.lightBG.opacity(0.75))
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.purple.opacity(0.15))
                                }
                            )
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerSheet(selectedImage: $selectedImage)
                .onDisappear {
                    if let image = selectedImage {
                        viewModel.uploadProfileImage(image, userManager: userManager)
                    }
                }
        }
    }
}

#Preview {
    let mockUserManager: UserManager = {
        let manager = UserManager()
        manager.currentUser = AppUser(
            uid: "12345",
            username: "TestUser",
            dateOfBirth: Date(),
            country: "DE",
            profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/trivialno-e3b8a.firebasestorage.app/o/default-avatar.png?alt=media&token=d0d18e6c-5cbb-4474-aaa7-376eb549f7ad",
            rank: .quizmaster,
            elo: 1350,
            scores: [
                ScoreEntry(
                    id: "0",
                    score: 50,
                    date: Date(),
                    used5050: true,
                    usedSkip: false,
                    usedDP: true,
                    questionsAnswered: 5
                )
            ],
            friends: [],
            type: .player
        )
        return manager
    }()

    return ProfileView()
        .environmentObject(mockUserManager)
}


