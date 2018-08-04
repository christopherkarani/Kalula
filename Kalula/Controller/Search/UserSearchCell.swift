//
//  UserSearchCell.swift
//  Kalula
//
//  Created by Chris Karani on 4/2/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit

class UserSearchCell: UICollectionViewCell {
    
    var user: LocalUser? {
        didSet {
            if let user = user {
                guard let profileImageUrl = URL(string: user.profileImageUrl) else { return }
                nameLabel.text = user.userName
                imageView.kf.setImage(with: profileImageUrl)
            }
        }
    }
    
    public var imageView: UIImageView = {
        let imView = UIImageView()
        imView.clipsToBounds = true
        imView.contentMode = .scaleAspectFill
        imView.layer.cornerRadius = 50 / 2 //width / 2
        imView.image = #imageLiteral(resourceName: "placeHolder")
        return imView
    }()
    
    public var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    fileprivate var seperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(seperatorView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
