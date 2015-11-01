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
        //TODO: update all shows (new episodes, seasons)
        for show in showCoreDataHelper.showsFromStore() {
            if show.lastUpdated.olderThan2Weeks {
                //load and parse show, check if season with id or episode with id is not present ==> insert
            }
            else {
                //check if updated today => return
                if show.lastUpdated.isToday {
                    return
                }
                //load and parse delta from lastUpdated until now, check if season with id or episode with id is not present ==> insert
            }
        }
    }
    
    func insertNewSeasons(newData:[Season], currentData:[SeasonWatchlistItem], show:ShowWatchlistItem) {
        for potentialNewSeason in newData {
            if let potentialNewSeasonId = potentialNewSeason.id {
                let new = currentData.filter { $0.id == potentialNewSeasonId }
                if new.count == 0 || new.isEmpty {
                    self.showCoreDataHelper.insertSeason(potentialNewSeasonId,seasonNumber: potentialNewSeason.seasonNumber,show: show,episodes: nil)
                }
            }
        }
    }
    
    func insertNewEpisodes(newData:[Episode], currentData:[EpisodeWatchlistItem], season:SeasonWatchlistItem) {
        for potentialNewEpisode in newData {
            if let potentialNewEpisodeId = potentialNewEpisode.id {
                let new = currentData.filter { $0.id == potentialNewEpisodeId }
                if new.count == 0 || new.isEmpty {
                    self.showCoreDataHelper.insertEpisode(season, id: potentialNewEpisodeId, title: potentialNewEpisode.title, stillPath: potentialNewEpisode.stillPath, episodeNumber: potentialNewEpisode.episodeNumber, overview: potentialNewEpisode.overview, airDate: potentialNewEpisode.airDate)
                }
            }
        }
    }
}