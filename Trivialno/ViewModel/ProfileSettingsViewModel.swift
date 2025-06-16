//
//  ProfileSettingsViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 08.06.2025..
//

import Foundation
import SwiftUI
import FirebaseStorage

class ProfileSettingsViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var country: String = ""
    @Published var selectedImage: UIImage? = nil

    private let storage = Storage.storage()

    func load(from user: AppUser) {
        self.username = user.username
        self.dateOfBirth = user.dateOfBirth
        self.country = user.country
    }

    func updateProfile(userManager: UserManager, completion: @escaping (Bool) -> Void) {
        guard var user = userManager.currentUser else {
            completion(false)
            return
        }

        user.username = username
        user.dateOfBirth = dateOfBirth
        user.country = country

        if let image = selectedImage {
            uploadImage(image, for: user.uid) { result in
                switch result {
                case .success(let url):
                    user.profileImageUrl = url.absoluteString
                    userManager.currentUser = user
                    userManager.updateCurrentUserInDB()
                    completion(true)
                case .failure(let error):
                    print("❌ Image upload failed: \(error)")
                    completion(false)
                }
            }
        } else {
            userManager.currentUser = user
            userManager.updateCurrentUserInDB()
            completion(true)
        }
    }

    private func uploadImage(_ image: UIImage, for uid: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1)))
            return
        }

        let ref = storage.reference().child("profile_images/\(uid).jpg")
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                ref.downloadURL(completion: completion)
            }
        }
    }
}

