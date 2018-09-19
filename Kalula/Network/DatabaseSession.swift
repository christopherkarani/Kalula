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
    case transaction
    case noob(DataSnapshot)
}


/// A Request Object That holds all the information We need to make a database Request

struct DatabaseRequest {
    var task: DatabaseTask
    var ref: DatabaseReference
}


final class DatabseSession {
    let service = Database.database()
}

extension DatabseSession {
    func query(request: DatabaseRequest, completion: @escaping (Result<DataSnapshot, SessionError>) -> () ) {
        
    }
}


//enum DatabaseQuery {
//    typealias UserCredentials = [AnyHashable: Any]
//    
//    case createUser(credentials: UserCredentials)
//}
//
//extension DatabaseQuery {
//    struct Referance {
//    
//        static let users: DatabaseReference = Database.database().reference().child("users")
//    }
//}
//
//final class DatabaseSession {    
//
//}
//
//enum Referance {
//    case users
//    
//    var service : DatabaseReference {
//        return Database.database().reference()
//    }
//}
//
//extension Referance {
//    var ref: DatabaseReference {
//        switch self {
//        case .users:
//            return service.child("users")
//    }
//}


//extension DatabaseSession {
//    func database(query: DatabaseQuery, ref: Referance) {
//        switch query {
//        case let .createUser(credentials):
//           updateChildValues(credentials)
//        }
//    }
//}
