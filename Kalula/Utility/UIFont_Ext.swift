//
//  UIFont_Ext.swift
//  Kalula
//
//  Created by Chris Karani on 3/30/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit

extension UIFont {
    static func helveticaFont() -> UIFont {
        guard let font =  UIFont(name: "HelveticaNeue", size: 15) else {
            return UIFont.systemFont(ofSize: 15)
        }
        return font
    }
}

