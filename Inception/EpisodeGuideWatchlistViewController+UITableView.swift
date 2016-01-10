//
//  EpisodeGuideWatchlistViewController+UITableView.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension EpisodeGuideWatchlistViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let show = self.showWatchlistItem {
            if let seasons = show.seasons {
                let seasonArr = seasons.sortedSeasonArray as [SeasonWatchlistItem]
                if let season = seasonArr.seasonWithNumber(self.selectedSeasonNumber) {
                    if let episodes = season.episodes {
                        return episodes.count
                    }
                }
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight:CGFloat = 80.0
        var text = ""
        if let show = self.showWatchlistItem {
            if let seasons = show.seasons {
                let seasonArr = seasons.sortedSeasonArray as [SeasonWatchlistItem]
                if let season = seasonArr.seasonWithNumber(self.selectedSeasonNumber) {
                    if let episodes = season.episodes {
                        let episodeArr = episodes.sortedEpisodesArray as [EpisodeWatchlistItem]
                        let episode = episodeArr[indexPath.row]
                        if let overview = episode.overview {
                            text = overview
                        }
                    }
                }
            }
        }
        
        if let selectedIndexPath = self.selectedIndexPath {
            if indexPath == selectedIndexPath && text.characters.count > 0 {
                //120: 96 image width + 16 leading + 8 trailing space
                return cellHeight+UILabelHelper.heightForView(text, font: UIFont.systemFontOfSize(14), width: self.view.bounds.size.width-120)
            }
        }
        return cellHeight
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        (cell as! EpisodeWatchlistTableViewCell).titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        (cell as! EpisodeWatchlistTableViewCell).overviewLabel.textColor = ThemeManager.sharedInstance.currentTheme.darkerTextColor
        (cell as! EpisodeWatchlistTableViewCell).seenButton.trailStrokeColor = ThemeManager.sharedInstance.currentTheme.trailStrokeColor
        (cell as! EpisodeWatchlistTableViewCell).seenButton.strokeColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeWatchlistTableViewCell", forIndexPath: indexPath) as! EpisodeWatchlistTableViewCell
        if let show = self.showWatchlistItem {
            if let seasons = show.seasons {
                let seasonArr = seasons.sortedSeasonArray as [SeasonWatchlistItem]
                if let season = seasonArr.seasonWithNumber(self.selectedSeasonNumber) {
                    if let episodes = season.episodes {
                        let episodeArr = episodes.sortedEpisodesArray as [EpisodeWatchlistItem]
                        let episode = episodeArr[indexPath.row]
                        cell.titleLabel.text = ""
                        cell.overviewLabel.text = ""
                        cell.delegate = self
                        
                        if let title = episode.name {
                            if let episodeNumber = episode.episodeNumber {
                                cell.titleLabel.text = "\(episodeNumber). "+"\(title)"
                            }
                        }
                        
                        if let overview = episode.overview {
                            cell.overviewLabel.text = overview
                        }
                        
                        if let stillPath = episode.posterPath {
                            let imageURL =  imageBaseURL.URLByAppendingPathComponent(stillPath)
                            cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
                        }
                        else {
                            cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
                        }
                        if let id = episode.id {
                            let seen = self.showCoreDataHelper.isEpisodeSeen(Int(id))
                            if seen != cell.seenButton.selected {
                                cell.seenButton.setSelected(Bool(seen),animated:true)
                            }
                        }
                    }
                }

            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let selectedIndexPath = self.selectedIndexPath {
            if selectedIndexPath == indexPath {
                self.selectedIndexPath = nil
            }
            else {
                self.selectedIndexPath = indexPath
            }
        }
        else {
            self.selectedIndexPath = indexPath
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath],withRowAnimation:.Automatic)
        
    }
    
}
