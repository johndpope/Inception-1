//
//  Theme.swift
//  Inception
//
//  Created by David Ehlen on 02.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

protocol Theme {
    var backgroundColor:UIColor {get}
    var textColor:UIColor {get}
    var lightTextColor:UIColor{get}
    var primaryTintColor:UIColor{get}
    var barStyle:UIBarStyle{get}
    var keyboardAppearance:UIKeyboardAppearance{get}
    var searchBarSearchStyle:UISearchBarStyle{get}
    var placeholderImageString:String {get}
    var tableViewSelectionColor:UIColor{get}
    var navBarTranslucent:Bool {get}
    var darkerTextColor:UIColor {get}
    var seasonNavigatorBackgroundColor:UIColor {get}
    var trailStrokeColor:UIColor {get}
    var copyrightImageString:String {get}
}