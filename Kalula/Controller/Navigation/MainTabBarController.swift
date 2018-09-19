//
//  MainTabBarController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Firebase

protocol ControllerRefreshDelegate: class {
    func refreshView()
}


class MainTabBarController : UITabBarController {
    
    public let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var refreshableDelegate: ControllerRefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            //show if not logged in
            
            DispatchQueue.main.async {
                let loginController = LoginController(session: Session())
                
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        setupViewControllers()

    }
    
    private func setupViewControllers() {
        
        //home
        
  
        let homeNavigationController = viewControllerFactory(with: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: homeController)
        
        
        //search
        let searchController = viewControllerFactory(with: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //imagePicker
        let imagePicker = viewControllerFactory(with: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //likes
        
        let likesController = viewControllerFactory(with: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        
        let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileNavigationController = viewControllerFactory(with: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: userProfileController)
        
        refreshableDelegate = userProfileController
        
        tabBar.tintColor = .black
  
        
        viewControllers = [homeNavigationController, searchController, imagePicker, likesController, userProfileNavigationController]
        
        guard let items = tabBar.items else { return }
        
        items.forEach { (item) in
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    private func viewControllerFactory(with selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        return navigationController
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorViewController = PhotoSelectorViewController(collectionViewLayout: layout)
            let navigationController = UINavigationController(rootViewController: photoSelectorViewController)
            present(navigationController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
