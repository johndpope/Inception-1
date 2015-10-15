//
//  Person.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditsPerson {
    var id:Int?
    var character:String?
    var name:String?
    var profilePath:String?

    init(json:JSON) {
        self.id = json["id"].int
        self.character = json["character"].string
        self.name = json["name"].string
        self.profilePath = json["profile_path"].string
    }
}