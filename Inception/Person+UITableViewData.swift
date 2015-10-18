//
//  Person+UITableData.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

extension Person {
    
    func tableData() -> ([String], [String]) {
        var tableData:[String] = []
        var tableKeys:[String] = []

        if self.placeOfBirth != nil && !self.placeOfBirth!.isEmpty {
            tableData.append(self.placeOfBirth!)
            tableKeys.append("placeofbirth".localized)
        }
        
        if self.self.birthday != nil && !self.self.birthday!.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(self.birthday!)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            tableData.append(dateFormatter.stringFromDate(date))
            tableKeys.append("birthday".localized)
        }
        
        if self.self.deathday != nil && !self.self.deathday!.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(self.deathday!)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            tableData.append(dateFormatter.stringFromDate(date))
            tableKeys.append("deathday".localized)
            
        }
        
        if self.self.biography != nil && !self.self.biography!.isEmpty {
            tableData.append(self.biography!)
            tableKeys.append("biography".localized)
        }
        
        return (tableKeys,tableData)

    }
    
}