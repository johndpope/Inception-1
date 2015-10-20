//
//  Video.swift
//  Inception
//
//  Created by David Ehlen on 19.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Video {
    var key:String?
    var site:String?
    var name:String?
    var size:Int?
    var id:String?
    var type:String?
    var iso6391:String?
    
    init(json:JSON) {
        self.key = json["key"].string
        self.site = json["site"].string
        self.name = json["name"].string
        self.size = json["size"].int
        self.id = json["id"].string
        self.type = json["type"].string
        self.iso6391 = json["iso_639_1"].string
    }
}
