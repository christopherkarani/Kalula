//
//  PhotoSelectorHeaderCell.swift
//  Kalula
//
//  Created by Chris Karani on 3/26/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit

class PhotoSelectorHeaderCell : UICollectionViewCell {
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
