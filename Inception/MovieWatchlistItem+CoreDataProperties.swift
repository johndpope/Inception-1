//
//  MovieWatchlistItem+CoreDataProperties.swift
//  
//
//  Created by David Ehlen on 23.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MovieWatchlistItem {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var posterPath: String?
    @NSManaged var seen: NSNumber?
    @NSManaged var year: NSNumber?

}
