//
//  LoginNetworkService.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation
import Firebase
import Toaster

protocol LoginNetworkService {
    func authorizeUser(withEmail email: String, password: String, userName: String, profileImage: UIImage, completion: @escaping(() -> Void))
}

extension LoginNetworkService {
    internal func authorizeUser(withEmail email: String, password: String, userName: String, profileImage: UIImage, completion: @escaping(() -> Void) ) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if let error = error {
                Toast(text: error.localizedDescription).show()
                return
            }
            
            let data = UIImageJPEGRepresentation(profileImage, 0.3).unwrap(debug: "Data Error")
            
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_Images").child("\(fileName).jpg")
            storageRef.putData(data, metadata: nil, completion: { (metaData, error) in
                
                // handle error
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                    return
                }
                
                if let profileImageUrl = metaData?.downloadURL() {
                    
                    let userCredentials = ["username": userName,
                                           "profileImageUrl": profileImageUrl.absoluteString]
                    
                    let uid = user.unwrap().uid
                    let ref = Database.database().reference().child("users")
                    
                    let values = [uid: userCredentials]
                    ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            Toast(text: error.localizedDescription).show()
                            return
                        }
                        completion()
                    })
                }
                
            })
        }
    }
}

struct LoginManager: LoginNetworkService {}
