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
        
        if let voteAverage = self.voteAverage where voteAverage != 0.0 {
            tableData.append("\(voteAverage)/10.0")
            tableKeys.append("voteAverage".localized)
        }
        
        if let status = self.status where !status.isEmpty {
            tableData.append(status)
            tableKeys.append("status".localized)
        }
        
        if let runtime = self.runtime where runtime != 0 {
            tableData.append("\(runtime) min")
            tableKeys.append("runtime".localized)
        }
        
        if let releaseDate = self.releaseDate where !releaseDate.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(releaseDate)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let releaseDateString = "\(dateFormatter.stringFromDate(date)) (\(releaseDateCountryCode.countryNameFromCode))";
            tableData.append(releaseDateString)
            tableKeys.append("releaseDate".localized)
        }
        
        if let budget = self.budget where budget != 0 {
            tableData.append("\(budget.addSeparator) $")
            tableKeys.append("budget".localized)
        }
        
        if let revenue = self.revenue where revenue != 0 {
            tableData.append("\(revenue.addSeparator) $")
            tableKeys.append("revenue".localized)
        }
        
        if let tagline = self.tagline where !tagline.isEmpty {
            tableData.append(tagline)
            tableKeys.append("tagline".localized)
        }
        
        if let productionCompanies = self.productionCompanies where productionCompanies.count != 0 {
            tableData.append(productionCompanies.joinWithSeparator(","))
            tableKeys.append("productionCompanies".localized)
        }
        
        if let productionCountries = self.productionCountries where productionCountries.count != 0 {
            tableData.append(productionCountries.joinWithSeparator(","))
            tableKeys.append("productionCountries".localized)
        }
        
        if let genres = self.genres where !genres.isEmpty {
            tableData.append(genres.map{$0.name!}.joinWithSeparator(", "))
            tableKeys.append("genres".localized)
        }
        
        if let overview = self.overview where !overview.isEmpty {
            tableData.append(overview)
            tableKeys.append("overview".localized)
        }
        return (tableKeys,tableData)
    }
    
}
