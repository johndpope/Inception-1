//
//  Show.swift
//  Inception
//
//  Created by David Ehlen on 29.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

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
    
    init(backdropPath:String?, genres:[Genre]?, id:Int?, overview:String?, posterPath:String?, productionCompanies:[String]?,status:String?,title:String?, voteAverage:Double?, createdBy:[String]?, episodeRunTime:[Int]?, firstAirDate:String?, inProduction:Bool?, lastAirDate:String?, networks:[String]?, numberOfEpisodes:Int?, numberOfSeasons:Int?, originCountries:[String]?, type:String?, seasons:[Season]?) {
        self.backdropPath = backdropPath
        self.genres = genres
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.status = status
        self.title = title
        self.voteAverage = voteAverage
        
        self.createdBy = createdBy
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = firstAirDate
        self.inProduction = inProduction
        self.lastAirDate = lastAirDate
        self.networks = networks
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.originCountries = originCountries
        self.type = type
        self.seasons = seasons
    }
    
    init(id:Int?, title:String?, posterPath:String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
}