//
//  UserProfileViewController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase
import Toaster
import Hero

class UserProfileViewController: UICollectionViewController {
    
    let headerID =  "HeaderID"
    let cellID   =  "CellID"
    var isUserAvailable: Bool?
    
    var user : LocalUser? {
        didSet {
            if let user = user {
                navigationItem.title = user.userName
            } 
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        registerCells()
        setupNavigationBar()
        //isHeroEnabled = true
    }
    
    private func setupNavigationBar() {
        let logoutBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutButton))
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    @objc private func handleLogoutButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { [weak self] (_) in
            let loginController = LoginController()
            self?.heroModalAnimationType = .zoomOut
            let navcontroller = UINavigationController(rootViewController: loginController)
            navcontroller.isHeroEnabled = true
            self?.present(navcontroller, animated: true, completion: nil)
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancleAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchUser()
    }
    
    fileprivate func registerCells() {
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No User online")
            present(SignUpController.init(loginService: LoginManager()), animated: true, completion: nil)
            isUserAvailable = false
            return
        }
        isUserAvailable = false
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            let strongSelf = self.unwrap()
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            strongSelf.user = FDUser(dictionary: dictionary)
            DispatchQueue.main.async {
                strongSelf.collectionView?.reloadData()
            }
            
        }) { (error) in
            Toast(text: error.localizedDescription).show()
        }
    }
}

extension UserProfileViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width / 3 - 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension UserProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeader
        header.user = user
        return header
    }
}

extension UserProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .magenta
        return cell
    }
}


