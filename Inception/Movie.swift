//
//  Movie.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class Movie {
    var backdropPath:String?
    var budget:Int?
    var genres:[Genre]?
    var id:Int?
    var overview:String?
    var posterPath:String?
    var productionCompanies:[String]?
    var productionCountries:[String]?
    var releaseDate:String?
    var revenue:Int?
    var runtime:Int?
    var status:String?
    var tagline:String?
    var title:String?
    var voteAverage:Double?
    
    init(backdropPath:String?, budget:Int?, genres:[Genre]?, id:Int?, overview:String?, posterPath:String?, productionCompanies:[String]?,productionCountries:[String]?, releaseDate:String?, revenue:Int?, runtime:Int?, status:String?, tagline:String?, title:String?, voteAverage:Double?) {
        self.backdropPath = backdropPath
        self.budget = budget
        self.genres = genres
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.title = title
        self.voteAverage = voteAverage
    }
    
    init(id:Int?, title:String?, posterPath:String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
}