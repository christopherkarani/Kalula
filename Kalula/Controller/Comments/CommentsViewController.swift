//
//  CommentsViewController.swift
//  Kalula
//
//  Created by Chris Karani on 4/16/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit



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
