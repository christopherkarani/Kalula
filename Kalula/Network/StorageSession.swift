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

struct StorageRequest {
    let task : StorageTask
    let ref  : StorageReference
}


/// Handle Storage of Objects into FIrabse Storage
final class StorageSession {
    
    /// Firebase Storage Service
    let service = Storage.storage()
}

extension StorageSession {
    /// Storage Referances
    struct Ref {
        /// A location to store our profile Images
        static let profileImages = Storage.storage().reference().child("profile_Images").child(randomFileName())
    }
    
    /// Generate Random File Name For Storage In FIrebase
    static func randomFileName() -> String {
        return "\(UUID().uuidString).jpg"
    }
    
    /// Store Image and give back a storage Reference Url
    func store(image: UIImage, completion: @escaping (URL) -> ()) {
         let data = UIImageJPEGRepresentation(image, 0.3).unwrap(debug: "Data Error")
        Ref.profileImages.putData(data, metadata: nil) { (metadata, error) in
            if let storageRef = metadata?.downloadURL() {
                completion(storageRef)
            }
        }
    }
    
    
    /// Run a storage Tast
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

