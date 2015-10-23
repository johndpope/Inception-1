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
    
    //TODO: add to watchlist to uibarbuttonitem, check if already in watchlist => toggle tintcolor on add watchlist button
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.updateUI()
            }
        }
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
                    TrailerFunctions.playVideoWithIdentifier(key,from:self)
                }
            }
            else {
                TrailerFunctions.showTrailerActionSheet(videos,from:self)
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
                self.coverImageView.image = UIImage(named: "placeholder-dark")
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
        if self.tableDataKeys[indexPath.row] == "showSeasons".localized {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.tableDataKeys[indexPath.row]
        if key == "overview".localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowOverviewTableViewCell", forIndexPath: indexPath) as! OverviewTableViewCell
            cell.overviewLabel.text = self.tableData[indexPath.row]
            return cell
        }
            
        else if key == "genres".localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowGenreTagTableViewCell", forIndexPath: indexPath) as! GenreTagTableViewCell
            self.setupTagListView(cell)
            return cell
            
        }
        else if key == "showSeasons".localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowSeasonsTableViewCell",forIndexPath:indexPath) as! EpisodeGuideTableViewCell
            cell.mainTextLabel.text = "showSeasons".localized
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
