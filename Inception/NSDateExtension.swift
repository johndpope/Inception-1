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
}