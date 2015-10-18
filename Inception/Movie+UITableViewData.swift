//
//  Movie+UITableViewData.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

extension Movie {
    
    func tableData() -> ([String],[String]) {
        var tableData:[String] = []
        var tableKeys:[String] = []
        if self.voteAverage != nil {
            if self.voteAverage! != 0.0 {
                tableData.append("\(self.voteAverage!)")
                tableKeys.append("voteAverage".localized)
            }
        }
        
        if self.status != nil {
            if !self.status!.isEmpty {
                tableData.append(self.status!)
                tableKeys.append("status".localized)
            }
        }
        
        if self.runtime != nil {
            if self.runtime! != 0 {
                tableData.append("\(self.runtime!)")
                tableKeys.append("runtime".localized)
            }
        }
        
        if self.releaseDate != nil {
            if !self.releaseDate!.isEmpty {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date:NSDate = dateFormatter.dateFromString(self.releaseDate!)!
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                tableData.append(dateFormatter.stringFromDate(date))
                tableKeys.append("releaseDate".localized)
            }
        }
        
        if self.budget != nil {
            if self.budget! != 0 {
                tableData.append("\(self.budget!.addSeparator) $")
                tableKeys.append("budget".localized)
            }
        }
        
        if self.revenue != nil {
            if self.revenue! != 0 {
                tableData.append("\(self.revenue!.addSeparator) $")
                tableKeys.append("revenue".localized)
            }
        }
        
        if self.tagline != nil {
            if !self.tagline!.isEmpty {
                tableData.append(self.tagline!)
                tableKeys.append("tagline".localized)
            }
        }
        
        if self.productionCompanies != nil {
            if self.productionCompanies!.count != 0 {
                tableData.append(self.productionCompanies!.joinWithSeparator(","))
                tableKeys.append("productionCompanies".localized)
            }
        }
        
        if self.productionCountries != nil {
            if self.productionCountries!.count != 0 {
                tableData.append(self.productionCountries!.joinWithSeparator(","))
                tableKeys.append("productionCountries".localized)
            }
        }
        
        if self.genres != nil {
            if !self.genres!.isEmpty {
                tableData.append(self.genres!.map{$0.name!}.joinWithSeparator(", "))
                tableKeys.append("genres".localized)
            }
        }
        
        if self.overview != nil {
            if !self.overview!.isEmpty {
                tableData.append(self.overview!)
                tableKeys.append("overview".localized)
            }
        }
        return (tableKeys,tableData)
    }
    
}