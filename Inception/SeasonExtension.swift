//
//  SeasonExtension.swift
//  Inception
//
//  Created by David Ehlen on 21.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

extension CollectionType where Generator.Element == Season {
    func seasonWithNumber(number:Int) -> Season?{
        for season in self {
            if let seasonNumber = season.seasonNumber {
                if seasonNumber == number {
                    return season
                }
            }
        }
        return nil
    }
    
    func seasonCount() -> Int {
        var count = 0
        for season in self {
            if let seasonNumber = season.seasonNumber {
                if seasonNumber > 0 {
                    count++
                }
            }
        }
        return count
    }
}