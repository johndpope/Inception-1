//
//  EpisodeWatchlistItem+CoreDataProperties.swift
//  
//
//  Created by David Ehlen on 26.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EpisodeWatchlistItem {

    @NSManaged var airDate: String?
    @NSManaged var episodeNumber: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var overview: String?
    @NSManaged var posterPath: String?
    @NSManaged var seen: NSNumber?
    @NSManaged var season: SeasonWatchlistItem?
}
