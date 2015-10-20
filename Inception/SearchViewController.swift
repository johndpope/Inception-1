//
//  FirstViewController.swift
//  Inception
//
//  Created by David Ehlen on 19.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var results:[MultiSearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "search".localized
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    /* UITableView Delegate & Datasource */
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.yearLabel.text = ""
        cell.headingLabel.text = ""
        
        if let imagePath = self.results[indexPath.row].imagePath {
            let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
            cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
        }
        else {
            cell.coverImageView.image = UIImage(named: "placeholder-dark")
        }
        if let year = self.results[indexPath.row].year {
            cell.yearLabel.text = "\(year)"
        }
        cell.headingLabel.text = self.results[indexPath.row].name
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let id = self.results[indexPath.row].id {
            switch self.results[indexPath.row].mediaType {
                case "movie":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : MovieDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                        vc.id = id
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                case "tv":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : TVShowDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                        vc.id = id
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                case "person":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : PersonDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PersonDetailViewController") as! PersonDetailViewController
                        vc.id = id
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                default:
                    assert(false, "Unexpected media type")
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [UITableViewRowAction]? {
        let watchlistAction = UITableViewRowAction(style: .Normal, title: "addwatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
            print("Triggered")
            //TODO: add to watchlist
        })
        
        watchlistAction.backgroundColor = UIColor(red: 227.0/255.0, green: 187.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        
        return [watchlistAction]
    }
}

