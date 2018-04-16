//
//  CommentsViewController.swift
//  Kalula
//
//  Created by Chris Karani on 4/16/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit

class ContainerView: UIView {
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        return view
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter some Text"
        tf.font = UIFont.helveticaMediumFont()
        return tf
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.helveticaBoldFont(withSize: 14)
        button.tintColor = .black
        return button
    }()
    
    fileprivate func setupUI() {
        addSubview(textField)
        addSubview(sendButton)
        addSubview(seperatorView)
        
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(sendButton.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
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

class CommentsViewController: UICollectionViewController {
    
    lazy var containerView : ContainerView = {
        let containerview = ContainerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return containerview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Comments"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
