//
//  HomeController.swift
//  Kalula
//
//  Created by Chris Karani on 3/31/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    var posts = [Post]()
    
    private func cellIdentifier() -> String {
        return "HomeCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        registerCollectionViewCells()
        setupNavigationItems()
        fetchPosts()
    }
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = FDUser(dictionary: userDictionary)
            self.fetchPhotos(user, uid)
        }
    }
    
    private func fetchPhotos(_ user: LocalUser, _ uid: String) {
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild:"creationDate").observeSingleEvent(of: .value) { [unowned self] (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, dictionary) in
                guard let dict = dictionary as?  [String: Any] else { return }
                let post = Post(withUser: user, andDictionary: dict)
                self.posts.append(post)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        }
    }
    
    fileprivate func registerCollectionViewCells() {
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellIdentifier())
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(), for: indexPath) as! HomeFeedCell
        cell.post = posts[indexPath.item]
        return cell
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 // profileImageView and UsernameLabel constraints and padding
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}






