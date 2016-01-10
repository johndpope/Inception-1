//
//  ShowUpdater.swift
//  Inception
//
//  Created by David Ehlen on 30.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShowUpdater {
    
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()
    var asyncOperations:Int = 0
    let notification = CWStatusBarNotification()
    var delegate:ShowUpdaterDelegate?
    
    func updateFrom(viewController:UIViewController) {
        let showArray = showCoreDataHelper.showsFromStore()
        var hasToUpdate = false
        
        self.notification.notificationAnimationInStyle = CWNotificationAnimationStyle.Top
        self.notification.notificationAnimationOutStyle = CWNotificationAnimationStyle.Top
        self.notification.notificationLabelBackgroundColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        
        for show in showArray {
            if !show.lastUpdated.isToday {
                hasToUpdate = true
            }
        }
        
        if hasToUpdate {
            self.notification.displayNotificationWithMessage("updatingShows".localized, completion: {})
        }
        else {
            return
        }
        
        for i in 0..<showArray.count {
            let show = showArray[i]
            if show.lastUpdated.isToday {
                continue
            }
            if let showId = show.id {
                if let seasons = show.seasons {
                    //update episodes for already saved seasons
                    for season in seasons.sortedSeasonArray as [SeasonWatchlistItem] {
                        self.loadEpisodesAndInsert(season, id: show.id)
                    }
                }
                self.asyncOperations+=1
                APIController.request(APIEndpoints.Show(Int(showId))) { (data:AnyObject?, error:NSError?) in
                    self.asyncOperations--
                    if self.asyncOperations == 0 {
                        self.notification.dismissNotification()
                        if let delegate = self.delegate {
                            delegate.didUpdateShows()
                        }
                    }
                    if error != nil {
                        AlertFactory.showAlert("errorTitle",localizeMessageKey:"couldNotUpdateMessage", from:viewController)
                        print(error)
                    } else {
                        show.lastUpdated = NSDate()
                        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                        //save season if new
                        let requestedShow = Show(json: JSON(data!))
                        if let requestedSeasons = requestedShow.seasons {
                            if show.seasons != nil {
                                self.insertNewSeasons(requestedSeasons, currentData: show.seasons!.sortedSeasonArray, show: show)
                            }
                            else {
                                self.insertNewSeasons(requestedSeasons, currentData: nil, show: show)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func insertNewSeasons(newData:[Season], currentData:[SeasonWatchlistItem]?, show:ShowWatchlistItem) {
        for potentialNewSeason in newData {
            if let potentialNewSeasonId = potentialNewSeason.id {
                if currentData != nil {
                    //if new season is inserted load episodes for this season and insert
                    let new = currentData!.filter { $0.id == potentialNewSeasonId }
                    if new.isEmpty {
                        if let seasonNumber = potentialNewSeason.seasonNumber {
                            if seasonNumber != 0 {
                                let newCDSeason = self.showCoreDataHelper.insertSeason(potentialNewSeasonId,seasonNumber:seasonNumber,show: show,episodes: nil)
                                self.loadEpisodesAndInsert(newCDSeason, id: show.id)
                            }
                        }
                    }
                }
                else {
                    if let seasonNumber = potentialNewSeason.seasonNumber {
                        if seasonNumber != 0 {
                            let newCDSeason = self.showCoreDataHelper.insertSeason(potentialNewSeasonId,seasonNumber: seasonNumber,show: show,episodes: nil)
                            self.loadEpisodesAndInsert(newCDSeason, id: show.id)
                        }
                    }
                }
            }
        }
    }
    
    func loadEpisodesAndInsert(season:SeasonWatchlistItem,id:NSNumber?) {
        if let seasonNumber = season.seasonNumber {
            if id != nil {
                self.asyncOperations++
                
                APIController.request(APIEndpoints.SeasonsForShow(Int(id!), Int(seasonNumber))) { (data:AnyObject?, error:NSError?) in
                    self.asyncOperations--
                    if self.asyncOperations == 0 {
                        self.notification.dismissNotification()
                        if let delegate = self.delegate {
                            delegate.didUpdateShows()
                        }
                    }
                    if (error != nil) {
                        print(error)
                    } else {
                        let episodes = JSONParser.parseEpisodes(data)
                        if season.episodes != nil {
                            self.insertNewEpisodes(episodes, currentData: season.episodes!.sortedEpisodesArray, season: season)
                        }
                        else {
                            self.insertNewEpisodes(episodes, currentData:nil, season: season)
                        }
                    }
                }
            }
        }
    }
    
    
    func insertNewEpisodes(newData:[Episode], currentData:[EpisodeWatchlistItem]?, season:SeasonWatchlistItem) {
        for potentialNewEpisode in newData {
            if let potentialNewEpisodeId = potentialNewEpisode.id {
                if currentData != nil {
                    let new = currentData!.filter { $0.id == potentialNewEpisodeId }
                    if new.isEmpty {
                        self.showCoreDataHelper.insertEpisode(season, id: potentialNewEpisodeId, title: potentialNewEpisode.title, stillPath: potentialNewEpisode.stillPath, episodeNumber: potentialNewEpisode.episodeNumber, overview: potentialNewEpisode.overview, airDate: potentialNewEpisode.airDate)
                    }
                }
                else {
                    self.showCoreDataHelper.insertEpisode(season, id: potentialNewEpisodeId, title: potentialNewEpisode.title, stillPath: potentialNewEpisode.stillPath, episodeNumber: potentialNewEpisode.episodeNumber, overview: potentialNewEpisode.overview, airDate: potentialNewEpisode.airDate)
                }
            }
        }
    }
}