//
//  StringToDateExtension.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation


extension String {
    
    var year:Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.dateFromString(self) {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Year, fromDate: date)
            return components.year
        }
        return 0
    }
    
    var isInFutureOrToday:Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.dateFromString(self) {
            if NSDate().compare(date) == .OrderedAscending || NSCalendar.currentCalendar().isDateInToday(date) {
                return true
            }
        }
        return false
    }
    
    var date:NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.dateFromString(self) {
            return date
        }
        return nil
    }
    
    var dateWithTime:NSDate? {
        let alarmDate = SettingsFactory.objectForKey(SettingsFactory.SettingKey.NotificationAlarmDate) as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.dateFromString(self) {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour,.Minute,.Second], fromDate: alarmDate)
            let newDate: NSDate = calendar.dateBySettingHour(components.hour, minute: components.minute, second: components.second, ofDate: date, options: NSCalendarOptions())!
            
            let alarmDay = SettingsFactory.objectForKey(SettingsFactory.SettingKey.AlarmDay) as! String
            if alarmDay == "twodaysbefore" {
               return calendar.dateByAddingUnit(.Day, value: -2, toDate: newDate, options: [])

            }
            else if alarmDay == "daybefore" {
                return calendar.dateByAddingUnit(.Day, value: -1, toDate: newDate, options: [])
            }
            
            return newDate

        }
        return nil
    }
    
    var relativeNotificationDate:String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.dateFromString(self) {
            let calendar = NSCalendar.currentCalendar()
            let twoDaysDate = calendar.dateByAddingUnit(.Day, value: +2, toDate: NSDate(), options: [])!
            let tomorrowDate = calendar.dateByAddingUnit(.Day, value: +1, toDate: NSDate(), options: [])!
            if NSDate.isSameDay(date, date2: twoDaysDate) {
                return "intwodays".localized
            }
            else if NSDate.isSameDay(date, date2: tomorrowDate) {
                return "tomorrow".localized
            }
            else if date.isToday {
                return "today".localized
            }

        }
        return ""
    }
}