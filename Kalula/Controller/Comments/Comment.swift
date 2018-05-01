//
//  File.swift
//  Kalula
//
//  Created by Chris Karani on 4/19/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct Comment {
    var user : LocalUser
    var dateCreated: String
    var text : String
    var uid: String
    
    init(_ user: LocalUser, andDict dictionary: [String : Any]) {
        self.user = user
        dateCreated = dictionary["dateCreated"] as? String ?? ""
        text = dictionary["text"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
}
