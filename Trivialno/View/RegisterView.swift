import SwiftUI




struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var dateOfBirth = Date()
    @State private var selectedCountry = Locale.current.region?.identifier ?? "US"

    @State private var showCountryPicker = false
    @State private var showDatePicker = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userManager: UserManager
    @StateObject private var registerVM = RegisterViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                Spacer(minLength: 40)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("usernameAuth")
                        TextField("usernameAuth", text: $username)
                            .textFieldStyle(PlainTextFieldStyle())
                        Divider()
                    }

                    VStack(alignment: .leading) {
                        Text("emailAuth")
                        TextField("emailAuth", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                        Divider()
                    }

                    VStack(alignment: .leading) {
                        Text("passwordAuth")
                        SecureField("passwordAuth", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                        Divider()
                        
                        PasswordStrengthBar(password: password)

                    }
                    

                    VStack(alignment: .leading) {
                        Text("confirmPasswordAuth")
                        SecureField("confirmPasswordAuth", text: $confirmPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                        Divider()
                        
                        PasswordStrengthBar(password: confirmPassword)

                    }

                    VStack(alignment: .leading, spacing: 8) {
                        DatePicker("dateOfBirth", selection: $dateOfBirth, in: ...Date(),displayedComponents: .date)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("country")
                        Button(Locale.current.localizedString(forRegionCode: selectedCountry) ?? selectedCountry) {
                            showCountryPicker = true
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text(registerVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .opacity(registerVM.errorMessage.isEmpty ? 0 : 1) // 🔑 keeps the space
                        Spacer()
                    }


                }
                .padding(.horizontal, 40)

                Button("register") {
                    
                    registerVM.performRegistration(
                            username: username,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword,
                            dateOfBirth: dateOfBirth,
                            country: selectedCountry,
                            authManager: authManager,
                            userManager: userManager
                        ) { success in
                            if success {
                                userManager.fetchCurrentUser()
                                print("✅ Registered and saved to Firestore")
                                // Navigate or show success screen
                            } else {
                                print("❌ Registration failed")
                            }
                        }
                    
                }
                .frame(width: 120, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer(minLength: 40)
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(date: $dateOfBirth, isPresented: $showDatePicker)
        }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerSheet(selectedCountry: $selectedCountry, isPresented: $showCountryPicker)
        }

    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateOfBirth)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthManager())
        .environmentObject(UserManager())
}
