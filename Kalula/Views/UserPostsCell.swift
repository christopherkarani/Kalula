//
//  UserPostsCell.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class UserPostsCell: UICollectionViewCell {
    
    var post : Post? {
        didSet {
            if let post = post {
                let imageUrl = URL(string: post.imageUrl)
                DispatchQueue.main.async {
                    self.imageView.kf.indicatorType = .activity
                    self.imageView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2))])
                }
                
            }
        }
    }
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

