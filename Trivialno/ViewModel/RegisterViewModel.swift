//
//  RegisterViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
    func validateInputs(username: String, email: String, password: String, confirmPassword: String) -> Bool {
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = NSLocalizedString("fieldsEmptyError", comment: "")
            return false
        }

        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            errorMessage = NSLocalizedString("invalidEmailError", comment: "")
            return false
        }

        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=\-{}\[\]:;"'<>,.?/\\|`~]).{8,}$"#
        if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            errorMessage = NSLocalizedString("weakPasswordError", comment: "")
            return false
        }

        if password != confirmPassword {
            errorMessage = NSLocalizedString("passwordMismatchError", comment: "")
            return false
        }

        return true
    }

    func performRegistration(
        username: String,
        email: String,
        password: String,
        confirmPassword: String,
        dateOfBirth: Date,
        country: String,
        authManager: AuthManager,
        userManager: UserManager,
        completion: @escaping (Bool) -> Void
    ) {
        guard validateInputs(username: username, email: email, password: password, confirmPassword: confirmPassword) else {
            completion(false)
            return
        }

        errorMessage = ""

        authManager.register(email: email, password: password) { success in
            if success, let firebaseUser = Auth.auth().currentUser {
                userManager.createUserInDatabase(
                    firebaseUser: firebaseUser,
                    username: username,
                    dateOfBirth: dateOfBirth,
                    country: country
                ) { dbSuccess in
                    if dbSuccess {
                        completion(true)
                    } else {
                        authManager.deleteCurrentUser { deleted in
                            if deleted {
                                authManager.logout()
                            }
                            completion(false)
                        }
                    }
                }
            } else {
                self.errorMessage = authManager.authError ?? NSLocalizedString("error_unknown", comment: "")
                completion(false)
            }
        }
    }
}
