//
//  ContentView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 26.05.2025..
//

import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 32) {
            

            // Logo
            Image("trivialno-icon")
                .resizable()
                .foregroundStyle(.tint)
                .frame(width: 200, height: 200)

            // Form fields
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Username")
                        .foregroundColor(.black)
                    TextField("Username…", text: $username)
                        .textFieldStyle(PlainTextFieldStyle())
                    Divider()
                }

                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.black)
                    TextField("Email…", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                    Divider()
                }

                VStack(alignment: .leading) {
                    Text("Password")
                        .foregroundColor(.black)
                    SecureField("Password…", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                    Divider()
                }
            }
            .padding(.horizontal, 40)

            // Register Button
            Button("Register") {
                // Registration logic
            }
            .frame(width: 120, height: 44)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    RegisterView()
}
