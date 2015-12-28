//
//  ShowWatchlistCoreDataHelper.swift
//  Inception
//
//  Created by David Ehlen on 25.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ShowWatchlistCoreDataHelper {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let kShowWatchlistItemEntityName = "ShowWatchlistItem"
    let kSeasonWatchlistItemEntityName = "SeasonWatchlistItem"
    let kEpisodeWatchlistItemEntityName = "EpisodeWatchlistItem"

    func showsFromStore() -> [ShowWatchlistItem] {
        let fetchRequest = NSFetchRequest(entityName: kShowWatchlistItemEntityName)
        var shows:[ShowWatchlistItem] = []
        do {
            shows = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [ShowWatchlistItem]
            return shows
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return shows
    }
    
    func insertShowItem(id:Int, name:String?, year:Int?, posterPath:String?, lastUpdated:NSDate) {
        
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(kShowWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! ShowWatchlistItem
        newEntity.id = id
        newEntity.name = name
        newEntity.year = year
        newEntity.posterPath = posterPath
        newEntity.lastUpdated = lastUpdated
        newEntity.seasons = nil
        
        self.loadSeasons(id,watchlistShow:newEntity) { (seasons:[SeasonWatchlistItem]) in
            newEntity.seasons = NSOrderedSet(array: seasons)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName("seasonsAndEpisodesDidLoad", object: nil, userInfo: nil)
        }
     }
    
    func insertSeason(id:Int, seasonNumber:Int?, show:ShowWatchlistItem, episodes:[EpisodeWatchlistItem]?) -> SeasonWatchlistItem {
        
        let watchlistSeason = NSEntityDescription.insertNewObjectForEntityForName(self.kSeasonWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! SeasonWatchlistItem
        watchlistSeason.id = id
        watchlistSeason.seasonNumber = seasonNumber
        watchlistSeason.show = show
        if episodes != nil {
            watchlistSeason.episodes = NSOrderedSet(array:episodes!)
        }
        
        if let seasons = show.seasons {
            let mutableSeasons = seasons.mutableCopy() as! NSMutableOrderedSet
            mutableSeasons.addObject(watchlistSeason)
            show.seasons = mutableSeasons.copy() as? NSOrderedSet
        }
        else {
            show.seasons = NSOrderedSet(array: [watchlistSeason])
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        return watchlistSeason
    }
    
    func insertEpisode(season:SeasonWatchlistItem, id:Int, title:String?, stillPath:String?, episodeNumber:Int?, overview:String?, airDate:String?) {
        
        let watchlistEpisode = NSEntityDescription.insertNewObjectForEntityForName(self.kEpisodeWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! EpisodeWatchlistItem
        watchlistEpisode.name = title
        watchlistEpisode.id = id
        watchlistEpisode.posterPath = stillPath
        watchlistEpisode.episodeNumber = episodeNumber
        watchlistEpisode.overview = overview
        watchlistEpisode.airDate = airDate
        watchlistEpisode.season = season
        watchlistEpisode.seen = false
        
        if let episodes = season.episodes {
            let mutableEpisodes = episodes.mutableCopy() as! NSMutableOrderedSet
            mutableEpisodes.addObject(watchlistEpisode)
            season.episodes = mutableEpisodes.copy() as? NSOrderedSet
        }
        else {
            season.episodes = NSOrderedSet(array: [watchlistEpisode])
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    private func loadSeasons(id:Int,watchlistShow:ShowWatchlistItem,completionClosure:[SeasonWatchlistItem] -> ()) {
        APIController.request(APIEndpoints.Show(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
                completionClosure([])
            } else {
                let show = Show(json: JSON(data!))
                if let episodeRunTime = show.episodeRunTime {
                    if episodeRunTime.count > 0 {
                        watchlistShow.episodeRuntime = episodeRunTime[0]
                    }
                }
                if let seasons = show.seasons {
                    var watchlistSeasons:[SeasonWatchlistItem] = []
                    var requestCount = seasons.count
                    for i in 0..<seasons.count {
                        let watchlistSeason = NSEntityDescription.insertNewObjectForEntityForName(self.kSeasonWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! SeasonWatchlistItem
                        watchlistSeason.id = seasons[i].id
                        watchlistSeason.seasonNumber = seasons[i].seasonNumber
                        watchlistSeason.show = watchlistShow
                        self.loadEpisodes(watchlistSeason, id: id, completionClosure: { (episodes:NSOrderedSet) in
                            watchlistSeason.episodes = episodes
                            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                            watchlistSeasons.append(watchlistSeason)
                            requestCount--
                            if requestCount == 0 {
                                completionClosure(watchlistSeasons)
                            }
                        })
                    }
                }
                else {
                    completionClosure([])
                }
            }
        }
    }

    
    private func loadEpisodes(season:SeasonWatchlistItem, id:Int, completionClosure:NSOrderedSet -> ()) {
        
        if let seasonNumber = season.seasonNumber {
            if seasonNumber > 0 {
                APIController.request(APIEndpoints.SeasonsForShow(id, Int(seasonNumber))) { (data:AnyObject?, error:NSError?) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        completionClosure([])
                    } else {
                        let episodes = JSONParser.parseEpisodes(data)
                        var watchlistEpisodes:[EpisodeWatchlistItem] = []
                        for episode in episodes {
                            let watchlistEpisode = NSEntityDescription.insertNewObjectForEntityForName(self.kEpisodeWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! EpisodeWatchlistItem
                            watchlistEpisode.name = episode.title
                            watchlistEpisode.id = episode.id
                            watchlistEpisode.posterPath = episode.stillPath
                            watchlistEpisode.episodeNumber = episode.episodeNumber
                            watchlistEpisode.overview = episode.overview
                            watchlistEpisode.airDate = episode.airDate
                            watchlistEpisode.season = season
                            watchlistEpisode.seen = false
                            watchlistEpisodes.append(watchlistEpisode)
                        }
                        completionClosure(NSOrderedSet(array: watchlistEpisodes))
                    }
                }
            }
            else {
                completionClosure(NSOrderedSet(array:[]))  
            }
        }
        else {
            completionClosure(NSOrderedSet(array:[]))
        }
    }
    
    func isShowSeen(show:ShowWatchlistItem) -> Bool {
        if let seasonsSet = show.seasons {
            for seasons in seasonsSet.array as! [SeasonWatchlistItem] {
                if let episodesSet = seasons.episodes {
                    for episode in episodesSet.array as! [EpisodeWatchlistItem] {
                        if let seen = episode.seen {
                            if Bool(seen) == false {
                                return false
                            }
                        }
                        else {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func setShowSeenState(show:ShowWatchlistItem,seen:Bool) {
        if let seasonsSet = show.seasons {
            for seasons in seasonsSet.array as! [SeasonWatchlistItem] {
                if let episodesSet = seasons.episodes {
                    for episode in episodesSet.array as! [EpisodeWatchlistItem] {
                        episode.seen = seen
                    }
                }
            }
        }
		
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func isEpisodeSeen(id:Int) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: kEpisodeWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[EpisodeWatchlistItem] {
                if fetchResults.count != 0 {
                    let managedObject = fetchResults[0]
                    if let seen = managedObject.seen {
                        return Bool(seen)
                    }
                    return false
                }
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return false
    }
    
    func setEpisodeSeenState(seen:Bool, id:Int) {
        let fetchRequest = NSFetchRequest(entityName: kEpisodeWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[EpisodeWatchlistItem] {
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

    func updateShowSeenState(seen:Bool, id:Int) {
        let fetchRequest = NSFetchRequest(entityName: kShowWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[ShowWatchlistItem] {
                if fetchResults.count != 0 {
                    
                    let managedObject = fetchResults[0]
                    self.setShowSeenState(managedObject, seen:seen)
                    (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                }
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }

    }
    
    func showProgress(id:Int) -> Float {
        var seenCount:Int = 0
        var totalCount:Int = 0
        if let show = self.showWithId(id) {
            if let seasonsSet = show.seasons {
                for seasons in seasonsSet.array as! [SeasonWatchlistItem] {
                    if let episodesSet = seasons.episodes {
                        for episode in episodesSet.array as! [EpisodeWatchlistItem] {
                            if episode.seen == true {
                                seenCount += 1
                            }
                            totalCount += 1
                        }
                    }
                }
            }
        }
        return Float(seenCount)/Float(totalCount)
    }
    
    func removeShow(show:ShowWatchlistItem) {
        self.managedObjectContext.deleteObject(show)
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func removeShowWithId(id:Int) {
        if let show = self.showWithId(id) {
            self.removeShow(show)
        }
    }
    
    func hasShow(id:Int) -> Bool {
        return self.showWithId(id) != nil
    }
    
    func showWithId(id:Int) -> ShowWatchlistItem? {
        let fetchRequest = NSFetchRequest(entityName: kShowWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[ShowWatchlistItem] {
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

