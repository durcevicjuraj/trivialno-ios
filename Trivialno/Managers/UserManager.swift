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
    
    @Published var allUsers: [AppUser] = []

    /// Creates a new user document in Firestore under the `users` collection.
    func createUserInDatabase(firebaseUser: User, username: String, dateOfBirth: Date, country: String, completion: @escaping (Bool) -> Void) {
        let newUser = AppUser(
            uid: firebaseUser.uid,
            username: username,
            dateOfBirth: dateOfBirth,
            country: country,
            profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/trivialno-e3b8a.firebasestorage.app/o/default-avatar.png?alt=media&token=d0d18e6c-5cbb-4474-aaa7-376eb549f7ad",
            rank: .bronze,               // Default rank
            elo: 0,                   // Starting elo
            scores: [],
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
    
    func updateCurrentUserInDB() {
        guard let user = currentUser else { return }

        do {
            try db.collection("users")
                .document(user.uid)
                .setData(from: user, merge: true)
            print("✅ User updated in Firestore.")
        } catch {
            print("❌ Error updating user: \(error.localizedDescription)")
        }
    }
    
    
    /// Fetches all users for admin view
    func fetchAllUsers(completion: @escaping (Bool) -> Void = { _ in }) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching users: \(error.localizedDescription)")
                completion(false)
                return
            }

            self.allUsers = snapshot?.documents.compactMap { doc in
                try? doc.data(as: AppUser.self)
            } ?? []

            print("✅ Loaded \(self.allUsers.count) users.")
            completion(true)
        }
    }

    /// Updates a specific user (admin-level access)
    func updateUser(_ user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(user.uid).setData(from: user, merge: true) { error in
                if let error = error {
                    print("❌ Failed to update user: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("✅ Updated user: \(user.username)")
                    self.fetchAllUsers()  // Refresh after update
                    completion(.success(()))
                }
            }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }


}

