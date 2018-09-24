//
//  UIViewController_Ext.swift
//  Kalula
//
//  Created by Chris Karani on 24/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit.UIAlertController
import UIKit.UIViewController

extension UIViewController  {
    /// Display an Alert
    /// - parameter alert: Input of the Alert Type which will provide all necesarry details required to render Alert
    func show<E: Alert>(alert e: E) {
        let alertController = UIAlertController(title: e.title, message: e.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
