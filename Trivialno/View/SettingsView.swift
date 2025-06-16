import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationStack {
            List {
                // Accessibility
                NavigationLink(destination: EmptyView()) {
                    Label("accessibility", systemImage: "figure.wave")
                }
                
                // Profile Settings
                NavigationLink(destination: ProfileSettingsView()) {
                    Label("profileSettings", systemImage: "person.crop.circle")
                }

                // Admin Panel (only for admins)
                if userManager.currentUser?.type == .admin {
                    NavigationLink(destination: AdminView()) {
                        Label("adminPanel", systemImage: "gearshape.2")
                    }
                }

                // Logout
                Button(role: .destructive) {
                    authManager.logout()
                    print("User logged out")
                } label: {
                    Label("logout", systemImage: "arrow.right.square")
                }
            }
            .navigationTitle("settings")
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
        scores: [],
        friends: [],
        type: .admin
    )

    
    return SettingsView()
        .environmentObject(AuthManager())
        .environmentObject(mockUserManager)
    
}
