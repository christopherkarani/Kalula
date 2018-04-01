//
//  UIFont_Ext.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit

extension UIFont {
    static func helveticaFont(withSize size : CGFloat = 15) -> UIFont {
        guard let font =  UIFont(name: "HelveticaNeue", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    static func helveticaBoldFont(withSize size : CGFloat = 15) -> UIFont {
        guard let font =  UIFont(name: "HelveticaNeue-Bold", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return font
    }  
}

