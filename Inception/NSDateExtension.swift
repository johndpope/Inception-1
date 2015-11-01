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
    
    var string:String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    var olderThan2Weeks:Bool {
        let components = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: [])
        return components.day+1 > 14
    }
}