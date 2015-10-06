//
//  Season.swift
//  Inception
//
//  Created by David Ehlen on 29.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class Season {
    
    var airDate:String?
    var episodeCount:Int?
    var id:Int?
    var posterPath:String?
    var seasonNumber:Int?
    
    init(airDate:String?, episodeCount:Int?, id:Int?, posterPath:String?, seasonNumber:Int?) {
        self.airDate = airDate
        self.episodeCount = episodeCount
        self.id = id
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
    }
}