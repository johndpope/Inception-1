//
//  NSDateExtension.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

extension NSDate {
    class func dateWith(year:Int, month:Int, day:Int, hour:Int, minute:Int, second:Int) -> NSDate {
        let dayComponents = NSDateComponents()
        dayComponents.year = year
        dayComponents.month = month
        dayComponents.day = day
        dayComponents.hour = hour
        dayComponents.minute = minute
        dayComponents.second = second
        return NSCalendar.currentCalendar().dateFromComponents(dayComponents)!
    }
    
    class func isSameDay(date1:NSDate,date2:NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let comps1 = calendar.components([.Month,.Year,.Day], fromDate: date1)
        let comps2 = calendar.components([.Month,.Year,.Day], fromDate:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
    
    var isToday:Bool {
        return NSDate.isSameDay(self, date2: NSDate())
    }
    
    var isInFutureOrToday:Bool {
        return NSDate().compare(self) == .OrderedAscending || NSCalendar.currentCalendar().isDateInToday(self)
    }
    
    var string:String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    var olderThan2Weeks:Bool {
        let components = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: [])
        return components.day+1 > 14
    }
    
    var dateWithTime:NSDate? {
        let alarmDate = SettingsFactory.objectForKey(SettingsFactory.SettingKey.NotificationAlarmDate) as! NSDate
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour,.Minute,.Second], fromDate: alarmDate)
        let newDate: NSDate = calendar.dateBySettingHour(components.hour, minute: components.minute, second: components.second, ofDate: self, options: NSCalendarOptions())!
        let alarmDay = SettingsFactory.objectForKey(SettingsFactory.SettingKey.AlarmDay) as! String
        if alarmDay == "twodaysbefore" {
            return calendar.dateByAddingUnit(.Day, value: -2, toDate: newDate, options: [])
        }
        else if alarmDay == "daybefore" {
            return calendar.dateByAddingUnit(.Day, value: -1, toDate: newDate, options: [])
        }
            
        return newDate
    }
    
    var relativeNotificationDate:String {
        let calendar = NSCalendar.currentCalendar()
        let twoDaysDate = calendar.dateByAddingUnit(.Day, value: +2, toDate: NSDate(), options: [])!
        let tomorrowDate = calendar.dateByAddingUnit(.Day, value: +1, toDate: NSDate(), options: [])!
        if NSDate.isSameDay(self, date2: twoDaysDate) {
            return "intwodays".localized
        }
        else if NSDate.isSameDay(self, date2: tomorrowDate) {
            return "tomorrow".localized
        }
        else if self.isToday {
            return "today".localized
        }

        return ""
    }
}