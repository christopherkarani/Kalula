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
        setupCollectionView()
        registerCollectionViewCells()
        setupNavigationItems()
        fetchAllPosts()
        setupNotificationObservers()
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingPosts()
    }
    
    fileprivate func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.endRefreshing()
            self.collectionView?.reloadData()
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView?.layoutIfNeeded()
//            })
        }

    }
    
    fileprivate func fetchFollowingPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (uid, value) in
                Database.fetchUserWithUID(uid: uid, completion: { (user) in
                    self.fetchPhotos(user, uid)
                })
            })
        }
    }
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPhotos(user, user.uid)
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
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
            })
            
            self.refreshCollectionView()
        }
    }
    

    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        setupRefreshControl()
    }
    
    fileprivate func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    fileprivate func registerCollectionViewCells() {
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellIdentifier())
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePostImageNotification), name: .postImage, object: nil)
    }
    
    @objc fileprivate func handlePostImageNotification() {
        handleRefresh()
    }
}

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(), for: indexPath) as! HomeFeedCell
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        
        cell.delegate = self
        
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

extension HomeController: ControllerRefreshDelegate {
    func refreshView() {
        handleRefresh()
    }
}
extension HomeController: HomeFeedCellDelegate {
    func didTapCommentButton(onPost post: Post) {
        let commentsViewController = CommentsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
}





