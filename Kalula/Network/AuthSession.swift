//
//  AuthSession.swift
//  Kalula
//
//  Created by Chris Karani on 17/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import FirebaseAuth
import Result


enum Authentication {
    /// Create a User In Firbebase
    case createUser(email: String, password: String)
    
    /// Sign in a user using email and password from Firebase
    case login(email: String, password: String)
}

/// An Object to handle Authentication Sessions

protocol  AuthSession {
    func user(auth: Authentication, completion: @escaping (Result<User, SessionError>) -> () )
}


extension AuthSession {
    /// Action Function that authenticates user and throws an error closure
    /// Uses the session object to make the request
    func user(auth: Authentication, completion: @escaping (Result<User, SessionError>) -> () ) {
        switch auth {
        case let .createUser(email, password):
            Session.authService.createUser(withEmail: email, password: password) { (user , error) in
                guard error == nil, let currentUser = user else {
                    let authError = SessionError.AuthError(desc: .createUser(desc: error!.localizedDescription))
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        case let .login(email, password):
            Session.authService.signIn(withEmail: email, password: password) { (user , error) in
                guard error == nil , let currentUser = user else {
                    let authError = SessionError.AuthError(desc: .signIn(desc: error!.localizedDescription))
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        }
    }
}



