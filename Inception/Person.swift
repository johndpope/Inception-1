//
//  Person.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Person {
    var biography:String?
    var birthday:String?
    var deathday:String?
    var id:Int?
    var name:String?
    var placeOfBirth:String?
    var profilePath:String?
    
    init(json:JSON) {
        self.biography = json["biography"].string
        self.birthday = json["birthday"].string
        self.deathday = json["deathday"].string
        self.id = json["id"].int
        self.name = json["name"].string
        self.placeOfBirth = json["place_of_birth"].string
        self.profilePath = json["profile_path"].string
    }
}