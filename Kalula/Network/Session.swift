//
//  Session.swift
//  Kalula
//
//  Created by Chris Karani on 19/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Result

final class Session {
    static let authService = Auth.auth()
    static let databaseService = Database.database()
    static let storageService = Storage.storage()
    
    var user: User?
    var storageMetaData = [StorageMetadata]()
}

/// Add Functionality
extension Session: AuthSession {}
extension Session: DatabseSession {}
extension Session: StorageSession {}
