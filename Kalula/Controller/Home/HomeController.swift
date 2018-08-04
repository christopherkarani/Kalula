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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCollectionViewCells()
        setupNavigationItems()
        fetchAllPosts()
        setupNotificationObservers()
        setupRefreshDelegateConform()
    }

    func setupRefreshDelegateConform() {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        tabBarController.refreshableDelegate = self
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingPosts()
    }
    
    fileprivate func refreshCollectionView(withFreshPosts posts: [Post]) {
        

        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.endRefreshing()
            self.collectionView?.reloadData()
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
            var count = 0
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, dictionary) in
                count += 1
                guard let dict = dictionary as?  [String: Any] else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                var post = Post(withUser: user, andDictionary: dict)
                print(post.caption)
                post.id = key
                Database.database().reference(withPath: "likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.isLiked = true
                    } else {
                        post.isLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                })
            })
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
        commentsViewController.post = post
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
    func didLikePost(forCell cell: HomeFeedCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
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





