//
//  CommentsViewController.swift
//  Kalula
//
//  Created by Chris Karani on 4/16/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


class CommentsViewController: UICollectionViewController {
    
    var post: Post?
    
    var comments = [Comment]()
    
    lazy var containerView : ContainerView = {
        let containerview = ContainerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return containerview
    }()
    
    var sendButton : UIButton  {
        return containerView.sendButton
    }
    
    var inputTextField: UITextField {
        return containerView.textField
    }
    
    fileprivate func setupInputComponents() {
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    fileprivate func cellIdentifier() -> String {
        return "CommentsCellID"
    }
    

    
    @objc private func handleSend() {
        guard let text = inputTextField.text else { return }
        guard let postID = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let comment = SendComment(text: text, dateCreated: Date().timeIntervalSince1970, uid: uid)
        let ref = Database.database().reference().child("comments").child(postID).childByAutoId()
        let values: [String: Any] = ["text" : comment.text,
                                     "dateCreated": comment.dateCreated,
                                     "uid": comment.uid]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Succesfully sent comment", comment)
        }
        
    }
    
    fileprivate func fetchPosts() {
        guard let postID = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postID)
        ref.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let comment = Comment(dictionary: dictionary)
            self.comments.append(comment)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupInputComponents()
        fetchPosts()
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
        setupCollectionViewUIPresets()
        setupCollectionViewCell()
    }
    
    fileprivate func setupCollectionViewUIPresets() {
        collectionView?.backgroundColor = .white
    }
    
    fileprivate func setupCollectionViewCell() {
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellIdentifier())
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

extension CommentsViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(), for: indexPath) as! CommentsCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
}

extension CommentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
