//
//  UserProfileViewController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class UserProfileViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "User6666"
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        let uid = Auth.auth().currentUser.unwrap(debug: "No Current User").uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            let name = dictionary["username"] as? String
            self.navigationItem.title = name.unwrap()
            
        }) { (error) in
            Toast(text: error.localizedDescription).show()
        }
    }
}
