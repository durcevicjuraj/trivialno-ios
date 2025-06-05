//
//  ProfileViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import Foundation
import SwiftUI            
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileViewModel: ObservableObject {

    func uploadProfileImage(_ image: UIImage, userManager: UserManager) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let ref = Storage.storage().reference().child("profileImages/\(uid).jpg")

        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                return
            }

            ref.downloadURL { url, error in
                if let url = url {
                    let newUrlString = url.absoluteString

                    // Update Firestore
                    Firestore.firestore().collection("users")
                        .document(uid)
                        .updateData(["profileImageUrl": newUrlString]) { error in
                            if let error = error {
                                print("❌ Failed to update Firestore URL: \(error.localizedDescription)")
                                return
                            }

                            // 🔁 Update the local UserManager
                            DispatchQueue.main.async {
                                userManager.currentUser?.profileImageUrl = newUrlString
                            }

                            print("✅ Profile image URL updated.")
                        }
                }
            }
        }
    }


}
