//
//  CommentsViewController.swift
//  Kalula
//
//  Created by Chris Karani on 4/16/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit

class CommentsViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Comments"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
