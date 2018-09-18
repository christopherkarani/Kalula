//
//  AuthSession.swift
//  Kalula
//
//  Created by Chris Karani on 17/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import FirebaseAuth

enum AuthError : Error {
    /// Throws Login Error With Firebase description
    case loginError(String)
    /// Throws Sign Up Error With Firebase description
    case signUpError(String)
}

enum Authentication {
    /// Create a User In Firbebase
    case createUser(email: String, password: String)
    
    /// Sign in a user using email and password from Firebase
    case login(email: String, password: String)
}


/// An Object to handle Authentication Sessions
final class AuthSession  {
    var service = Auth.auth()
    
    static var user: User? {
        return Auth.auth().currentUser
    }
}

extension AuthSession {
    /// Action Function that authenticates user and throws an error closure
    func user(authentication: Authentication, completion: @escaping (Error?) throws -> () ) {
        switch authentication {
        case let .createUser(email, password):
            service.createUser(withEmail: email, password: password) { (_ , error) in
                try! completion(error)
            }
        case let .login(email, password):
            service.signIn(withEmail: email, password: password) { (_ , error) in
                try! completion(error)
            }
        }
    }
}
