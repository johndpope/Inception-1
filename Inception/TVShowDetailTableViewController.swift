//
//  TVShowDetailTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

class TVShowDetailTableViewController: UITableViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    var id:Int = 0
    var videoIdentifier:String?

    private let kTableHeaderHeight:CGFloat = 200.0
    private let kTableHeaderCutAway:CGFloat = 30.0
    
    var headerView:UIView!
    var headerMaskLayer:CAShapeLayer!
    
    var show:Show?
    var tableData:[String] = []
    var tableDataKeys:[String] = []
    var similarShows:[Show] = []
    var crew:[CreditsCrew] = []
    var cast:[CreditsPerson] = []
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playTrailerButton:UIButton!
    @IBOutlet weak var similarShowsCollectionView:UICollectionView!
    @IBOutlet weak var personCreditsCollectionView:UICollectionView!
    @IBOutlet weak var footerView:UIView!
    
    //TODO: Show seasons from show.seasons to next viewcontroller
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.view.backgroundColor = UIColor.darkTextColor()
        
        headerView = tableView.tableHeaderView
        
        headerMaskLayer =   CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top:effectiveHeight, left:0, bottom:0, right:0)
        tableView.contentOffset = CGPoint(x:0,y:-effectiveHeight)
        updateHeaderView()

        // Do any additional setup after loading the view.
        APIController.request(APIEndpoints.Show(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                self.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage")
                print(error)
            } else {
                self.show = JSONParser.parseShow(data)
                self.updateUI()
            }
        }
    }
    
    func showAlert(localizeTitleKey:String, localizeMessageKey:String) {
        let alertController = UIAlertController(title: localizeTitleKey.localized, message: localizeMessageKey.localized, preferredStyle:.Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { (_) in
        }
        alertController.addAction(dismissAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    @IBAction func playTrailer(sender:UIButton) {
        if videoIdentifier != nil {
            let playerViewController = AVPlayerViewController()
            self.presentViewController(playerViewController, animated: true, completion: nil)
            
            XCDYouTubeClient.defaultClient().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: NSError?) in
                if let streamURL = video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue] as? NSURL {
                        playerViewController?.player = AVPlayer(URL: streamURL)
                        playerViewController?.player?.play()
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        var headerRect = CGRect(x:0,y:-effectiveHeight, width:tableView.bounds.width,height:kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:0,y:0))
        path.addLineToPoint(CGPoint(x:headerRect.width, y:0))
        path.addLineToPoint(CGPoint(x:headerRect.width, y:headerRect.height))
        path.addLineToPoint(CGPoint(x:0, y:headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    func removeCollectionViewFromFooter(collectionView:UICollectionView) {
        let collectionViewHeight = collectionView.frame.size.height
        collectionView.removeFromSuperview()
        let frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height-collectionViewHeight)
        self.footerView.frame = frame
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top:effectiveHeight, left:0, bottom:-collectionViewHeight, right:0)
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
        if show != nil {
            if show!.title != nil {
                self.title = show!.title
            }
            
            computeTableData()
            
            
            APIController.request(APIEndpoints.ShowTrailer(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    let videoIdentifier = JSONParser.parseTrailerKey(data)
                    if videoIdentifier != nil {
                        self.videoIdentifier = videoIdentifier!
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
                    self.similarShows = JSONParser.similarShows(data)
                    self.addSimilarShows()
                    self.tableView.setNeedsLayout()
                    
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
    
    func computeTableData() {
        if show != nil {
            if show!.voteAverage != nil {
                if show!.voteAverage! != 0.0 {
                    self.tableData.append("\(show!.voteAverage!)")
                    self.tableDataKeys.append("voteAverage".localized)
                }
            }
            
            if show!.status != nil {
                if !show!.status!.isEmpty {
                    self.tableData.append(show!.status!)
                    self.tableDataKeys.append("status".localized)
                }
            }
            
            if show!.numberOfEpisodes != nil {
                if show!.numberOfEpisodes! != 0 {
                    self.tableData.append("\(show!.numberOfEpisodes!)")
                    self.tableDataKeys.append("numberOfEpisodes".localized)
                }
            }
            
            if show!.numberOfSeasons != nil {
                if show!.numberOfSeasons! != 0 {
                    self.tableData.append("\(show!.numberOfSeasons!)")
                    self.tableDataKeys.append("numberOfSeasons".localized)
                }
            }
            
            if show!.firstAirDate != nil {
                if !show!.firstAirDate!.isEmpty {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date:NSDate = dateFormatter.dateFromString(show!.firstAirDate!)!
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    
                    self.tableData.append(dateFormatter.stringFromDate(date))
                    self.tableDataKeys.append("firstAirDate".localized)
                }
            }
            
            if show!.lastAirDate != nil {
                if !show!.lastAirDate!.isEmpty {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date:NSDate = dateFormatter.dateFromString(show!.lastAirDate!)!
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    
                    self.tableData.append(dateFormatter.stringFromDate(date))
                    self.tableDataKeys.append("lastAirDate".localized)
                }
            }
            
            
            if show!.episodeRunTime != nil {
                if show!.episodeRunTime!.count != 0 {
                    self.tableData.append(show!.episodeRunTime!.map{String($0)}.joinWithSeparator(", "))
                    self.tableDataKeys.append("episodeRuntime".localized)
                }
            }
            
            if show!.inProduction != nil {
                var string = "no".localized;
                if show!.inProduction! {
                    string = "yes".localized
                }
               
                self.tableData.append(string)
                self.tableDataKeys.append("inProduction".localized)
            }
            
            if show!.createdBy != nil {
                if show!.createdBy!.count != 0 {
                    self.tableData.append(show!.createdBy!.joinWithSeparator(","))
                    self.tableDataKeys.append("createdBy".localized)
                }
            }
            
            if show!.genres != nil {
                if !show!.genres!.isEmpty {
                    self.tableData.append(show!.genres!.map{$0.name!}.joinWithSeparator(", "))
                    self.tableDataKeys.append("Genre")
                }
            }
            
            if show!.networks != nil {
                if show!.networks!.count != 0 {
                    self.tableData.append(show!.networks!.joinWithSeparator(","))
                    self.tableDataKeys.append("networks".localized)
                }
            }
            
            if show!.originCountries != nil {
                if show!.originCountries!.count != 0 {
                    self.tableData.append(show!.originCountries!.joinWithSeparator(","))
                    self.tableDataKeys.append("originCountries".localized)
                }
            }
            
            if show!.type != nil {
                if !show!.type!.isEmpty {
                    self.tableData.append(show!.type!)
                    self.tableDataKeys.append("type".localized)
                }
            }
            
            if show!.productionCompanies != nil {
                if show!.productionCompanies!.count != 0 {
                    self.tableData.append(show!.productionCompanies!.joinWithSeparator(","))
                    self.tableDataKeys.append("productionCompanies".localized)
                }
            }
            
            if show!.overview != nil {
                if !show!.overview!.isEmpty {
                    self.tableData.append(show!.overview!)
                    self.tableDataKeys.append("overview".localized)
                }
            }
            
            self.tableView.reloadData()
        }
        
    }

    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        cell!.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .darkTextColor()
        cell!.backgroundColor = .darkTextColor()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.tableDataKeys[indexPath.row]
        if key == "overview".localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath) as! OverviewCell
            cell.overviewLabel.text = self.tableData[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TVShowDetailCell", forIndexPath: indexPath) as! MovieDetailCell
        
            cell.keyLabel.text = key
            cell.valueLabel.text = self.tableData[indexPath.row]
            return cell
        }
    }
    
    
    //MARK: - UIScrollView
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    //MARK: - UICollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.similarShowsCollectionView {
            return self.similarShows.count
        }
        else {
            return self.cast.count + self.crew.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarShowsCollectionView {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SimilarShowsCell",
                forIndexPath: indexPath) as! MovieCollectionCell
            let similarShow = self.similarShows[indexPath.row]
            if similarShow.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(similarShow.posterPath!)
               cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
            return cell
            
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVShowCreditsCell",
                forIndexPath: indexPath) as! CreditsCell
            var detailText:String?
            var profilePath:String?
            var name:String?
            
            if indexPath.row >= self.cast.count {
                let crewPerson = self.crew[indexPath.row-self.cast.count]
                detailText = crewPerson.job
                name = crewPerson.name
                profilePath = crewPerson.profilePath
            }
            else {
                let person = self.cast[indexPath.row]
                detailText = person.character
                name = person.name
                profilePath = person.profilePath
            }
            if profilePath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(profilePath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
            cell.textLabel.text = name
            cell.detailTextLabel.text = detailText
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.similarShowsCollectionView {
            let similarShow = self.similarShows[indexPath.row]
            if similarShow.id != nil {
                let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                vc.id = similarShow.id!
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
        else {
            let id:Int?
            if indexPath.row >= self.cast.count {
                id = self.crew[indexPath.row-self.cast.count].id
            }
            else {
                id = self.cast[indexPath.row].id
            }
            
            if id != nil {
                let vc : PersonDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("PersonDetailViewController") as! PersonDetailViewController
                vc.id = id!
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            
        }
    }


    
}
