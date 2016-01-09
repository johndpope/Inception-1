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
    
    //MARK: Episodes & Seasons 
    class func parseEpisodes(data:AnyObject?) -> [Episode] {
        var episodes:[Episode] = []
        
        let json = JSON(data!)
        if let jsonEpisodesArray = json["episodes"].array {
            for i in 0..<jsonEpisodesArray.count {
                let episode = Episode(json:json["episodes"][i])
                episodes.append(episode)
            }
        }
        return episodes
    }
    
    //MARK: Multi Searches
    class func mutliSearchResults(data:AnyObject?) -> [MultiSearchResult] {
        var parsedResults:[MultiSearchResult] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                if let mediaType = json["results"][i]["media_type"].string {
                    let multiSearchResult = MultiSearchResult(mediaType: mediaType,json:json["results"][i])
                    parsedResults.append(multiSearchResult)
                }
            }
        }
        return parsedResults
    }
    
    class func parseReleases(data:AnyObject?) -> String? {
        let settingsIsoCode = SettingsFactory.objectForKey(SettingsFactory.SettingKey.ReleaseDateCountry) as! String
        var usaReleaseDate:String?
        var releaseDate:String?
        let json = JSON(data!)
        if let items = json["releases"]["countries"].array {
            for item in items {
                if let isoCode = item["iso_3166_1"].string {
                    if isoCode.lowercaseString == "us" {
                        usaReleaseDate = item["release_date"].string
                    }
                    if isoCode == settingsIsoCode {
                        releaseDate = item["release_date"].string
                    }
                }
            }
        }
        
        if releaseDate == nil {
            releaseDate = usaReleaseDate
        }
        return releaseDate
    }
    
    class func parseCombinedCredits(data:AnyObject?) -> [MultiSearchResult] {
        var parsedResults:[MultiSearchResult] = []
        
        let json = JSON(data!)
        if let results = json["cast"].array {
            for i in 0..<results.count {
                if let mediaType = json["cast"][i]["media_type"].string {
                    let multiSearchResult = MultiSearchResult(mediaType: mediaType,json:json["cast"][i])
                    if let id = multiSearchResult.id {
                        let duplicates = parsedResults.filter { $0.id == id }
                        if duplicates.isEmpty {
                            parsedResults.append(multiSearchResult)
                        }
                    }
                    
                }
            }
        }
        
        if let results = json["crew"].array {
            for i in 0..<results.count {
                if let mediaType = json["crew"][i]["media_type"].string {
                    let multiSearchResult = MultiSearchResult(mediaType: mediaType,json:json["crew"][i])
                    if let id = multiSearchResult.id {
                        let duplicates = parsedResults.filter { $0.id == id }
                        if duplicates.isEmpty {
                            parsedResults.append(multiSearchResult)
                        }
                    }
                }
            }
        }
        //Sort after year
        return parsedResults.sort { $0.releaseDate?.year > $1.releaseDate?.year }
    }
    
    //MARK: Genres
    class func parseMovieGenres() -> [Genre] {
        var movieGenres:[Genre] = []
        
        if let path = NSBundle.mainBundle().pathForResource("moviegenres", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if let items = jsonObj["genres"].array {
                    for item in items {
                        let genre = Genre(json:item)
                        movieGenres.append(genre)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return movieGenres
    }
    
    class func parseShowGenres() -> [Genre] {
        var showGenres:[Genre] = []
        
        if let path = NSBundle.mainBundle().pathForResource("showgenres", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if let items = jsonObj["genres"].array {
                    for item in items {
                        let genre = Genre(json:item)
                        showGenres.append(genre)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return showGenres
    }
    
    //MARK: Trailer
    class func parseTrailerVideos(data:AnyObject?) -> [Video] {
        let json = JSON(data!)
        var videos:[Video] = []
        
        if let resultsArray = json["results"].array {
            for i in 0..<resultsArray.count {
                if let site = json["results"][i]["site"].string {
                    if site == "YouTube" {
                        let video = Video(json:json["results"][i])
                        videos.append(video)
                    }
                }
            }
        }
        return videos
    }
    
    //MARK: Results Array
    class func parseMovieResults(data:AnyObject?) -> [Movie] {
        var parsedResults:[Movie] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                let movie = Movie(json: json["results"][i])
                parsedResults.append(movie)
            }
        }
        return parsedResults
    }
    
    class func parseShowResults(data:AnyObject?) -> [Show] {
        var parsedResults:[Show] = []
        
        let json = JSON(data!)
        if let results = json["results"].array {
            for i in 0..<results.count {
                let show = Show(json: json["results"][i])
                parsedResults.append(show)
            }
        }
        return parsedResults
    }

    
    //MARK: Persons & Cast
    class func parseCreditsPerson(data:AnyObject?) -> [CreditsPerson] {
        let json = JSON(data!)
        var returnCastArray:[CreditsPerson] = []

        if let castArray = json["cast"].array {
            for i in 0..<castArray.count {
                let p = CreditsPerson(json:json["cast"][i])
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
                let p = CreditsCrew(json:json["crew"][j])
                returnCrewArray.append(p)
            }
        }
        return returnCrewArray

    }
    
    class func parsePerson(data:AnyObject?) -> Person {
        let json = JSON(data!)
        let person = Person(json:json)
        return person
    }
    
    
}