//
//  SendComment.swift
//  Kalula
//
//  Created by Chris Karani on 4/19/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct SendComment: CustomStringConvertible {
    var text: String
    var dateCreated: Double
    var uid: String
    
    var description: String {
        return "Text: \(text), \n createdOn:\(dateCreated), \n sentBy: \(uid)"
    }
}
