//
//  UserSearchController.swift
//  Kalula
//
//  Created by Chris Karani on 4/2/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    fileprivate func cellIdentifier() -> String {
        return "UserSearchCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        handleRegistrationOfCells()
    }
    fileprivate func setupUI() {
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
       
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barStyle = .blackTranslucent
    }
    
    fileprivate func handleRegistrationOfCells() {
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellIdentifier())
    }
}

extension UserSearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(), for: indexPath) as! UserSearchCell
        
        return cell
    }
}

extension UserSearchController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
