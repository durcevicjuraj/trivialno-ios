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
                        Text("Email")
                        TextField("Email...", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.top, 2)
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                        SecureField("Password…", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.top, 2)
                        Divider()
                    }
                }
                .padding(.horizontal, 40)
                
                // Log in button
                Button("Log in") {
                    // Action
                }
                .frame(width: 100, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
                
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                    .font(.caption)

                
                // Register button
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
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
}
