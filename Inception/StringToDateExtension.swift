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
}