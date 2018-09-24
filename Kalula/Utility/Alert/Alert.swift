//
//  AlertDisplay.swift
//  Kalula
//
//  Created by Chris Karani on 24/09/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//




/**
 A protocol Used to show that a type can be presented as an alert
 */
protocol Alert {
    /// The title of the alert
    var title: String { get }
    var description: String { get }
}






