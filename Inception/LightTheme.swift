//
//  LightTheme.swift
//  Inception
//
//  Created by David Ehlen on 02.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class LightTheme : Theme {
    var backgroundColor = UIColor.whiteColor()
    var textColor = UIColor.blackColor()
    var lightTextColor = UIColor.lightTextColor()
    var primaryTintColor = UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
    var barStyle = UIBarStyle.Default
    var keyboardAppearance = UIKeyboardAppearance.Default
    var searchBarSearchStyle = UISearchBarStyle.Default
    var placeholderImageString = "placeholder-white"
    var tableViewSelectionColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
    var navBarTranslucent = false
}
