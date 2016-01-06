//
//  SearchCoreDataHelper.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import UIKit
import CoreData

class SearchCoreDataHelper {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let kLastSearchedItemEntityName = "LastSearchedItem"
    
    func searchesFromStore() -> [LastSearchedItem] {
        let fetchRequest = NSFetchRequest(entityName: kLastSearchedItemEntityName)
        var searches:[LastSearchedItem] = []
        do {
            searches = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [LastSearchedItem]
            searches.sortInPlace(timestampFilter)
            return searches
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return searches
    }
    
    func timestampFilter(this:LastSearchedItem, that:LastSearchedItem) -> Bool {
        return this.timestamp.compare(that.timestamp) == NSComparisonResult.OrderedDescending
    }

    func insertSearchItem(id:Int, mediaType:String, name:String?, year:Int?, posterPath:String?,timestamp:NSDate) {
        let storedSearches = searchesFromStore()
        if storedSearches.count >= 10 {
            removeSearchItem(oldestSearch(storedSearches))
        }
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(kLastSearchedItemEntityName, inManagedObjectContext: self.managedObjectContext) as! LastSearchedItem
        newEntity.id = id
        newEntity.mediaType = mediaType
        newEntity.name = name
        newEntity.year = year
        newEntity.posterPath = posterPath
        newEntity.timestamp = timestamp

        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func oldestSearch(searchItems:[LastSearchedItem]) -> LastSearchedItem {
        var sortedItems = searchItems
        sortedItems.sortInPlace(timestampFilter)
        return sortedItems.last!
    }
    
    func removeSearchItem(searchItem:LastSearchedItem) {
        self.managedObjectContext.deleteObject(searchItem)
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
}

