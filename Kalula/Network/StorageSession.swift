//
//  StorageSession.swift
//  Kalula
//
//  Created by Chris Karani on 17/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Firebase

/// Handle Storage of Objects into FIrabse Storage
final class StorageSession {
    typealias StorageReferance = URL
    
    /// Firebase Storage Service
    let service = Storage.storage()
}

extension StorageSession {
    /// Storage Referances
    struct Ref {
        static let profileImages = Storage.storage().reference().child("profile_Images").child(randomFileName())
    }
    
    /// Generate Random File Name For Storage In FIrebase
    static func randomFileName() -> String {
        return "\(UUID().uuidString).jpg"
    }
    
    
    /// Store Image and give back a storage Reference Url
    func store(image: UIImage, completion: @escaping (StorageReferance) -> ()) {
         let data = UIImageJPEGRepresentation(image, 0.3).unwrap(debug: "Data Error")
        Ref.profileImages.putData(data, metadata: nil) { (metadata, error) in
            if let storageRef = metadata?.downloadURL() {
                completion(storageRef)
            }
        }
    }
}
