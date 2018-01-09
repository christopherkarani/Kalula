//
//  LoginNetworkService.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation
import Firebase

protocol LoginNetworkService {
    func authorizeUser(withEmail email: String, password: String, userName: String, profileImage: UIImage)
}

extension LoginNetworkService {
    public func authorizeUser(withEmail email: String, password: String, userName: String, profileImage: UIImage) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let data = UIImageJPEGRepresentation(profileImage, 0.3).unwrap(debug: "Data Error")
            
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_Images").child("\(fileName).jpg")
            storageRef.putData(data, metadata: nil, completion: { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
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
                            print(error.localizedDescription)
                            return
                        }
                        print("Succesfully added user to DB")
                    })
                }
                
            })
        }
    }
}

struct LoginManager: LoginNetworkService {}
