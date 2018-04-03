//
//  FDUser.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 12/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

protocol LocalUser {
    var uid             : String { get set }
    var profileImageUrl : String { get set }
    var userName        : String { get set }
    
    init(withUiD uid: String, dictionary: [String: Any])
}

//Firebase Database User
struct FDUser: LocalUser {
    var uid: String
    var profileImageUrl: String
    var userName: String
    
    init(withUiD uid: String, dictionary: [String : Any]) {
        self.uid = uid
        profileImageUrl = (dictionary["profileImageUrl"] as? String) ?? ""
        userName = (dictionary["username"] as? String) ?? ""
    }
}
