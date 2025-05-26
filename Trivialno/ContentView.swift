//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack (spacing: 15){
                Image("trivialno-icon")
                    .resizable()
                    .foregroundStyle(.tint)
                    .frame(width: 200, height: 200)
                
                Text("Did you know?")
                    .fontWeight(.bold)
                Text("Octopuses have three hearts.")
                
                
                Spacer()
                
                NavigationLink(destination: PlayView()) {
                    Text("Play")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: DailyView()) {
                    Text("Daily Question")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ProfileView()) {
                    Text("Profile")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: LeaderboardsView()) {
                    Text("Leaderboards")
                        .frame(width: 200, height: 35)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
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
}
