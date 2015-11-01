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
    
    func updateFrom(viewController:UIViewController) {
        for show in showCoreDataHelper.showsFromStore() {
            if show.lastUpdated.olderThan2Weeks {
                if let showId = show.id {
                    if let seasons = show.seasons {
                        //update episodes for already saved seasons
                        for season in seasons.array as! [SeasonWatchlistItem] {
                            self.loadEpisodesAndInsert(season, id: show.id)
                        }
                    }
                    //retrieve all seasons
                    APIController.request(APIEndpoints.Show(Int(showId))) { (data:AnyObject?, error:NSError?) in
                        if error != nil {
                            AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:viewController)
                            print(error)
                        } else {
                            show.lastUpdated = NSDate()
                            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                            //save season if new
                            let requestedShow = Show(json: JSON(data!))
                            if let requestedSeasons = requestedShow.seasons {
                                if show.seasons != nil {
                                    self.insertNewSeasons(requestedSeasons, currentData: show.seasons!.array as? [SeasonWatchlistItem], show: show)
                                }
                                else {
                                    self.insertNewSeasons(requestedSeasons, currentData: nil, show: show)
                                }
                            }
                        }
                    }
                }
            
            }
            else {
                if show.lastUpdated.isToday {
                    return
                }
                //TODO:load and parse delta from lastUpdated until now, check if season with id or episode with id is not present ==> insert
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
                        let newCDSeason = self.showCoreDataHelper.insertSeason(potentialNewSeasonId,seasonNumber: potentialNewSeason.seasonNumber,show: show,episodes: nil)
                        self.loadEpisodesAndInsert(newCDSeason, id: show.id)
                    }
                }
                else {
                    let newCDSeason = self.showCoreDataHelper.insertSeason(potentialNewSeasonId,seasonNumber: potentialNewSeason.seasonNumber,show: show,episodes: nil)
                    self.loadEpisodesAndInsert(newCDSeason, id: show.id)
                }
            }
        }
    }
    
    func loadEpisodesAndInsert(season:SeasonWatchlistItem,id:NSNumber?) {
        if let seasonNumber = season.seasonNumber {
            if id != nil {
                APIController.request(APIEndpoints.SeasonsForShow(Int(id!), Int(seasonNumber))) { (data:AnyObject?, error:NSError?) in
                    if (error != nil) {
                        print(error)
                    } else {
                        let episodes = JSONParser.parseEpisodes(data)
                        if season.episodes != nil {
                            self.insertNewEpisodes(episodes, currentData: season.episodes!.array as? [EpisodeWatchlistItem], season: season)
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