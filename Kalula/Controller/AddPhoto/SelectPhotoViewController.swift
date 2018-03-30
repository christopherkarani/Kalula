//
//  SelectPhotoViewController.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Toaster

class SelectPhotoViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textInputView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.helveticaFont()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupNavigationBar()
        setupUI()
    }
    
    fileprivate func setupUI() {
        setupMainViewUI()
        setupContainerViewUI()
    }
    
    fileprivate func setupMainViewUI() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    fileprivate func setupContainerViewUI() {
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(84)
            make.height.equalTo(84)
        }
        
        containerView.addSubview(textInputView)
        textInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    
    func handleImageUpload(withImageUrlString urlString: String, andCaption caption: String) {

        guard let postImage = image else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["caption": caption, "imageUrl": urlString, "imageHeight": postImage.size.height, "imageWidth": postImage.size.width, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.childByAutoId().updateChildValues(values) { [unowned self] (error, ref) in
            if let error = error {
                Toast(text: error.localizedDescription).show()
                 self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShareImage))
    }
    
    
    @objc private func handleShareImage() {
        guard let caption = textInputView.text, caption.count > 0 else {
            Toast(text: "Please write a caption").show()
            return
        }
        let storageRef = Storage.storage().reference().child("posts")
        let imageName = UUID().uuidString
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let selectedimage = image else { return }
        guard let imageData = UIImageJPEGRepresentation(selectedimage, 0.5) else { return }
        
        storageRef.child(imageName).putData(imageData, metadata: nil) { [unowned self] (metadata, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                Toast(text: error.localizedDescription).show()
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            self.handleImageUpload(withImageUrlString: imageUrl, andCaption: caption)
            
        }
        
    }
    
    override var prefersStatusBarHidden: Bool { return true }
}
