//
//  UserViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserManager: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var currentUser: AppUser?


    /// Creates a new user document in Firestore under the `users` collection.
    func createUserInDatabase(firebaseUser: User, username: String, dateOfBirth: Date, country: String, completion: @escaping (Bool) -> Void) {
        let newUser = AppUser(
            uid: firebaseUser.uid,
            username: username,
            dateOfBirth: dateOfBirth,
            country: country,
            profileImageUrl: "gs://trivialno-e3b8a.firebasestorage.app/default-avatar.png",
            rank: .bronze,               // Default rank
            elo: 0,                   // Starting elo
            bestScores: [],
            friends: [],
            type: .player                // Default user type
        )

        do {
            try db.collection("users")
                .document(firebaseUser.uid)
                .setData(from: newUser) { error in
                    if let error = error {
                        print("❌ Firestore error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ User saved to Firestore")
                        completion(true)
                    }
                }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Bool) -> Void = { _ in }) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ No logged-in user.")
            completion(false)
            return
        }

        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("❌ Error fetching user: \(error.localizedDescription)")
                completion(false)
                return
            }

            do {
                if let document = document, document.exists {
                    self.currentUser = try document.data(as: AppUser.self)
                    print("✅ User loaded")
                    completion(true)
                } else {
                    print("⚠️ User document does not exist")
                    completion(false)
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

}

