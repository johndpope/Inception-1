//
//  JSONParser.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
    
    class func mutliSearchResults(data:AnyObject?) -> [MultiSearchResult] {
        var parsedResults:[MultiSearchResult] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                var mediaType = ""
                if let mtype = json["results"][i]["media_type"].string {
                    mediaType = mtype
                }
                var name = ""
                var imagePath = ""
                var id = 0
                
                if let resultId = json["results"][i]["id"].int {
                    id = resultId
                }
                
                switch mediaType {
                case "movie":
                    if let title = json["results"][i]["title"].string {
                        name = title
                    }
                    if let ip = json["results"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
                case "tv","person":
                    if let na = json["results"][i]["name"].string {
                        name = na
                    }
                    if let ip = json["results"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
                default:
                    break
                }
                
                let multiSearchResult = MultiSearchResult(mediaType: mediaType, name: name, imagePath: imagePath, id:id)
                parsedResults.append(multiSearchResult)
            }
        }
        return parsedResults
    }
    
    class func parseTrailerKey(data:AnyObject?) -> String? {
        let json = JSON(data!)
        if let resultsArray = json["results"].array {
            for i in 0..<resultsArray.count {
                if let site = json["results"][i]["site"].string {
                    if site == "YouTube" {
                        if let key=json["results"][i]["key"].string {
                            return key
                        }
                    }
                }
            }
        }
        return nil
    }
    
    class func similarMovies(data:AnyObject?) -> [Movie] {
        var parsedResults:[Movie] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                let movie = Movie(id: json["results"][i]["id"].int, title: json["results"][i]["title"].string, posterPath: json["results"][i]["poster_path"].string)
                parsedResults.append(movie)
            }
        }
        return parsedResults
    }
    
    class func parseCreditsPerson(data:AnyObject?) -> [CreditsPerson] {
        let json = JSON(data!)
        var returnCastArray:[CreditsPerson] = []

        if let castArray = json["cast"].array {
            for i in 0..<castArray.count {
                let p = CreditsPerson(id: json["cast"][i]["id"].int, character: json["cast"][i]["character"].string, name: json["cast"][i]["name"].string, profilePath: json["cast"][i]["profile_path"].string)
    
                returnCastArray.append(p)
            }
        
        }
        
        return returnCastArray
    }
    
    class func parseCreditsCrew(data:AnyObject?) -> [CreditsCrew] {
        let json = JSON(data!)
        var returnCrewArray:[CreditsCrew] = []
        
        if let crewArray = json["crew"].array {
            for j in 0..<crewArray.count {
                let p = CreditsCrew(id: json["crew"][j]["id"].int, job: json["crew"][j]["job"].string, name: json["crew"][j]["name"].string, profilePath: json["crew"][j]["profile_path"].string)
                
                returnCrewArray.append(p)
            }
            
        }
        return returnCrewArray

    }
    
    class func parsePerson(data:AnyObject?) -> Person {
        let json = JSON(data!)
        let person = Person(biography: json["biography"].string, birthday: json["birthday"].string, deathday: json["deathday"].string, id: json["id"].int, name: json["name"].string, placeOfBirth: json["place_of_birth"].string, profilePath: json["profile_path"].string)
        return person
    }
    
    
    class func parseCombinedCredits(data:AnyObject?) -> [MultiSearchResult] {
        var parsedResults:[MultiSearchResult] = []
        
        let json = JSON(data!)
        if let results = json["cast"].array {
            for i in 0..<results.count {
                var mediaType = ""
                if let mtype = json["cast"][i]["media_type"].string {
                    mediaType = mtype
                }
                var name = ""
                var imagePath = ""
                var id = 0
                
                if let resultId = json["cast"][i]["id"].int {
                    id = resultId
                }
                
                switch mediaType {
                case "movie":
                    if let title = json["cast"][i]["title"].string {
                        name = title
                    }
                    if let ip = json["cast"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
                case "tv":
                    if let na = json["cast"][i]["name"].string {
                        name = na
                    }
                    if let ip = json["cast"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
               
                default:
                    break
                }
                
                let multiSearchResult = MultiSearchResult(mediaType: mediaType, name: name, imagePath: imagePath, id:id)
                parsedResults.append(multiSearchResult)
            }
        }
        
        if let results = json["crew"].array {
            for i in 0..<results.count {
                var mediaType = ""
                if let mtype = json["crew"][i]["media_type"].string {
                    mediaType = mtype
                }
                var name = ""
                var imagePath = ""
                var id = 0
                
                if let resultId = json["crew"][i]["id"].int {
                    id = resultId
                }
                
                switch mediaType {
                case "movie":
                    if let title = json["crew"][i]["title"].string {
                        name = title
                    }
                    if let ip = json["crew"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
                case "tv":
                    if let na = json["crew"][i]["name"].string {
                        name = na
                    }
                    if let ip = json["crew"][i]["poster_path"].string {
                        imagePath = ip
                    }
                    break;
                    
                default:
                    break
                }
                
                let multiSearchResult = MultiSearchResult(mediaType: mediaType, name: name, imagePath: imagePath, id:id)
                parsedResults.append(multiSearchResult)
            }
        }
        return parsedResults
    }

    class func parseShow(data:AnyObject?) -> Show {
        let json = JSON(data!)
        var genres:[Genre]? = nil
        var productionCompanies:[String]? = nil
        var createdBy:[String]? = nil
        var episodeRuntime:[Int]? = nil
        var networks:[String]? = nil
        var originCountries:[String]? = nil
        var seasons:[Season]? = nil

        if let genreArray = json["genres"].array {
            for i in 0..<genreArray.count {
                var genreName:String?
                var genreId:Int?
                if let jsonGenreName = json["genres"][i]["name"].string {
                    genreName = jsonGenreName
                }
                if let jsonGenreId = json["genres"][i]["id"].int {
                    genreId = jsonGenreId
                }
                let genre = Genre(name:genreName,id:genreId)
                if genres != nil {
                    genres?.append(genre)
                }
                else {
                    genres = [genre]
                }
            }
        }
        
        if let productionCompaniesArray = json["production_companies"].array {
            for j in 0..<productionCompaniesArray.count {
                if let productionCompanyName = json["production_companies"][j]["name"].string {
                    if productionCompanies != nil {
                        productionCompanies!.append(productionCompanyName)
                    }
                    else {
                        productionCompanies = [productionCompanyName]
                    }
                }
            }
        }
        
        if let createdByArray = json["created_by"].array {
            for k in 0..<createdByArray.count {
                if let createdByName = json["created_by"][k]["name"].string {
                    if createdBy != nil {
                        createdBy!.append(createdByName)
                    }
                    else {
                        createdBy = [createdByName]
                    }
                }
            }
        }
        
        if let episodeRuntimeArray = json["episode_run_time"].array {
            for h in 0..<episodeRuntimeArray.count {
                if let runtime = json["episode_run_time"][h].int {
                    if episodeRuntime != nil {
                        episodeRuntime!.append(runtime)
                    }
                    else {
                        episodeRuntime = [runtime]
                    }
                }
            }
        }
        
        if let networksArray = json["networks"].array {
            for g in 0..<networksArray.count {
                if let networkName = json["networks"][g]["name"].string {
                    if networks != nil {
                        networks!.append(networkName)
                    }
                    else {
                        networks = [networkName]
                    }
                }
            }
        }
        
        if let originCountriesArray = json["origin_country"].array {
            for f in 0..<originCountriesArray.count {
                if let originCountryName = json["origin_country"][f].string {
                    if originCountries != nil {
                        originCountries!.append(originCountryName)
                    }
                    else {
                        originCountries = [originCountryName]
                    }
                }
            }
        }
        
        if let seasonsArray = json["seasons"].array {
            for s in 0..<seasonsArray.count {
                let seasonObj = Season(airDate: json["seasons"][s]["air_date"].string, episodeCount: json["seasons"][s]["episode_count"].int, id: json["seasons"][s]["id"].int, posterPath: json["seasons"][s]["poster_path"].string, seasonNumber: json["seasons"][s]["season_number"].int)
              
                if seasons != nil {
                    seasons!.append(seasonObj)
                }
                else {
                    seasons = [seasonObj]
                }

            }
        }

        return Show(backdropPath: json["backdrop_path"].string, genres: genres, id: json["id"].int, overview: json["overview"].string, posterPath: json["poster_path"].string, productionCompanies: productionCompanies, status: json["status"].string, title: json["name"].string, voteAverage: json["vote_average"].double, createdBy: createdBy, episodeRunTime: episodeRuntime, firstAirDate: json["first_air_date"].string, inProduction: json["in_production"].bool, lastAirDate: json["last_air_date"].string, networks: networks, numberOfEpisodes: json["number_of_episodes"].int, numberOfSeasons: json["number_of_seasons"].int, originCountries: originCountries, type: json["type"].string, seasons: seasons)
    }
    
    class func similarShows(data:AnyObject?) -> [Show] {
        var parsedResults:[Show] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                let show = Show(id: json["results"][i]["id"].int, title: json["results"][i]["title"].string, posterPath: json["results"][i]["poster_path"].string)
                parsedResults.append(show)
            }
        }
        return parsedResults
    }
    
}