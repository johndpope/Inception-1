//
//  MultiSearchResult.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

class MultiSearchResult {
    var mediaType:String
    var name:String
    var imagePath:String
    var id:Int

    init(mediaType:String, name:String, imagePath: String, id:Int) {
        self.mediaType = mediaType
        self.name = name
        self.imagePath = imagePath
        self.id = id
    }
}