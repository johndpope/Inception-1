//
//  EpisodeGuideWatchlistViewController+EpisodeWatchlistTableViewCellDelegate.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import AIFlatSwitch

extension EpisodeGuideWatchlistViewController : EpisodeWatchlistTableViewCellDelegate {
    func didToggleSeenFromEpisodeSwitch(sender: AIFlatSwitch) {
        let buttonFrame = sender.convertRect(sender.bounds, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin)
        if let indexPathUnwrapped = indexPath {
            if let show = self.showWatchlistItem {
                if let seasons = show.seasons {
                    let seasonArr = seasons.sortedSeasonArray as [SeasonWatchlistItem]
                    if let season = seasonArr.seasonWithNumber(self.selectedSeasonNumber) {
                        if let episodes = season.episodes {
                            let episodeArr = episodes.sortedEpisodesArray as [EpisodeWatchlistItem]
                            let episode = episodeArr[indexPathUnwrapped.row]
                            if let seen = episode.seen {
                                if let id = episode.id {
                                    self.showCoreDataHelper.setEpisodeSeenState(!Bool(seen), id: Int(id))
                                }
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}

