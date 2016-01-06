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
    var lastSearches:[LastSearchedItem] = []
    
    let movieCoreDataHelper = MovieWatchlistCoreDataHelper()
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()
    let searchCoreDataHelper = SearchCoreDataHelper()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "search".localized
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        self.searchBar.autocapitalizationType = .None
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.searchBar.text = ""
        self.results.removeAll()
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.activityIndicator.color = ThemeManager.sharedInstance.currentTheme.textColor
        self.searchBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.searchBar.searchBarStyle = ThemeManager.sharedInstance.currentTheme.searchBarSearchStyle
        self.searchBar.keyboardAppearance = ThemeManager.sharedInstance.currentTheme.keyboardAppearance
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        
        isSearching = false
        self.lastSearches = searchCoreDataHelper.searchesFromStore()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    func insertInLastSearches(result:MultiSearchResult) {
        if let id = result.id {
            searchCoreDataHelper.insertSearchItem(id, mediaType: result.mediaType, name: result.name, year: result.year, posterPath: result.imagePath, timestamp: NSDate())
        }
    }

    
    /* UITableView Delegate & Datasource */
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return self.results.count
        }
        else {
            return self.lastSearches.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        (cell as! SearchTableViewCell).yearLabel.textColor = ThemeManager.sharedInstance.currentTheme.darkerTextColor
        (cell as! SearchTableViewCell).headingLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.yearLabel.text = ""
        cell.headingLabel.text = ""
        
        if isSearching {
            if let imagePath = self.results[indexPath.row].imagePath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
            if let year = self.results[indexPath.row].year {
                cell.yearLabel.text = "\(year)"
            }
            cell.headingLabel.text = self.results[indexPath.row].name
        }
        else {
            if let imagePath = self.lastSearches[indexPath.row].posterPath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
            if let year = self.lastSearches[indexPath.row].year {
                cell.yearLabel.text = "\(year)"
            }
            cell.headingLabel.text = self.lastSearches[indexPath.row].name
        }
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var mediaType = ""
        var id:Int?
        if isSearching {
            mediaType = self.results[indexPath.row].mediaType
            id = self.results[indexPath.row].id
        }
        else {
            mediaType = self.lastSearches[indexPath.row].mediaType
            id = self.lastSearches[indexPath.row].id.integerValue
        }
        if id != nil {
            switch mediaType {
                case "movie":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : MovieDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                        vc.id = id!
                        if self.isSearching {
                            self.insertInLastSearches(self.results[indexPath.row])
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                case "tv":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : TVShowDetailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                        vc.id = id!
                        if self.isSearching {
                            self.insertInLastSearches(self.results[indexPath.row])
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                case "person":
                    dispatch_async(dispatch_get_main_queue(),{
                        let vc : PersonDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PersonDetailViewController") as! PersonDetailViewController
                        vc.id = id!
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
        
        if isSearching {
            switch result.mediaType {
                case "movie":
                    if let id = result.id {
                        if self.movieCoreDataHelper.hasMovie(id) {
                            let watchlistAction = UITableViewRowAction(style: .Normal , title: "removeFromWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                                self.movieCoreDataHelper.removeMovieWithId(id)
                                tableView.setEditing(false, animated: true)
                            })
                            watchlistAction.backgroundColor = UIColor.redColor()
                            actions.append(watchlistAction)
                        }
                        else {
                            let watchlistAction = UITableViewRowAction(style: .Normal, title: "addToWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                                
                                self.movieCoreDataHelper.insertMovieItem(id, name: result.name, year: result.year, posterPath: result.imagePath,runtime:nil, seen: false)
                                tableView.setEditing(false, animated: true)
                            })
                            watchlistAction.backgroundColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
                            actions.append(watchlistAction)
                        }
                    }
                case "tv":
                    if let id = result.id {
                        if self.showCoreDataHelper.hasShow(id) {
                            let watchlistAction = UITableViewRowAction(style: .Normal , title: "removeFromWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                                self.showCoreDataHelper.removeShowWithId(id)
                                tableView.setEditing(false, animated: true)
                            })
                            watchlistAction.backgroundColor = UIColor.redColor()
                            actions.append(watchlistAction)
                        }
                        else {
                            let watchlistAction = UITableViewRowAction(style: .Normal, title: "addToWatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
                                
                                self.showCoreDataHelper.insertShowItem(id, name: result.name, year: result.year, posterPath: result.imagePath,lastUpdated: NSDate())
                                tableView.setEditing(false, animated: true)
                            })
                            watchlistAction.backgroundColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
                            actions.append(watchlistAction)
                        }
                    }
                default: ()
            }
        }
        return actions
    }
}

