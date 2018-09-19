//
//  SessionError.swift
//  Kalula
//
//  Created by Chris Karani on 19/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation


/// Errors Throws During Session Operations
enum SessionError: Error {
    /// Throws Login Error With Firebase description
    case loginError(String)
    /// Throws Sign Up Error With Firebase description
    case signUpError(String)
    /// Throws An Error During uploading to Firbase Storage
    case uploadError(String)
    /// Throws an Error when updating Child values In Database
    case updateChildValuesError(String)
}
