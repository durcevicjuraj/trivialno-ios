import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authManager: AuthManager

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                // Accessibility
                NavigationLink(destination: ContentView()) {
                    Text("accessibility")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // Admin
                NavigationLink(destination: ContentView()){
                    Text("admin")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // Profile Settings
                NavigationLink(destination: ContentView()) {
                    Text("profileSettings")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // Log out (optional: trigger logic instead of navigation)
                Button(action: {
                    // Your logout logic here
                    authManager.logout()
                    print("User logged out")
                }) {
                    Text("logout")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}
