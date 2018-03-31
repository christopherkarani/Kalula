//
//  Post.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct Post {
    var imageUrl: String
    
    init(dictionary: [String: Any]) {
        imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
