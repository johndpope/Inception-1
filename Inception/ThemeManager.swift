//
//  ThemeManager.swift
//  Inception
//
//  Created by David Ehlen on 02.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class ThemeManager {
    static let sharedInstance = ThemeManager()
    let lightTheme = LightTheme()
    let darkTheme = DarkTheme()
    
    var currentTheme:Theme {
        let theme = SettingsFactory.ThemeOption(rawValue: SettingsFactory.objectForKey(SettingsFactory.SettingKey.Theme) as! String)!
        
        switch theme {
            case .Dark : return self.darkTheme
            case .Light: return self.lightTheme
        }
    }
}