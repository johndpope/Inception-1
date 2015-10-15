//
//  Movie.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    
    
    init(json:JSON) {
        var genres:[Genre] = []
        var productionCompanies:[String] = []
        var productionCountries:[String] = []
        
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
        
        if let items = json["production_countries"].array {
            for item in items {
                if let name = item["name"].string {
                    productionCountries.append(name)
                }
            }
        }
        
        self.backdropPath = json["backdrop_path"].string
        self.budget = json["budget"].int
        self.genres = genres
        self.id = json["id"].int
        self.overview = json["overview"].string
        self.posterPath = json["poster_path"].string
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = json["release_date"].string
        self.revenue = json["revenue"].int
        self.runtime = json["runtime"].int
        self.status = json["status"].string
        self.tagline = json["tagline"].string
        self.title = json["title"].string
        self.voteAverage = json["vote_average"].double
    }
}