//
//  HomeFeedCell.swift
//  Kalula
//
//  Created by Chris Karani on 3/31/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HomeFeedCell: UICollectionViewCell {
    
    var post : Post? {
        didSet {
            if let post = post {
                let imageUrl = URL(string: post.imageUrl)
                
                DispatchQueue.main.async {
                    self.imageView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2))])
                }
            }
        }
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 40 / 2 // half width
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.font = UIFont.helveticaBoldFont()
        return label
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
        
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        
        addSubview(userNameLabel)
        addSubview(profileImageView)
        addSubview(imageView)
        addSubview(optionsButton)
        
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(snp.width)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top)
        }
        
        optionsButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top)
            make.width.equalTo(44)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


