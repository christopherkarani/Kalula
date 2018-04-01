//
//  Post.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct Post {
    var user: LocalUser
    var imageUrl: String
    var caption: String
    
    init(withUser user: LocalUser, andDictionary dictionary: [String: Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
    }
}
