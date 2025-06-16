//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel = ContentViewModel()
    
    @Environment(\.colorScheme) private var colorScheme

    
    var body: some View {
        NavigationStack{
            ZStack {
                AdaptiveBackgroundView()
                
                VStack(spacing: 24) {
                    
                    Spacer()
                    Spacer()
                    
                    Image("trivialno-logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Group {
                        Text("didYouKnow")
                            .font(.system(size: 25, weight: .bold))

                        Text(
                            viewModel.dailyFact?.text[Locale.current.language.languageCode?.identifier ?? "en"]
                            ?? viewModel.dailyFact?.text["en"]
                            ?? "Loading fact..."
                        )
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? Color.darkBG : Color.lightBG)
                            )
                        .font(.system(size: 16))
                    }
                    
                    
                    Group{
                        NavigationLink(destination: PlayView()) {
                            Label("play", systemImage: "play.fill")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .offset(y: -5)
                        }
                        .buttonStyle(MainMenuButtonStyle(foregroundColor: Color.playFG, backgroundColor: Color.playBG, cornerRadius: 10))
                        .frame(width: 250, height: 50)
                        
                        NavigationLink(destination: ProfileView()) {
                            Label("profile", systemImage: "person.fill")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .offset(y: -5)
                        }
                        .buttonStyle(MainMenuButtonStyle(foregroundColor: Color.profileFG, backgroundColor: Color.profileBG, cornerRadius: 10))
                        .frame(width: 250, height: 50)
                        
                        NavigationLink(destination: LeaderboardsView()) {
                            Label("leaderboards", systemImage: "trophy.fill")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .offset(y: -5)
                        }
                        .buttonStyle(MainMenuButtonStyle(foregroundColor: Color.leaderboardsFG, backgroundColor: Color.leaderboardsBG, cornerRadius: 10))
                        .frame(width: 250, height: 50)
                        
                        NavigationLink(destination: SettingsView()) {
                            Label("settings", systemImage: "gearshape.fill")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .offset(y: -5)
                        }
                        .buttonStyle(MainMenuButtonStyle(foregroundColor: Color.settingsFG, backgroundColor: Color.settingsBG, cornerRadius: 10))
                        .frame(width: 250, height: 50)
                    }
                 
                    Spacer(minLength: 300)

                }
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(UserManager())
}
