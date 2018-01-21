//
//  UIColor+Extension.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 20/12/2017.
//  Copyright © 2017 Christopher Brandon Karani. All rights reserved.
//

import UIKit

extension UIColor {
    static var theme = UIColor.rgb(red: 255, green: 215, blue: 0)
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
