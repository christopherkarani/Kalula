//
//  UserSearchController.swift
//  Kalula
//
//  Created by Chris Karani on 4/2/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    var users = [LocalUser]()
    var filteredUsers = [LocalUser]()
    
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        return searchController
    }()
    
    var searchBar : UISearchBar {
        return searchController.searchBar
    }
    
    
    fileprivate func cellIdentifier() -> String {
        return "UserSearchCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleRegistrationOfCells()
        fetchUsers()
        setupSearchBar()
    }
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key,value) in
                guard let userDictionary = value as? [String: Any] else { return }
                let user = FDUser(withUiD: key, dictionary: userDictionary)
                self.users.append(user)
            })
            self.users.sort(by: { (userOne, userTwo) -> Bool in
                return userOne.userName.compare(userTwo.userName) == .orderedAscending
            })
            
            self.collectionView?.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.collectionView?.layoutIfNeeded()
            }
        }
    }
    
    
    fileprivate func setupUI() {
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
       
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    fileprivate func setupSearchBar() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.darkText
        searchBar.delegate = self
    }
    
    fileprivate func handleRegistrationOfCells() {
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellIdentifier())
    }
}

extension UserSearchController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredUsers.count
        } else {
            return users.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(), for: indexPath) as! UserSearchCell
        
        if searchController.isActive {
            cell.user = filteredUsers[indexPath.item]
        } else {
            cell.user = users[indexPath.item]
        }
        return cell
    }
}

extension UserSearchController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

extension UserSearchController: UISearchControllerDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        collectionView?.reloadData()
    }
}

extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = users.filter({ (user) -> Bool in
            return user.userName.localizedLowercase.contains(searchText.localizedLowercase)
        })
        if searchText.isEmpty {
            filteredUsers = users
        }
        
        self.collectionView?.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.collectionView?.layoutIfNeeded()
        }
        
    }
}
