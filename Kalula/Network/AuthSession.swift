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
final class AuthSession  {
    private var service = Auth.auth()

    
    static var user: User? {
        return Auth.auth().currentUser
    }
}

extension AuthSession {

    
    /// Action Function that authenticates user and throws an error closure
    func user(authentication: Authentication, completion: @escaping (Result<User, SessionError>) -> () ) {
        switch authentication {
        case let .createUser(email, password):
            service.createUser(withEmail: email, password: password) { (user , error) in
                guard error == nil, let currentUser = user else {
                    let authError = SessionError.signUpError(error!.localizedDescription)
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        case let .login(email, password):
            service.signIn(withEmail: email, password: password) { (user , error) in
                guard error == nil, let currentUser = user else {
                    let authError = SessionError.loginError(error!.localizedDescription)
                    completion(Result(error: authError))
                    return
                }
                
                completion(Result(value: currentUser))
            }
        }
    }
}
