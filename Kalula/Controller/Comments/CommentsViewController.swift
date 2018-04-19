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
    
    struct Comment: CustomStringConvertible {
        var text: String
        var dateCreated: Double
        var uid: String
        
        var description: String {
            return "Text: \(text), \n createdOn:\(dateCreated), \n sentBy: \(uid)"
        }
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text else { return }
        guard let postID = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let comment = Comment(text: text, dateCreated: Date().timeIntervalSince1970, uid: uid)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupInputComponents()
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
