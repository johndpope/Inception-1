//
//  CreditsCrew.swift
//  Inception
//
//  Created by David Ehlen on 06.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class CreditsCrew {
    var id:Int?
    var job:String?
    var name:String?
    var profilePath:String?
    
    init(id:Int?, job:String?, name:String?, profilePath:String?) {
        self.id = id
        self.job = job
        self.name = name
        self.profilePath = profilePath
    }
}