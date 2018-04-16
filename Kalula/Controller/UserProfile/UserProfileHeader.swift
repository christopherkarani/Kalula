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
                let url = URL(string: user.profileImageUrl)
                imageView.kf.setImage(with: url)
                userNameLabel.text = user.userName
                
                handleSetupLoginFollowButton()
            }
        }
    }
    
    
    
    fileprivate func handleSetupLoginFollowButton() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        guard let userID = user?.uid else { return }
        
        if currentUserUID == userID {
            //edit profile
        } else {
            Database.database().reference().child("following").child(currentUserUID).child(userID).observeSingleEvent(of: .value) { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                   self.setupUnfollowStyle()
                    
                } else {
                    self.setupFollowStyle()
                }
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        editProfileButton.setTitle("Follow", for: .normal)
        editProfileButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        editProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        editProfileButton.setTitleColor(.white, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.editProfileButton.setNeedsLayout()
        }
    }
    
    fileprivate func setupUnfollowStyle() {
        editProfileButton.setTitle("Unfollow", for: .normal)
        editProfileButton.backgroundColor = .white
        editProfileButton.setTitleColor(.black, for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.editProfileButton.setNeedsLayout()
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
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let followingLabel = UILabel().this {
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    

    
    @objc fileprivate func handleFollowing() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        guard let userID = user?.uid else { return }
        
        if editProfileButton.titleLabel?.text == "Unfollow" {
            
            Database.database().reference().child("following").child(currentUserUID).child(userID).removeValue { (error, ref) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                    return
                }
                
                self.setupFollowStyle()
            }
            
        } else {
            let ref = Database.database().reference().child("following").child(currentUserUID)
            
            let value = [userID: 1]
            ref.updateChildValues(value) { (error, ref) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                    return
                }
                
                self.setupUnfollowStyle()
            }
        }
        
    }
    
    lazy var editProfileButton = UIButton(type: .system).this {
        $0.addTarget(self, action: #selector(handleFollowing), for: .touchUpInside)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitle("", for: .normal)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 4
    }

    fileprivate func setupToolBar() {
        
        toolBarStackView.distribution = .fillEqually
        toolBarStackView.axis = .horizontal
        addSubview(toolBarStackView)

        
        toolBarStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    let imageView = UIImageView().this {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40 // half of the width
    }
    
    fileprivate func setupViews() {
        setupToolBar()
        
        let topDividerLineView = UIView()
        topDividerLineView.backgroundColor = .lightGray
        
        let bottomDividerLineView = UIView()
        bottomDividerLineView.backgroundColor = .lightGray
        
        
        addSubview(topDividerLineView)
        addSubview(bottomDividerLineView)
        addSubview(imageView)
        addSubview(statsLabelStackView)
        addSubview(editProfileButton)
        addSubview(userNameLabel)
        
        imageView.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(20)
            $0.top.equalTo(snp.top).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalTo(gridButton.snp.top)
            make.left.equalTo(snp.left).inset(12)
            make.right.equalTo(snp.right).inset(12)
        }

        statsLabelStackView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(12)
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        editProfileButton.snp.makeConstraints { (make) in
            make.top.equalTo(statsLabelStackView.snp.bottom).offset(2)
            make.left.equalTo(statsLabelStackView.snp.left)
            make.right.equalTo(statsLabelStackView.snp.right)
            make.height.equalTo(34)
        }
        
        topDividerLineView.snp.makeConstraints { (make) in
            make.top.equalTo(toolBarStackView.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bottomDividerLineView.snp.makeConstraints { (make) in
            make.top.equalTo(toolBarStackView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
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
    
    fileprivate func prepareStackViewsForUse() {
        statsLabelStackView = UIStackView(arrangedSubviews: [postLabal, followersLabal, followingLabel])
        toolBarStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareStackViewsForUse()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


