//
//  DatabaseSession.swift
//  Kalula
//
//  Created by Chris Karani on 19/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import FirebaseDatabase
import Result

// MARK: - DatabaseTask
/// Represents the read/write methods of Firebase
public enum DatabaseTask {
    case observe(DataEventType)
    case observeOnce(DataEventType)
    case setValue(Any?)
    case updateChildValues([AnyHashable: Any])
    case removeValue
}

struct DBRef {
    static let users : DatabaseReference = Database.database().reference().child("users")
}


/// A Request Object That holds all the information We need to make a database Request
struct DatabaseRequest {
    var task: DatabaseTask
    var ref: DatabaseReference
}

/// A Wrapper around FirbaseDatabse that handles actions related to read/write of Firabse Database
protocol DatabseSession {
    func query(request: DatabaseRequest, completion: @escaping (Result<DataSnapshot?, SessionError>) -> () )
}

extension DatabseSession {
    func query(request: DatabaseRequest, completion: @escaping (Result<DataSnapshot?, SessionError>) -> () ) {
        switch request.task {
        case let .updateChildValues(values):
            request.ref.updateChildValues(values)
            completion(Result(value: nil))
        default:
            return
        }
    }
}

