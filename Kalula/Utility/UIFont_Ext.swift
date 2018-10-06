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
        return UIFont(name: "HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func helveticaBoldFont(withSize size : CGFloat = 15) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func helveticaMediumFont(withSize size : CGFloat = 15) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func sanfransiscoRegular(withSize size: CGFloat = 15) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    static func sanfransiscoLight(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Light", size: size)!
    }
    
    static func sanfransiscoSemiBold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: size)!
    }
    
    static func sanfransiscoBold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    static func sanfransiscoHeavy(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Heavy", size: size)!
    }
    
    static func sanfransiscoMedium(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    
    
}

