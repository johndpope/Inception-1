//
//  Show.swift
//  Inception
//
//  Created by David Ehlen on 29.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Show {
    var backdropPath:String?
    var genres:[Genre]?
    var id:Int?
    var overview:String?
    var posterPath:String?
    var productionCompanies:[String]?
    var status:String?
    var title:String?
    var voteAverage:Double?
    var createdBy:[String]?
    var episodeRunTime:[Int]?
    var firstAirDate:String?
    var inProduction:Bool?
    var lastAirDate:String?
    var networks:[String]?
    var numberOfEpisodes:Int?
    var numberOfSeasons:Int?
    var originCountries:[String]?
    var type:String?
    var seasons:[Season]?
    
    init(json:JSON) {
        var genres:[Genre] = []
        var productionCompanies:[String] = []
        var createdBy:[String] = []
        var episodeRunTime:[Int] = []
        var networks:[String] = []
        var originCountries:[String] = []
        var seasons:[Season] = []
        
        if let items = json["genres"].array {
            for item in items {
                let genre = Genre(json:item)
                genres.append(genre)
            }
        }
        
        if let items = json["production_companies"].array {
            for item in items {
                if let name = item["name"].string {
                    productionCompanies.append(name)
                }
            }
        }
        
        if let items = json["created_by"].array {
            for item in items {
                if let name = item["name"].string {
                    createdBy.append(name)
                }
            }
        }

        
        episodeRunTime = json["episode_run_time"].arrayValue.map{$0.int!}
        
        if let items = json["networks"].array {
            for item in items {
                if let name = item["name"].string {
                    networks.append(name)
                }
            }
        }

        
        originCountries = json["origin_countries"].arrayValue.map{$0.string!}

        
        if let seasonsArray = json["seasons"].array {
            for s in 0..<seasonsArray.count {
                let seasonObj = Season(json: json["seasons"][s])
                seasons.append(seasonObj)
            }
        }
        
        self.backdropPath = json["backdrop_path"].string
        self.genres = genres
        self.id = json["id"].int
        self.overview = json["overview"].string
        self.posterPath = json["poster_path"].string
        self.productionCompanies = productionCompanies
        self.status = json["status"].string
        self.title = json["name"].string
        self.voteAverage = json["vote_average"].double

        self.createdBy = createdBy
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = json["first_air_date"].string
        self.inProduction = json["in_production"].bool
        self.lastAirDate = json["last_air_date"].string
        self.networks = networks
        self.numberOfEpisodes = json["number_of_episodes"].int
        self.numberOfSeasons = json["number_of_seasons"].int
        self.originCountries = originCountries
        self.type = json["type"].string
        self.seasons = seasons
        
    }
}