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
                
                userNameLabel.text = user.userName
            }
        }
    }
    
    var toolBarStackView: UIStackView!
    var statsLabelStackView: UIStackView!
    
    
    let gridButton = UIButton(type: .system).this {
        $0.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
    }
    
    let listButton = UIButton(type: .system).this {
        $0.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let bookmarkButton = UIButton(type: .system).this {
        $0.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let userNameLabel = UILabel().this {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    let postLabal = UILabel().this {
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let followersLabal = UILabel().this {
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let followingLabel = UILabel().this {
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let editProfileButton = UIButton(type: .system).this {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitle("Edit Profile", for: .normal)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 4
    }

    fileprivate func setupToolBar() {
        toolBarStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        toolBarStackView.distribution = .fillEqually
        toolBarStackView.axis = .horizontal
        addSubview(toolBarStackView)
        addSubview(userNameLabel)
        
        toolBarStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalTo(gridButton.snp.top)
            make.left.equalTo(snp.left).inset(12)
            make.right.equalTo(snp.right).inset(12)
        }
        
    }
    
    let imageView = UIImageView().this {
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
        
        statsLabelStackView = UIStackView(arrangedSubviews: [postLabal, followersLabal, followingLabel])
        addSubview(statsLabelStackView)
        statsLabelStackView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(12)
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        addSubview(editProfileButton)
        editProfileButton.snp.makeConstraints { (make) in
            make.top.equalTo(statsLabelStackView.snp.bottom).offset(8)
            make.left.equalTo(statsLabelStackView.snp.left)
            make.right.equalTo(statsLabelStackView.snp.right)
            make.height.equalTo(34)
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
        setupToolBar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


