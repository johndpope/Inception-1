//
//  Episode.swift
//  Inception
//
//  Created by David Ehlen on 08.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Episode {

    var airDate:String?
    var episodeNumber:Int?
    var title:String?
    var overview:String?
    var id:Int?
    var seasonNumber:Int?
    var stillPath:String?
    var voteAverage:Double?
    
    init(json:JSON) {
        self.airDate = json["air_date"].string
        self.episodeNumber = json["episode_number"].int
        self.title = json["title"].string
        self.overview = json["overview"].string
        self.id = json["id"].int
        self.seasonNumber = json["season_number"].int
        self.stillPath = json["still_path"].string
        self.voteAverage = json["vote_average"].double
    }
}