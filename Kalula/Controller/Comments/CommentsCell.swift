//
//  CommentsCell.swift
//  Kalula
//
//  Created by Chris Karani on 4/19/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Firebase

class CommentsCell: UICollectionViewCell {
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            retrieveUserInfoAndSetupCell(withComment: comment )
        }
    }
    
    var user : LocalUser {
        return comment!.user
    }
    
    private func setupAttributedComment(withText text: String, andUser user: LocalUser) {
        let mutableAttributedString = NSMutableAttributedString(string: user.userName, attributes: [.font : UIFont.helveticaBoldFont()])
        let commentText = NSAttributedString(string: " " + text, attributes: [.font : UIFont.helveticaFont()])
        mutableAttributedString.append(commentText)
        commentTextView.attributedText = mutableAttributedString
    }
    
    private func retrieveUserInfoAndSetupCell(withComment comment: Comment) {
            let imageURL = URL(string: comment.user.profileImageUrl)
            imageView.kf.setImage(with: imageURL)
            setupAttributedComment(withText: comment.text, andUser: user)
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        return textView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        return view
    }()
    
    fileprivate func setupUI() {
        addSubview(imageView)
        addSubview(commentTextView)
        addSubview(seperatorView)
        

        commentTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.left.equalTo(imageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
            make.centerX.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
