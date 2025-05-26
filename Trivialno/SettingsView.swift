import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                // Accessibility
                NavigationLink(destination: ContentView()) {
                    Text("Accessibility")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // Admin
                NavigationLink(destination: ContentView()){
                    Text("Admin")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // Profile Settings
                NavigationLink(destination: ContentView()) {
                    Text("Profile Settings")
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
                    print("User logged out")
                }) {
                    Text("Log out")
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
