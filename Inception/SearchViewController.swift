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
    let movieCoreDataHelper = MovieWatchlistCoreDataHelper()
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "search".localized
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        self.searchBar.autocapitalizationType = .None
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
        let result = self.results[indexPath.row]
        var actions:[UITableViewRowAction] = []
        
        switch result.mediaType {
            case "movie":
                if let id = result.id {
                    if movieCoreDataHelper.hasMovie(id) {
                        let watchlistAction = UITableViewRowAction(style: .Normal , title: "removeFromWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                            self.movieCoreDataHelper.removeMovieWithId(id)
                            tableView.setEditing(false, animated: true)
                        })
                        watchlistAction.backgroundColor = UIColor.redColor()
                        actions.append(watchlistAction)
                    }
                    else {
                        let watchlistAction = UITableViewRowAction(style: .Normal, title: "addToWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                            
                            self.movieCoreDataHelper.insertMovieItem(id, name: result.name, year: result.year, posterPath: result.imagePath, seen: false)
                            tableView.setEditing(false, animated: true)
                        })
                        watchlistAction.backgroundColor = UIColor(red: 227.0/255.0, green: 187.0/255.0, blue: 55.0/255.0, alpha: 1.0)
                        actions.append(watchlistAction)
                    }
                }
            case "tv":
                if let id = result.id {
                    if showCoreDataHelper.hasShow(id) {
                        let watchlistAction = UITableViewRowAction(style: .Normal , title: "removeFromWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                            self.showCoreDataHelper.removeShowWithId(id)
                            tableView.setEditing(false, animated: true)
                        })
                        watchlistAction.backgroundColor = UIColor.redColor()
                        actions.append(watchlistAction)
                    }
                    else {
                        let watchlistAction = UITableViewRowAction(style: .Normal, title: "addToWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                            
                            self.showCoreDataHelper.insertShowItem(id, name: result.name, year: result.year, posterPath: result.imagePath, seasons: nil)
                            tableView.setEditing(false, animated: true)
                        })
                        watchlistAction.backgroundColor = UIColor(red: 227.0/255.0, green: 187.0/255.0, blue: 55.0/255.0, alpha: 1.0)
                        actions.append(watchlistAction)
                    }
                }
            default: ()
        }
    
        return actions
    }
}

