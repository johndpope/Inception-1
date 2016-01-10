//
//  NSSet+Convertible.swift
//  Inception
//
//  Created by David Ehlen on 10.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import Foundation

extension NSSet {
    
    var sortedSeasonArray:[SeasonWatchlistItem] {
        var array = self.allObjects.map {$0 as! SeasonWatchlistItem}
        array.sortInPlace(sortSeasonByNumber)
        return array
    }
    
    var sortedEpisodesArray:[EpisodeWatchlistItem] {
        var array = self.allObjects.map {$0 as! EpisodeWatchlistItem}
        array.sortInPlace(sortEpisodeByNumber)
        return array
    }
    
    var sortedCreditsArray:[PersonCredit] {
        var array = self.allObjects.map {$0 as! PersonCredit}
        array.sortInPlace(sortByDateAndName)
        return array
    }
    
    private func sortSeasonByNumber(this:SeasonWatchlistItem, that:SeasonWatchlistItem) -> Bool {
        if let thisSeasonNumber = this.seasonNumber {
            if let thatSeasonNumber = that.seasonNumber {
                return thisSeasonNumber.compare(thatSeasonNumber) == NSComparisonResult.OrderedAscending
            }
        }
        return false
    }
    
    private func sortEpisodeByNumber(this:EpisodeWatchlistItem, that:EpisodeWatchlistItem) -> Bool {
        if let thisEpisodeNumber = this.episodeNumber {
            if let thatEpisodeNumber = that.episodeNumber {
                return thisEpisodeNumber.compare(thatEpisodeNumber) == NSComparisonResult.OrderedAscending
            }
        }
        return false
    }
    
    private func sortByDateAndName(this:PersonCredit, that:PersonCredit) -> Bool {
        if let thisYear = this.releaseDate?.string.yearFromEuropeFormat {
            if let thatYear = that.releaseDate?.string.yearFromEuropeFormat {
                return thatYear < thisYear
            }
        }
        
        if let thisName = this.name {
            if let thatName = that.name {
                return thisName.compare(thatName) == NSComparisonResult.OrderedAscending
            }
        }
        return false
    }
}
