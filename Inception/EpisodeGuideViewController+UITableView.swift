//
//  EpisodeGuideViewController+UITableView.swift
//  Inception
//
//  Created by David Ehlen on 21.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension EpisodeGuideViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let season = self.seasons.seasonWithNumber(self.selectedSeasonNumber) {
            if let episodes = season.episodes {
                return episodes.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let originalLabelHeight:CGFloat = 35.0
        let cellHeight:CGFloat = 80.0
        var text = ""
        if let season = self.seasons.seasonWithNumber(self.selectedSeasonNumber) {
            if let episodes = season.episodes {
                let episode = episodes[indexPath.row]
                if let overview = episode.overview {
                    text = overview
                }
            }
        }
        if let selectedIndexPath = self.selectedIndexPath {
            if indexPath == selectedIndexPath && text.characters.count > 0 {
                //120: 96 image width + 16 leading + 8 trailing space
                return cellHeight-originalLabelHeight+UILabelHelper.heightForView(text, font: UIFont.systemFontOfSize(14), width: self.view.bounds.size.width-120)
            }
        }
        return cellHeight
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeTableViewCell", forIndexPath: indexPath) as! EpisodeTableViewCell
        
        if let season = self.seasons.seasonWithNumber(self.selectedSeasonNumber) {
            if let episodes = season.episodes {
                let episode = episodes[indexPath.row]
                cell.titleLabel.text = ""
                cell.overviewLabel.text = ""

                if let title = episode.title {
                    if let episodeNumber = episode.episodeNumber {
                        cell.titleLabel.text = "\(episodeNumber). "+"\(title)"
                    }
                }

                if let overview = episode.overview {
                    cell.overviewLabel.text = overview
                }

                if let stillPath = episode.stillPath {
                    let imageURL =  imageBaseURLW780.URLByAppendingPathComponent(stillPath)
                    cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
                }
                else {
                    cell.coverImageView.image = UIImage(named: "placeholder-dark")
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
