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
    var delegate:ShowWatchlistCoreDataHelperDelegate?

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
    
    func insertShowItem(id:Int, name:String?, year:Int?, posterPath:String?, seasons:NSSet?) {
        
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(kShowWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! ShowWatchlistItem
        newEntity.id = id
        newEntity.name = name
        newEntity.year = year
        newEntity.posterPath = posterPath
        
        var seasonArray:[SeasonWatchlistItem] = []
        self.loadSeasons(id,watchlistShow:newEntity) { (seasons:[SeasonWatchlistItem]) in
            seasonArray = seasons
            newEntity.seasons = NSOrderedSet(array:seasonArray)
            for season in seasonArray {
                self.loadEpisodes(season,id:id) { (episodes:NSOrderedSet) in
                    season.episodes = episodes
                }
            }
            if let delegate = self.delegate {
                delegate.didLoadSeasonsAndEpisodes()
            }
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
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
                            watchlistEpisodes.append(watchlistEpisode)
                        }
                        completionClosure(NSOrderedSet(array: watchlistEpisodes))
                    }
                }
            }
        }
    }
    
    private func loadSeasons(id:Int,watchlistShow:ShowWatchlistItem,completionClosure:[SeasonWatchlistItem] -> ()) {
        APIController.request(APIEndpoints.Show(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
                completionClosure([])
            } else {
                let show = Show(json: JSON(data!))
                if let seasons = show.seasons {
                    var watchlistSeasons:[SeasonWatchlistItem] = []
                    for season in seasons {
                        let watchlistSeason = NSEntityDescription.insertNewObjectForEntityForName(self.kSeasonWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! SeasonWatchlistItem
                        watchlistSeason.id = season.id
                        watchlistSeason.episodes = nil
                        watchlistSeason.seasonNumber = season.seasonNumber
                        watchlistSeason.show = watchlistShow
                        watchlistSeasons.append(watchlistSeason)
                    }
                    completionClosure(watchlistSeasons)
                }
                else {
                    completionClosure([])
                }
            }
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
            return true
        }
        return false
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
    
    private func showWithId(id:Int) -> ShowWatchlistItem? {
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

