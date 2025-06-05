//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State var errorMessage = ""
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userManager: UserManager
    
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 40) {
                
                Image("trivialno-icon")
                    .resizable()
                    .foregroundStyle(.tint)
                    .frame(width: 200, height: 200)
                
                // Email and password fields
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("emailAuth")
                        TextField("emailAuth", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.top, 2)
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("passwordAuth")
                        SecureField("passwordAuth", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.top, 2)
                        Divider()
                    }
                    
                    
                }
                .padding(.horizontal, 40)
                
                // Log in button
                Button("Login") {
                    if(email.isEmpty || password.isEmpty){
                        errorMessage = NSLocalizedString("fieldsEmptyError", comment: "")
                        print("Invalid login.")
                    }
                    else{
                        authManager.login(email: email, password: password) { success in
                            if !success {
                                errorMessage = authManager.authError ?? NSLocalizedString("unknownLoginError", comment: "")
                                print("Firebase login failed.")
                            }
                            else{
                                userManager.fetchCurrentUser()
                            }
                        }
                    }
                }
                .frame(width: 100, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .opacity(errorMessage.isEmpty ? 0 : 1) // 🔑 keeps the space
                    Spacer()
                }

                
                Spacer()
                
                Text("noAccount")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                
                // Register button
                NavigationLink(destination: RegisterView()) {
                    Text("register")
                        .underline()
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 44)
                }
                .cornerRadius(10)
                
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

}


#Preview {
    LoginView()
        .environmentObject(AuthManager())
        .environmentObject(UserManager())
}
