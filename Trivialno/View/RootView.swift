//
//  RootView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 28.05.2025..
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        Group {
            if authManager.user != nil {
                ContentView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            if authManager.user != nil && userManager.currentUser == nil {
                userManager.fetchCurrentUser()
            }
        }
    }
}



#Preview {
    RootView()
        .environmentObject(AuthManager())
        .environmentObject(UserManager())
}
