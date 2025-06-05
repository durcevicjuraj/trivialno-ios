//
//  TrivialnoApp.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct TrivialnoApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()
    @StateObject var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager) // Make it accessible everywhere
                .environmentObject(userManager)
        }
    }
}
