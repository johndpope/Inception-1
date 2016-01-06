//
//  PersonWatchlistViewController+UITableView.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

// MARK: - Table view data source
import UIKit

extension PersonWatchlistViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let person = self.personWatchlistItem {
            if let credits = person.credits {
                return credits.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        (cell as! PersonDetailWatchlistTableViewCell).titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        (cell as! PersonDetailWatchlistTableViewCell).yearLabel.textColor = ThemeManager.sharedInstance.currentTheme.darkerTextColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonDetailWatchlistTableViewCell", forIndexPath: indexPath) as! PersonDetailWatchlistTableViewCell
        if let person = self.personWatchlistItem {
            if let credits = person.credits {
                var creditsArr = credits.array as! [PersonCredit]
                cell.titleLabel.text = ""
                cell.yearLabel.text = ""
                
                cell.titleLabel.text = creditsArr[indexPath.row].name
                
                if let year = creditsArr[indexPath.row].year {
                    cell.yearLabel.text = "\(year.integerValue)"
                }
                
                if let stillPath = creditsArr[indexPath.row].imagePath {
                    let imageURL =  imageBaseURL.URLByAppendingPathComponent(stillPath)
                    cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
                }
                else {
                    cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let person = self.personWatchlistItem {
            if let credits = person.credits {
                var creditsArr = credits.array as! [PersonCredit]
                if let mediaType = creditsArr[indexPath.row].mediaType {
                    switch(mediaType) {
                        case "tv":
                        let vc : TVShowDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                        vc.id = creditsArr[indexPath.row].id.integerValue
                        self.navigationController?.pushViewController(vc, animated: true)
                    case "movie":
                        let vc : MovieDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                        vc.id = creditsArr[indexPath.row].id.integerValue
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:()
                    }
                }
            }
        }
    }
}