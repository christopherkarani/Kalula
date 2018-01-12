//
//  UserProfileHeader.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 10/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Sukari
import SnapKit
import Firebase
import Toaster
class UserProfileHeader: UICollectionViewCell {
    
    var user : LocalUser? {
        didSet {
            if let user = user {
                fetchImage(withUrlString: user.profileImageUrl, completion: { (image) in
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                    }
                })
            }
        }
    }
    
    let imageView = UIImageView().this {
        $0.backgroundColor = .magenta
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40 // half of the width
    }
    
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(20)
            $0.top.equalTo(snp.top).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
    }
    
    fileprivate func fetchImage(withUrlString urlString: String, completion: @escaping((UIImage) -> Void)) {
        let url = URL(string: urlString).unwrap(debug: "profile Image Url Error")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                Toast(text: error.localizedDescription).show()
            }
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
            
            }.resume()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


