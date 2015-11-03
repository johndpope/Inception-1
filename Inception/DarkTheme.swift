//
//  DarkTheme.swift
//  Inception
//
//  Created by David Ehlen on 02.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class DarkTheme : Theme {
    var backgroundColor = UIColor.darkTextColor()
    var textColor = UIColor.whiteColor()
    var lightTextColor = UIColor.lightTextColor()
    var primaryTintColor = UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    var barStyle = UIBarStyle.Black
    var keyboardAppearance = UIKeyboardAppearance.Dark
    var searchBarSearchStyle = UISearchBarStyle.Minimal
    var placeholderImageString = "placeholder-dark"
    var tableViewSelectionColor =  UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
    var navBarTranslucent = true
}