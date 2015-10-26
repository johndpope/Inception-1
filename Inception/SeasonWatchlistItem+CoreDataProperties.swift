//
//  SeasonWatchlistItem+CoreDataProperties.swift
//  
//
//  Created by David Ehlen on 25.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SeasonWatchlistItem {

    @NSManaged var id: NSNumber?
    @NSManaged var seasonNumber: NSNumber?
    @NSManaged var show: NSManagedObject?
    @NSManaged var episodes: NSOrderedSet?

}
