//
//  SecondViewController.swift
//  Inception
//
//  Created by David Ehlen on 19.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import CoreData

class WatchlistViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ShowUpdaterDelegate {
    
    var movies:[MovieWatchlistItem] = []
    var shows:[ShowWatchlistItem] = []
    let coreDataHelper = MovieWatchlistCoreDataHelper()
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()
    let showUpdater = ShowUpdater()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "watchlist".localized
        tableView.tableFooterView  = UIView(frame:CGRectZero)
        showUpdater.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLoadSeasonsAndEpisodes", name: "seasonsAndEpisodesDidLoad", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.movies = coreDataHelper.moviesFromStore()
        self.shows = showCoreDataHelper.showsFromStore()
        self.showUpdater.updateFrom(self)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidChange", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.persistentStoreCoordinator)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveICloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.persistentStoreCoordinator)
        
    }
    
    func persistentStoreDidChange () {
        self.movies = self.coreDataHelper.moviesFromStore()
        self.shows = showCoreDataHelper.showsFromStore()
        self.tableView.reloadData()
    }
    
    func persistentStoreWillChange (notification:NSNotification) {
      (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func recieveICloudChanges (notification:NSNotification){
        (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.performBlock { () -> Void in
           (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            self.movies = self.coreDataHelper.moviesFromStore()
            self.shows = self.showCoreDataHelper.showsFromStore()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoadSeasonsAndEpisodes() {
        self.shows = showCoreDataHelper.showsFromStore()
        self.tableView.reloadData()
        
    }
    
    func didUpdateShows() {
        self.shows = showCoreDataHelper.showsFromStore()
        self.tableView.reloadData()
    }
    
    @IBAction func changedSegment() {
        self.tableView.reloadData()
    }
    
    //MARK: UITableView Delegate & Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.movies.count
        }
        else {
            return self.shows.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                coreDataHelper.removeMovie(self.movies[indexPath.row])
                self.movies = coreDataHelper.moviesFromStore()
            }
            else {
                showCoreDataHelper.removeShow(self.shows[indexPath.row])
                self.shows = showCoreDataHelper.showsFromStore()
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor

        if self.segmentedControl.selectedSegmentIndex == 0 {
            (cell as! MovieWatchlistTableViewCell).nameLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
            (cell as! MovieWatchlistTableViewCell).yearLabel.textColor = ThemeManager.sharedInstance.currentTheme.lightTextColor
            (cell as! MovieWatchlistTableViewCell).seenButton.trailStrokeColor = ThemeManager.sharedInstance.currentTheme.trailStrokeColor
            (cell as! MovieWatchlistTableViewCell).seenButton.strokeColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        }
        else {
            (cell as! ShowWatchlistTableViewCell).nameLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
            (cell as! ShowWatchlistTableViewCell).yearLabel.textColor = ThemeManager.sharedInstance.currentTheme.lightTextColor
            (cell as! ShowWatchlistTableViewCell).seenButton.trailStrokeColor = ThemeManager.sharedInstance.currentTheme.trailStrokeColor
            (cell as! ShowWatchlistTableViewCell).seenButton.strokeColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieWatchlistTableViewCell", forIndexPath: indexPath) as! MovieWatchlistTableViewCell
            
            cell.delegate = self
            cell.nameLabel.text = ""
            cell.yearLabel.text = ""
            
            if let name = self.movies[indexPath.row].name {
                cell.nameLabel.text = name
            }
            
            if let year = self.movies[indexPath.row].year {
                cell.yearLabel.text = "\(year)"
            }
            
            if let imagePath = self.movies[indexPath.row].posterPath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
            
            if let seen = self.movies[indexPath.row].seen {
                if seen != cell.seenButton.selected {
                    cell.seenButton.setSelected(Bool(seen),animated:true)
                }
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ShowWatchlistTableViewCell", forIndexPath: indexPath) as! ShowWatchlistTableViewCell
            
            cell.nameLabel.text = ""
            cell.yearLabel.text = ""
            cell.delegate = self
            
            if let name = self.shows[indexPath.row].name {
                cell.nameLabel.text = name
            }
            
            if let year = self.shows[indexPath.row].year {
                cell.yearLabel.text = "\(year)"
            }
            
            if let imagePath = self.shows[indexPath.row].posterPath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
            
            let seen = self.showCoreDataHelper.isShowSeen(self.shows[indexPath.row])
            if seen != cell.seenButton.selected {
                cell.seenButton.setSelected(Bool(seen),animated:true)
            }
            
            if seen == true {
                cell.progressBar.setProgress(1.0, animated: true)
            }
            else {
                if let id = self.shows[indexPath.row].id {
                    let progress = showCoreDataHelper.showProgress(Int(id))
                    cell.progressBar.setProgress(progress, animated: true)
                }
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.segmentedControl.selectedSegmentIndex == 1 {
            let vc : EpisodeGuideWatchlistViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EpisodeGuideWatchlistViewController") as! EpisodeGuideWatchlistViewController
            vc.showWatchlistItem = self.shows[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

