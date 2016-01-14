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
        
        if let voteAverage = self.voteAverage where voteAverage != 0.0 {
            tableData.append("\(voteAverage)")
            tableKeys.append("voteAverage".localized)
        }
        
        if let status = self.status where !status.isEmpty {
            tableData.append(status)
            tableKeys.append("status".localized)
        }
        
        if let numberOfEpisodes = self.numberOfEpisodes where numberOfEpisodes != 0 {
            tableData.append("\(numberOfEpisodes)")
            tableKeys.append("numberOfEpisodes".localized)
        }
        
        if let numberOfSeasons = self.numberOfSeasons where numberOfSeasons != 0 {
            tableData.append("\(numberOfSeasons)")
            tableKeys.append("numberOfSeasons".localized)
        }
        
        if let seasons = self.seasons where seasons.count > 0 {
            tableData.append("showSeasons".localized)
            tableKeys.append("showSeasons".localized)
        }
        
        if let firstAirDate = self.firstAirDate where !firstAirDate.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(firstAirDate)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            tableData.append(dateFormatter.stringFromDate(date))
            tableKeys.append("firstAirDate".localized)
        }
        
        if let lastAirDate = self.lastAirDate where !lastAirDate.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date:NSDate = dateFormatter.dateFromString(lastAirDate)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            tableData.append(dateFormatter.stringFromDate(date))
            tableKeys.append("lastAirDate".localized)
        }
        
        
        if let episodeRunTime = self.episodeRunTime where episodeRunTime.count != 0 {
            var episodeRuntimeString = episodeRunTime.map{String($0)}.joinWithSeparator(", ")
            episodeRuntimeString += " min"
            tableData.append(episodeRuntimeString)
            tableKeys.append("episodeRuntime".localized)
        }
        
        if let inProduction = self.inProduction {
            var string = "no".localized;
            if inProduction {
                string = "yes".localized
            }
            tableData.append(string)
            tableKeys.append("inProduction".localized)
        }
        
        if let createdBy = self.createdBy where createdBy.count != 0 {
            tableData.append(createdBy.joinWithSeparator(","))
            tableKeys.append("createdBy".localized)
        }
        
        if let networks = self.networks where networks.count != 0 {
            tableData.append(networks.joinWithSeparator(","))
            tableKeys.append("networks".localized)
        }
        
        if let originCountries = self.originCountries where originCountries.count != 0 {
            tableData.append(originCountries.joinWithSeparator(","))
            tableKeys.append("originCountries".localized)
        }
        
        if let type = self.type where !type.isEmpty  {
            tableData.append(type)
            tableKeys.append("type".localized)
        }
        
        if let productionCompanies = self.productionCompanies where productionCompanies.count != 0 {
            tableData.append(productionCompanies.joinWithSeparator(","))
            tableKeys.append("productionCompanies".localized)
        }
        
        if let genres = self.genres where !genres.isEmpty {
            tableData.append(genres.map{$0.name!}.joinWithSeparator(", "))
            tableKeys.append("genres".localized)
        }
        
        if let overview = self.overview where !overview.isEmpty {
            tableData.append(overview)
            tableKeys.append("overview".localized)
        }
        
        return(tableKeys,tableData)
        
    }
}
