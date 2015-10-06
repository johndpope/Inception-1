//
//  Person.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class CreditsPerson {
    var id:Int?
    var character:String?
    var name:String?
    var profilePath:String?

    init(id:Int?, character:String?, name:String?, profilePath:String?) {
        self.id = id
        self.character = character
        self.name = name
        self.profilePath = profilePath
    }
}