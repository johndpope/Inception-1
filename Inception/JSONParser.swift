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
    
    class func parseCombinedCredits(data:AnyObject?) -> [MultiSearchResult] {
        var parsedResults:[MultiSearchResult] = []
        
        let json = JSON(data!)
        if let results = json["cast"].array {
            for i in 0..<results.count {
                if let mediaType = json["cast"][i]["media_type"].string {
                    let multiSearchResult = MultiSearchResult(mediaType: mediaType,json:json["cast"][i])
                    parsedResults.append(multiSearchResult)
                }
            }
        }
        
        if let results = json["crew"].array {
            for i in 0..<results.count {
                if let mediaType = json["crew"][i]["media_type"].string {
                    let multiSearchResult = MultiSearchResult(mediaType: mediaType,json:json["crew"][i])
                    parsedResults.append(multiSearchResult)
                }
            }
        }

        return parsedResults
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
    //TODO: Alle Trailer zurückgeben, um alle anzuzeigen
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