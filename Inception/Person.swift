//
//  Person.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class Person {
    var biography:String?
    var birthday:String?
    var deathday:String?
    var id:Int?
    var name:String?
    var placeOfBirth:String?
    var profilePath:String?
    
    init(biography:String?, birthday:String?, deathday:String?, id:Int?, name:String?, placeOfBirth:String?, profilePath:String?) {
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.id = id
        self.name = name
        self.placeOfBirth = placeOfBirth
        self.profilePath = profilePath
    }
}