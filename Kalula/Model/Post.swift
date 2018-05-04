//
//  Post.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct Post {
    
    
    
    var id: String?
    var user: LocalUser
    var imageUrl: String
    var caption: String
    var creationDate: Date
    var isLiked: Bool = false
    
    init(withUser user: LocalUser, andDictionary dictionary: [String: Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
        let timeSince1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: timeSince1970)
    }
}

extension Post: Equatable {
    static func ==(_ lhs: Post, _ rhs: Post) -> Bool {
        return lhs.imageUrl == rhs.imageUrl
    }
}
