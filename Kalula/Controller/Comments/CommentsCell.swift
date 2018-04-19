//
//  CommentsCell.swift
//  Kalula
//
//  Created by Chris Karani on 4/19/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit

class CommentsCell: UICollectionViewCell {
    var comment: Comment? {
        didSet {
            textLabel.text = comment?.text
            
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        return label
    }()
    
    fileprivate func setupUI() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
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
