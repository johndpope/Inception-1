//
//  Season.swift
//  Inception
//
//  Created by David Ehlen on 29.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Season {
    
    var airDate:String?
    var episodeCount:Int?
    var id:Int?
    var posterPath:String?
    var seasonNumber:Int?
    
    init(json:JSON) {
        self.airDate = json["air_date"].string
        self.episodeCount = json["episode_count"].int
        self.id = json["id"].int
        self.posterPath = json["poster_path"].string
        self.seasonNumber = json["season_number"].int
        
    }
}