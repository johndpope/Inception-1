//
//  Genre.swift
//  Inception
//
//  Created by David Ehlen on 26.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Genre {
    var name:String?
    var id:Int?
    
    init(json:JSON) {
        self.name = json["name"].string
        self.id = json["id"].int
    }
    
    init(name:String, id:Int) {
        self.name = name
        self.id = id
    }
}