//
//  MainTabBarController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 09/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let userProfifileVC = UserProfileViewController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfifileVC)
        
        
        
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
        
    }
}
