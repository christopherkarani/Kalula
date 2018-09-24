//
//  SessionError.swift
//  Kalula
//
//  Created by Chris Karani on 19/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

enum AuthError {
    case signUp(desc: String)
    case signIn(desc: String)
    case signOut(desc: String)
    case createUser(desc: String)
}

extension AuthError {
    var title : String {
        switch self {
        case .signUp:
            return "Sign Up Error"
        case .signIn:
            return "Sign In Error"
        case .signOut:
            return "Sign Out Error"
        case .createUser:
            return "Create User Error"
        }
    }
    
    var desc : String {
        switch self {
        case let .signUp(desc): return desc
        case let .signIn(desc): return desc
        case let .signOut(desc): return desc
        case let .createUser(desc): return desc
        }
    }
}


/// Errors Throws During Session Operations
enum SessionError: Error {
    /// Throws Login Error With Firebase description
    case AuthError(desc: AuthError)
    /// Throws Sign Up Error With Firebase description
    case signUpError(desc: String)
    /// Throws An Error During uploading to Firbase Storage
    case uploadError(desc: String)
    /// Throws an Error when updating Child values In Database
    case databaseError(desc: String)
}


extension SessionError: Alert {
    var error: Error {
        return self
    }
    
    /**
     The Title of the Error
     */
    var title: String {
        switch self {
        case .AuthError(let error):
            return error.title
        case .signUpError:
            return "Sign Up Error"
        case .uploadError:
            return "Upload Error"
        case .databaseError:
            return "Database Error"
        }
    }
    
    /**
     The Description of the Error
     */
    var description: String {
        switch self {
        case let .AuthError(error):
            return error.desc
        case let .signUpError(desc):
            return desc
        case let .uploadError(desc):
            return desc
        case let .databaseError(desc):
            return desc
        }
    }
    
}


