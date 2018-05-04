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

protocol HomeFeedCellDelegate: class {
    func didTapCommentButton(onPost post: Post)
    func didLikePost(forCell cell: HomeFeedCell)
}

class HomeFeedCell: UICollectionViewCell {
    

    
    weak var delegate: HomeFeedCellDelegate?
    
    func manageLikeButtonStateRendering() {
        let likeImages = (selected: #imageLiteral(resourceName: "like_selected"), unselected: #imageLiteral(resourceName: "like_unselected"))
        switch post?.isLiked {
        case true:
            likeButton.setImage(likeImages.selected, for: .normal)
            likeButton.tintColor = UIColor.rgb(red: 239, green: 55, blue: 73)
        case false:
            likeButton.setImage(likeImages.unselected.withRenderingMode(.alwaysOriginal), for: .normal)
        default: break
        }
    }
    
    public var post : Post? {
        didSet {
            if let post = post {
                
                manageLikeButtonStateRendering()
                let imageUrl = URL(string: post.imageUrl)
                let userProfileImageUrl = URL(string: post.user.profileImageUrl)
                self.imageView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2))])
                profileImageView.kf.setImage(with: userProfileImageUrl, options: [.transition(.fade(0.2))])
                userNameLabel.text = post.user.userName
                
                setupCaptionText(withPost: post)
            }
        }
    }
    
    func setupCaptionText(withPost post: Post) {
        let attributedText = NSMutableAttributedString(string: post.user.userName, attributes: [.font : UIFont.helveticaMediumFont()])
        attributedText.append(NSAttributedString(string: " \(post.caption).", attributes: [.font : UIFont.helveticaFont()]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.helveticaFont(withSize: 4)]))
        attributedText.append(NSAttributedString(string: "\(Date().timeAgoSinceDate(date: post.creationDate as NSDate, numericDates: false))", attributes: [NSAttributedStringKey.font : UIFont.helveticaMediumFont(withSize: 14), .foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
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
        label.font = UIFont.helveticaMediumFont()
        return label
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
        
    
    public let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonInteraction(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleLikeButtonInteraction(_ sender: UIButton) {
        delegate?.didLikePost(forCell: self)
    }
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCommentsButton), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleCommentsButton() {
        guard let post = post else { return }
        delegate?.didTapCommentButton(onPost: post)
    }
    
    private let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var actionButtonStackView: UIStackView = {
        let views : [UIView] = [likeButton, commentButton, messageButton]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaFont()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userNameLabel)
        addSubview(profileImageView)
        addSubview(imageView)
        addSubview(optionsButton)
        addSubview(actionButtonStackView)
        addSubview(bookmarkButton)
        addSubview(captionLabel)
        
        
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
        
        actionButtonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        bookmarkButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(40)
        }
        
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonStackView.snp.bottom).inset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


