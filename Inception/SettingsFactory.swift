//
//  SettingsFactory.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class SettingsFactory {
    
    enum SettingKey:String {
        case Notifications = "notifications"
        case NotificationAlarmDate = "notificationAlarmDate"
        case DidShowNotificationsToday = "didShowNotificationsToday"
    }
    
    class func registerDefaults() {
        NSUserDefaults.standardUserDefaults().registerDefaults([SettingKey.Notifications.rawValue:false,SettingKey.DidShowNotificationsToday.rawValue:NSDate.dateWith(2014, month: 1, day: 1, hour: 1, minute: 1, second: 1), SettingKey.NotificationAlarmDate.rawValue:NSDate.dateWith(2015, month: 1, day: 1, hour: 12, minute: 0, second: 0)])
    }
    
    class func boolForKey(key:SettingKey) -> Bool? {
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue)
    }
    
    class func objectForKey(key:SettingKey) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue)
    }
    
    class func setBoolForKey(key:SettingKey, value:Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setObjectForKey(key:SettingKey, value:AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}