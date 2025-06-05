//
//  AuthViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 28.05.2025..
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var authError: String?

    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authError = error.localizedDescription
                    completion(false)
                } else {
                    self.user = result?.user
                    completion(true)
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authError = self.mapAuthError(error)
                    completion(false)
                } else {
                    self.user = result?.user
                    self.authError = nil
                    completion(true)
                }
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        user = nil
    }
    
    private func mapAuthError(_ error: Error?) -> String {
        guard let error = error as NSError? else {
            return NSLocalizedString("error_unknown", comment: "")
        }

        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue,
             AuthErrorCode.userNotFound.rawValue,
             AuthErrorCode.wrongPassword.rawValue:
            return NSLocalizedString("invalidCredentialsError", comment: "")
        default:
            return NSLocalizedString("unknownLoginError", comment: "")
        }
    }

    
    func deleteCurrentUser(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        user.delete { error in
            if let error = error {
                print("❌ Failed to delete user: \(error.localizedDescription)")
                completion(false)
            } else {
                print("🗑️ User deleted from Firebase Auth")
                self.user = nil
                completion(true)
            }
        }
    }

}

