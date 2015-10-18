//
//  PersonDetailViewController+UITableView.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension PersonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonDetailTableViewCell", forIndexPath: indexPath) as! PersonDetailTableViewCell
            
            cell.textLbl.text = tableDataKeys[indexPath.row]
            cell.detailTextLbl.text = tableData[indexPath.row]
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("KnownForTableViewCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = self.knownFor[indexPath.row].name
            if let imagePath = self.knownFor[indexPath.row].imagePath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
                cell.imageView?.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedSegmentIndex == 0 {
            return self.tableData.count
        }
        else {
            return self.knownFor.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.selectedSegmentIndex == 1 {
            let element = self.knownFor[indexPath.row]
            if element.id != nil {
                if element.mediaType == "movie" {
                    let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                    vc.id = element.id!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                else {
                    let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                    vc.id = element.id!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            }
        }
    }

}