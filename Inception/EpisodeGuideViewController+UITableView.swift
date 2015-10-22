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
    }

}
