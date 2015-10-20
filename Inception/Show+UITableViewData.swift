//
//  Show+UITableViewData.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

extension Show {
    
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
        
        if self.numberOfEpisodes != nil {
            if self.numberOfEpisodes! != 0 {
                tableData.append("\(self.numberOfEpisodes!)")
                tableKeys.append("numberOfEpisodes".localized)
            }
        }
        
        if self.numberOfSeasons != nil {
            if self.numberOfSeasons! != 0 {
                tableData.append("\(self.numberOfSeasons!)")
                tableKeys.append("numberOfSeasons".localized)
            }
        }
        
        if self.seasons != nil {
            if self.seasons!.count > 0 {
                tableData.append("showSeasons".localized)
                tableKeys.append("showSeasons".localized)
            }
        }
        
        if self.firstAirDate != nil {
            if !self.firstAirDate!.isEmpty {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date:NSDate = dateFormatter.dateFromString(self.firstAirDate!)!
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                tableData.append(dateFormatter.stringFromDate(date))
                tableKeys.append("firstAirDate".localized)
            }
        }
        
        if self.lastAirDate != nil {
            if !self.lastAirDate!.isEmpty {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date:NSDate = dateFormatter.dateFromString(self.lastAirDate!)!
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                tableData.append(dateFormatter.stringFromDate(date))
                tableKeys.append("lastAirDate".localized)
            }
        }
        
        
        if self.episodeRunTime != nil {
            if self.episodeRunTime!.count != 0 {
                tableData.append(self.episodeRunTime!.map{String($0)}.joinWithSeparator(", "))
                tableKeys.append("episodeRuntime".localized)
            }
        }
        
        if self.inProduction != nil {
            var string = "no".localized;
            if self.inProduction! {
                string = "yes".localized
            }
            
            tableData.append(string)
            tableKeys.append("inProduction".localized)
        }
        
        if self.createdBy != nil {
            if self.createdBy!.count != 0 {
                tableData.append(self.createdBy!.joinWithSeparator(","))
                tableKeys.append("createdBy".localized)
            }
        }
        
        if self.networks != nil {
            if self.networks!.count != 0 {
                tableData.append(self.networks!.joinWithSeparator(","))
                tableKeys.append("networks".localized)
            }
        }
        
        if self.originCountries != nil {
            if self.originCountries!.count != 0 {
                tableData.append(self.originCountries!.joinWithSeparator(","))
                tableKeys.append("originCountries".localized)
            }
        }
        
        if self.type != nil {
            if !self.type!.isEmpty {
                tableData.append(self.type!)
                tableKeys.append("type".localized)
            }
        }
        
        if self.productionCompanies != nil {
            if self.productionCompanies!.count != 0 {
                tableData.append(self.productionCompanies!.joinWithSeparator(","))
                tableKeys.append("productionCompanies".localized)
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
        
        return(tableKeys,tableData)
        
    }
}