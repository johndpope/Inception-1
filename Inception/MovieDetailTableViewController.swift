//
//  MovieDetailTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 26.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit
import SwiftyJSON

class MovieDetailTableViewController: UITableViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var id:Int = 0
    var movie:Movie?
    var tableData:[String] = []
    var tableDataKeys:[String] = []
    var similarMovies:[Movie] = []
    var crew:[CreditsCrew] = []
    var cast:[CreditsPerson] = []

    private let kTableHeaderHeight:CGFloat = 200.0
    private let kTableHeaderCutAway:CGFloat = 30.0
    
    var headerView:UIView!
    var headerMaskLayer:CAShapeLayer!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playTrailerButton:UIButton!
    @IBOutlet weak var similarMoviesCollectionView:UICollectionView!
    @IBOutlet weak var personCreditsCollectionView:UICollectionView!
    @IBOutlet weak var footerView:UIView!

    var videoIdentifier:String?
    //TODO: add to watchlist to uibarbuttonitem, check if already in watchlist => toggle tintcolor on add watchlist button
    //TODO: Make genre clickable, show all trailers, show all media(images)
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
     
        APIController.request(APIEndpoints.Movie(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                self.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage")
                print(error)
            } else {
                self.movie = Movie(json: JSON(data!))
                self.updateUI()
            }
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
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
    
    @IBAction func playTrailer(sender:UIButton) {
        if videoIdentifier != nil {
            let playerViewController = AVPlayerViewController()
            self.presentViewController(playerViewController, animated: true, completion: nil)
            
            XCDYouTubeClient.defaultClient().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: NSError?) in
                if let streamURL = video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] as? NSURL ??
                    video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue] as? NSURL {
                        print(streamURL)
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
    
    func addSimilarMovies() -> Void {
        if self.similarMovies.count != 0 {
            self.similarMoviesCollectionView.reloadData()
        }
        else {
            self.removeCollectionViewFromFooter(self.similarMoviesCollectionView)
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
        if movie != nil {
        
            if movie!.title != nil {
                self.title = movie!.title
            }
            
            computeTableData()

            
            APIController.request(APIEndpoints.MovieTrailer(id)) { (data:AnyObject?, error:NSError?) in
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
            
            APIController.request(APIEndpoints.MovieCredits(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    self.cast = JSONParser.parseCreditsPerson(data)
                    self.crew = JSONParser.parseCreditsCrew(data)
                    self.addPersonCredits()
                }
            }
            
            APIController.request(APIEndpoints.SimilarMovies(id)) { (data:AnyObject?, error:NSError?) in
                if (error != nil) {
                    print(error)
                } else {
                    self.similarMovies = JSONParser.parseMovieResults(data)
                    self.addSimilarMovies()                   
                }
            }
            
          
            if movie!.backdropPath != nil {
                let imageURL =  imageBaseURLW780.URLByAppendingPathComponent(movie!.backdropPath!)
                self.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
               self.coverImageView.image = UIImage(named: "placeholder-dark")
            }
        }
        
    }

    func computeTableData() {
        if movie != nil {
            if movie!.voteAverage != nil {
                if movie!.voteAverage! != 0.0 {
                    self.tableData.append("\(movie!.voteAverage!)")
                    self.tableDataKeys.append("voteAverage".localized)
                }
            }
            
            if movie!.status != nil {
                if !movie!.status!.isEmpty {
                    self.tableData.append(movie!.status!)
                    self.tableDataKeys.append("status".localized)
                }
            }
            
            if movie!.runtime != nil {
                if movie!.runtime! != 0 {
                    self.tableData.append("\(movie!.runtime!)")
                    self.tableDataKeys.append("runtime".localized)
                }
            }
            
            if movie!.releaseDate != nil {
                if !movie!.releaseDate!.isEmpty {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date:NSDate = dateFormatter.dateFromString(movie!.releaseDate!)!
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                
                    self.tableData.append(dateFormatter.stringFromDate(date))
                    self.tableDataKeys.append("releaseDate".localized)
                }
            }
            
            if movie!.genres != nil {
                if !movie!.genres!.isEmpty {
                    self.tableData.append(movie!.genres!.map{$0.name!}.joinWithSeparator(", "))
                    self.tableDataKeys.append("Genre")
                }
            }
            
            
            if movie!.budget != nil {
                if movie!.budget! != 0 {
                    self.tableData.append("\(movie!.budget!.addSeparator) $")
                    self.tableDataKeys.append("budget".localized)
                }
            }
            
            if movie!.revenue != nil {
                if movie!.revenue! != 0 {
                    self.tableData.append("\(movie!.revenue!.addSeparator) $")
                    self.tableDataKeys.append("revenue".localized)
                }
            }
            
            if movie!.tagline != nil {
                if !movie!.tagline!.isEmpty {
                    self.tableData.append(movie!.tagline!)
                    self.tableDataKeys.append("tagline".localized)
                }
            }
            
            if movie!.productionCompanies != nil {
                if movie!.productionCompanies!.count != 0 {
                    self.tableData.append(movie!.productionCompanies!.joinWithSeparator(","))
                    self.tableDataKeys.append("productionCompanies".localized)
                }
            }
            
            if movie!.productionCountries != nil {
                if movie!.productionCountries!.count != 0 {
                    self.tableData.append(movie!.productionCountries!.joinWithSeparator(","))
                    self.tableDataKeys.append("productionCountries".localized)
                }
            }
            
            if movie!.overview != nil {
                if !movie!.overview!.isEmpty {
                    self.tableData.append(movie!.overview!)
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
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailCell", forIndexPath: indexPath) as! MovieDetailCell

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
        if collectionView == self.similarMoviesCollectionView {
            return self.similarMovies.count
        }
        else {
            return self.cast.count + self.crew.count
        }
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarMoviesCollectionView {
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SimilarMoviesCell",
            forIndexPath: indexPath) as! MovieCollectionCell
            let similarMovie = self.similarMovies[indexPath.row]
            if similarMovie.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(similarMovie.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
            return cell

        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CreditsCell",
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
        if collectionView == self.similarMoviesCollectionView {
            let similarMovie = self.similarMovies[indexPath.row]
                if similarMovie.id != nil {
                let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                vc.id = similarMovie.id!
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
