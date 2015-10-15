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

    init(mediaType:String, json:JSON) {
        self.mediaType = mediaType
        
        switch(mediaType) {
            case "movie":
                self.name = json["title"].string
            case "tv", "person":
                self.name = json["name"].string
        default: ()
        }
        
        self.imagePath = json["poster_path"].string
        self.id = json["id"].int
    }
}