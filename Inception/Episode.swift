//
//  Episode.swift
//  Inception
//
//  Created by David Ehlen on 08.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class Episode {

    var airDate:String?
    var episodeNumber:Int?
    var title:String?
    var overview:String?
    var id:Int?
    var seasonNumber:Int?
    var stillPath:String?
    var voteAverage:Int?
    
    init(airDate:String?, episodeNumber:Int?, title:String?, overview:String?, id:Int?, seasonNumber:Int?, stillPath:String?, voteAverage:Int?) {
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.title = title
        self.overview = overview
        self.id = id
        self.seasonNumber = seasonNumber
        self.stillPath = stillPath
        self.voteAverage = voteAverage
    }
}