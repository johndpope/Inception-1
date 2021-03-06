//
//  TVShowDetailTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SwiftyJSON

class TVShowDetailTableViewController: UITableViewController {
    var id:Int = 0
    var show:Show?
    var tableData:[String] = []
    var tableDataKeys:[String] = []
    var similarShows:[Show] = []
    var crew:[CreditsCrew] = []
    var cast:[CreditsPerson] = []
    var videos:[Video]?

    internal let kTableHeaderHeight:CGFloat = 200.0
    internal let kTableHeaderCutAway:CGFloat = 30.0
    var headerView:UIView!
    var headerMaskLayer:CAShapeLayer!

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playTrailerButton:UIButton!
    @IBOutlet weak var similarShowsCollectionView:UICollectionView!
    @IBOutlet weak var personCreditsCollectionView:UICollectionView!
    @IBOutlet weak var footerView:UIView!
    var activityIndicator:UIActivityIndicatorView!
    
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()
    var trailerFunctions:TrailerFunctions?
    
    enum Key:String {
        case Overview = "overview"
        case Genres = "genres"
        case ShowSeasons = "showSeasons"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailerFunctions = TrailerFunctions(from: self)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.setupHeaderView()
        self.setupActivityIndicator()
        self.activityIndicator.startAnimating()
        
        APIController.request(APIEndpoints.Show(id)) { (data:AnyObject?, error:NSError?) in
            self.activityIndicator.stopAnimating()
            if (error != nil) {
                 AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                print(error)
            } else {
                self.show = Show(json: JSON(data!))
                self.setupBarButtonItem()
                self.updateUI()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBarButtonColor()
        self.updateTheming()
    }
    
    func updateTheming() {
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.similarShowsCollectionView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.personCreditsCollectionView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.activityIndicator.color = ThemeManager.sharedInstance.currentTheme.textColor
        self.footerView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ context in
            self.updateHeaderView()
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewBounds = self.view.bounds
        self.activityIndicator.center = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds))
    }
    
    func setupBarButtonItem() {
        let image = UIImage(named: "watchlist")
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "updateWatchlist:")
        
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.updateBarButtonColor()
    }
    
    func updateBarButtonColor() {
        if self.navigationItem.rightBarButtonItem != nil {
            if self.showCoreDataHelper.hasShow(self.show!.id!) {
                self.navigationItem.rightBarButtonItem!.tintColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
            }
            else {
                self.navigationItem.rightBarButtonItem!.tintColor = ThemeManager.sharedInstance.currentTheme.textColor
            }
        }
    }
    
    func updateWatchlist(sender:UIBarButtonItem) {
        let show = self.show!
        if self.showCoreDataHelper.hasShow(show.id!) {
            self.showCoreDataHelper.removeShowWithId(show.id!)
            sender.tintColor = ThemeManager.sharedInstance.currentTheme.textColor
        }
        else {
            var year:Int? = nil
            if let firstAirDate = show.firstAirDate {
                year = firstAirDate.year
            }
           
            self.showCoreDataHelper.insertShowItem(show.id!, name: show.title, year: year, posterPath: show.posterPath,lastUpdated: NSDate())
            sender.tintColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        }
    }
    
    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
    }
    
    @IBAction func playTrailer(sender:UIButton) {
        if let videos = self.videos {
            if videos.count == 1 {
                if let key = videos[0].key {
                    trailerFunctions?.playVideoWithIdentifier(key,from:self)
                }
            }
            else {
                trailerFunctions?.showTrailerActionSheet(videos,from:self)
            }
        }
    }
    
    func addSimilarShows() -> Void {
        if self.similarShows.count != 0 {
            self.similarShowsCollectionView.reloadData()
        }
        else {
           self.removeCollectionViewFromFooter(self.similarShowsCollectionView)
        }
    }
    
    func addPersonCredits() {
        if self.crew.count != 0 || self.cast.count != 0 {
            self.personCreditsCollectionView.reloadData()
        }
        else {
           self.removeCollectionViewFromFooter(self.personCreditsCollectionView)
        }
    }

    
    func updateUI() {
        if self.show != nil {
            if let title = self.show!.title {
                self.title = title
            }
            
            (self.tableDataKeys, self.tableData) = show!.tableData()
            self.tableView.reloadData()
            
            APIController.request(APIEndpoints.ShowTrailer(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    let videos = JSONParser.parseTrailerVideos(data)
                    self.videos = videos
                    if videos.count > 0 {
                        self.playTrailerButton.hidden = false
                    }
                }
            }
            
            APIController.request(APIEndpoints.ShowCredits(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    self.cast = JSONParser.parseCreditsPerson(data)
                    self.crew = JSONParser.parseCreditsCrew(data)
                    self.addPersonCredits()
                }
            }
            
            APIController.request(APIEndpoints.SimilarShows(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    self.similarShows = JSONParser.parseShowResults(data)
                    self.addSimilarShows()
                }
            }
            
            if show!.backdropPath != nil {
                let imageURL =  imageBaseURLW780.URLByAppendingPathComponent(show!.backdropPath!)
                self.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                self.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.tableDataKeys[indexPath.row] == Key.ShowSeasons.rawValue.localized {
            if let show = self.show {
                if let id = show.id {
                    let vc : EpisodeGuideViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EpisodeGuideViewController") as! EpisodeGuideViewController
                    vc.seasons = show.seasons
                    vc.showId = id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        let key = self.tableDataKeys[indexPath.row]
        if key ==  Key.Overview.rawValue.localized {
            (cell as! OverviewTableViewCell).overviewLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        }
        else if key ==  Key.ShowSeasons.rawValue.localized {
            (cell as! EpisodeGuideTableViewCell).mainTextLabel.textColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        }
        else {
            if key != Key.Genres.rawValue.localized {
                (cell as! DetailTableViewCell).keyLabel.textColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
                (cell as! DetailTableViewCell).valueLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.tableDataKeys[indexPath.row]
        if key ==  Key.Overview.rawValue.localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowOverviewTableViewCell", forIndexPath: indexPath) as! OverviewTableViewCell
            cell.overviewLabel.text = self.tableData[indexPath.row]
            return cell
        }
            
        else if key ==  Key.Genres.rawValue.localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowGenreTagTableViewCell", forIndexPath: indexPath) as! GenreTagTableViewCell
            self.setupTagListView(cell)
            return cell
            
        }
        else if key ==  Key.ShowSeasons.rawValue.localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowSeasonsTableViewCell",forIndexPath:indexPath) as! EpisodeGuideTableViewCell
            cell.mainTextLabel.text =  Key.ShowSeasons.rawValue.localized
            return cell
        }

        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowDetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell
        
            cell.keyLabel.text = key
            cell.valueLabel.text = self.tableData[indexPath.row]
            return cell
        }
    }
}
