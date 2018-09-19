//
//  StorageSession.swift
//  Kalula
//
//  Created by Chris Karani on 17/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit.UIImage
import FirebaseStorage
import Result


// MARK: - StorageTask
/// Represents the read/write methods of FirebaseStorage
public enum StorageTask {
    case upload(Data) // put
    case uploadFile(to: URL, StorageMetadata?) // putFile
    case downloadData(maxSize: Int64) // data
    case downloadToURL(URL) // write
    case downloadURL // downloadURL
    case downloadMetadata // metadata
    case update(StorageMetadata) // update
    case delete // delete
    
}

/// A struct containing all the information we need for a storage Request
struct StorageRequest {
    let task : StorageTask
    let ref  : StorageReference
}

/// Storage Referances
struct StoreRef {
    /// A location to store our profile Images
    static let profileImages = Storage.storage().reference().child("profile_Images").child(randomFileName())
    
    
    /// Generate Random File Name For Storage In FIrebase
    static func randomFileName() -> String {
        return "\(UUID().uuidString).jpg"
    }
}


/// Handle Storage of Objects into FIrabse Storage
protocol StorageSession {
    func store(request : StorageRequest, completion: @escaping (Result<URL,SessionError>) -> () ) -> StorageUploadTask?
}

extension StorageSession {

    
    /// Run a storage Tast
    @discardableResult
    func store(request : StorageRequest, completion: @escaping (Result<URL,SessionError>) -> () ) -> StorageUploadTask? {
        switch request.task {
        case let .upload(data):
            return request.ref.putData(data, metadata: nil) { (metadata, error) in
                guard error == nil, let url = metadata?.downloadURL() else {
                    let error = SessionError.uploadError(error!.localizedDescription)
                    completion(Result.init(error: error))
                    return
                }
                completion(Result(value: url))
            }
        default:
            return nil
        }
    }
}

