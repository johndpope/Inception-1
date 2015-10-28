//
//  SettingsRow.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

public enum SettingsRow: Int {
    case Info
    case NotificationSwitch
    case Alarm
    case DatePicker
    case ImageQuality
    case VideoQuality
    case Cache
    case ImageCache    
    case Unknown
    
    
    init(indexPath: NSIndexPath) {
        var row = SettingsRow.Unknown
        
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                row = SettingsRow.Info
            case (0, 1):
                row = SettingsRow.NotificationSwitch
            case (0, 2):
                row = SettingsRow.Alarm
            case (0, 3):
                row = SettingsRow.DatePicker
            case (1,0):
                row = SettingsRow.ImageQuality
            case (1,1):
                row = SettingsRow.VideoQuality
            case (2,0):
                row = SettingsRow.Cache
            case (2,1):
                row = SettingsRow.ImageCache
            default:
                ()
        }
        
        assert(row != SettingsRow.Unknown)
        
        self = row
    }
}
 