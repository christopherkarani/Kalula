//
//  HomeController.swift
//  Kalula
//
//  Created by Chris Karani on 3/31/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class HomeController: UICollectionViewController {
    var posts = [Post]()
    
    private func cellIdentifier() -> String {
        return "HomeCell"
    }
    
    private var uid: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCollectionViewCells()
        setupNavigationItems()
        fetchAllPosts()
        setupNotificationObservers()
        setupRefreshDelegateConform()
    }
}

/// Setup Code Goes here
extension HomeController {
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        setupRefreshControl()
    }
    /// setup what is neccesary for the refresh control
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
    
    
    func setupRefreshDelegateConform() {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        tabBarController.refreshableDelegate = self
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

/// Fetching Code Goes here
extension HomeController {
    fileprivate func fetchFollowingPosts(completion: @escaping () -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            for uid in dictionary.keys {
                Database.fetchUserWithUID(uid: uid, completion: { (user) in
                    self.fetchPhotos(user, uid)
                    completion()
                })
            }
        }
    }
    
    func fetchPosts() {
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPhotos(user, user.uid)
        }
    }
    /// Fetch photos from the firebase databae. Once data is recieved, append elements to the array then sort it
    private func fetchPhotos(_ user: LocalUser, _ uidValue: String) {
        
        let ref = Database.database().reference().child("posts").child(uidValue)
        ref.queryOrdered(byChild:"creationDate").observeSingleEvent(of: .value) { [unowned self] (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            for (key,dictionary) in dictionaries {
                guard let dict = dictionary as?  [String: Any] else { return }
                
                var post = Post(withUser: user, andDictionary: dict)
                post.id = key
                Database.database().reference(withPath: "likes").child(key).child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // culculate the isLike value based of of 1 or 0 provided by the payload
                    guard let value = snapshot.value as? Int else { return }
                    post.isLiked = value == 1 ? true : false
                    
                    // append and sort the array
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                })
            }
        }
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingPosts {
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
}
extension HomeController: HomeFeedCellDelegate {
    func didTapCommentButton(onPost post: Post) {
        let commentsViewController = CommentsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsViewController.post = post
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
    func didLikePost(forCell cell: HomeFeedCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let posID = post.id else { return }
        let ref = Database.database().reference().child("likes").child(posID)
        let values = [uid: post.isLiked ? 0 : 1]
        ref.updateChildValues(values) { (error, _) in
            if let error = error {
                Toast(text: error.localizedDescription).show()
                return
            }
            post.isLiked = !post.isLiked;
            self.posts[indexPath.item] = post
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
}





