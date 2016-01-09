//
//  MultiSearchResult.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MultiSearchResult {
    var mediaType:String
    var name:String?
    var imagePath:String?
    var id:Int?
    var releaseDate:String?

    init(mediaType:String, json:JSON) {
        self.mediaType = mediaType
        
        switch(mediaType) {
            case "movie":
                self.name = json["title"].string
                self.releaseDate = json["release_date"].string
                self.imagePath = json["poster_path"].string
            case "tv":
                self.name = json["name"].string
                self.releaseDate = json["first_air_date"].string
                self.imagePath = json["poster_path"].string
            case "person":
                self.name = json["name"].string
                self.imagePath = json["profile_path"].string
        default:
            assert(false, "Unexpected media type")

        }
        
        self.id = json["id"].int
    }
}