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
    
    var body: some View {
        NavigationStack{
            VStack (spacing: 15){
                Image("trivialno-icon")
                    .resizable()
                    .foregroundStyle(.tint)
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                NavigationLink(destination: PlayView()) {
                    Text("play")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: DailyView()) {
                    Text("dailyQuestion")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ProfileView()) {
                    Text("profile")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: LeaderboardsView()) {
                    Text("leaderboards")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("settings")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                Spacer()
                Spacer()
                
            }.padding()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserManager())
}
