//
//  CreditsCrew.swift
//  Inception
//
//  Created by David Ehlen on 06.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditsCrew {
    var id:Int?
    var job:String?
    var name:String?
    var profilePath:String?
    
    init(json:JSON) {
        self.id = json["id"].int
        self.job = json["job"].string
        self.name = json["name"].string
        self.profilePath = json["profile_path"].string
    }
}