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

/// A structure holding all the information we need for an Auth Request
struct AuthRequest {
    let task: Authentication
    let authService: Auth
}

extension AuthRequest {
    init(task: Authentication) {
        self.task = task
        self.authService = Session.authService
    }
}

/// An Object to handle Authentication Sessions

protocol  AuthSession {
    func user(authRequest: AuthRequest, completion: @escaping (Result<User, SessionError>) -> () )
}


extension AuthSession {
    /// Action Function that authenticates user and throws an error closure
    func user(authRequest: AuthRequest, completion: @escaping (Result<User, SessionError>) -> () ) {
        switch authRequest.task {
        case let .createUser(email, password):
            authRequest.authService.createUser(withEmail: email, password: password) { (user , error) in
                guard error == nil, let currentUser = user else {
                    let authError = SessionError.signUpError(error!.localizedDescription)
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        case let .login(email, password):
            authRequest.authService.signIn(withEmail: email, password: password) { (user , error) in
                guard error == nil , let currentUser = user else {
                    let authError = SessionError.loginError(error!.localizedDescription)
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        }
    }
}



