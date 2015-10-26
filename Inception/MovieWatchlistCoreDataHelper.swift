//
//  WatchlistViewController+Movie.swift
//  Inception
//
//  Created by David Ehlen on 23.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import CoreData

class MovieWatchlistCoreDataHelper {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let kMovieWatchlistItemEntityName = "MovieWatchlistItem"
    
    func moviesFromStore() -> [MovieWatchlistItem] {
        let fetchRequest = NSFetchRequest(entityName: kMovieWatchlistItemEntityName)
        var movies:[MovieWatchlistItem] = []
        do {
            movies = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [MovieWatchlistItem]
            return movies
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return movies
    }
    
    func insertMovieItem(id:Int, name:String?, year:Int?, posterPath:String?, seen:Bool) {
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(kMovieWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! MovieWatchlistItem
        newEntity.id = id
        newEntity.name = name
        newEntity.year = year
        newEntity.posterPath = posterPath
        newEntity.seen = seen
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func updateMovieSeenState(seen:Bool,id:Int) {
       
        let fetchRequest = NSFetchRequest(entityName: kMovieWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[MovieWatchlistItem] {
                if fetchResults.count != 0 {
                    
                    let managedObject = fetchResults[0]
                    managedObject.seen = seen
                    (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                }
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func removeMovie(movie:MovieWatchlistItem) {
        self.managedObjectContext.deleteObject(movie)
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func removeMovieWithId(id:Int) {
        if let movie = self.movieWithId(id) {
            self.removeMovie(movie)
        }
    }
    
    func hasMovie(id:Int) -> Bool {
       return self.movieWithId(id) != nil
    }
    
    private func movieWithId(id:Int) -> MovieWatchlistItem? {
        let fetchRequest = NSFetchRequest(entityName: kMovieWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[MovieWatchlistItem] {
                if fetchResults.count != 0 {
                   return fetchResults[0]
                }
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil
    }
}
