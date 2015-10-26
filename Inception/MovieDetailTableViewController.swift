//
//  MovieDetailTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 26.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieDetailTableViewController: UITableViewController {

    var id:Int = 0
    var movie:Movie?
    var tableData:[String] = []
    var tableDataKeys:[String] = []
    var similarMovies:[Movie] = []
    var crew:[CreditsCrew] = []
    var cast:[CreditsPerson] = []
    var videos:[Video]?

    internal let kTableHeaderHeight:CGFloat = 200.0
    internal let kTableHeaderCutAway:CGFloat = 30.0
    var headerView:UIView!
    var headerMaskLayer:CAShapeLayer!
    
    let movieCoreDataHelper = MovieWatchlistCoreDataHelper()
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playTrailerButton:UIButton!
    @IBOutlet weak var similarMoviesCollectionView:UICollectionView!
    @IBOutlet weak var personCreditsCollectionView:UICollectionView!
    @IBOutlet weak var footerView:UIView!
    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.setupHeaderView()
        self.setupActivityIndicator()
        self.activityIndicator.startAnimating()
        
        APIController.request(APIEndpoints.Movie(id)) { (data:AnyObject?, error:NSError?) in
            self.activityIndicator.stopAnimating()
            if (error != nil) {
                 AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                print(error)
            } else {
                self.movie = Movie(json: JSON(data!))
                self.setupBarButtonItem()
                self.updateUI()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewBounds = self.view.bounds
        self.activityIndicator.center = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBarButtonColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
    }
    
    func setupBarButtonItem() {
        let image = UIImage(named: "watchlist")
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "updateWatchlist:")

        self.navigationItem.rightBarButtonItem = barButtonItem
        self.updateBarButtonColor()
    }
    
    func updateBarButtonColor() {
        if self.navigationItem.rightBarButtonItem != nil {
            if self.movieCoreDataHelper.hasMovie(self.movie!.id!) {
                self.navigationItem.rightBarButtonItem!.tintColor = UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
            }
            else {
                self.navigationItem.rightBarButtonItem!.tintColor = UIColor.whiteColor()
            }
        }
    }
    
    func updateWatchlist(sender:UIBarButtonItem) {
        let movie = self.movie!
        if self.movieCoreDataHelper.hasMovie(movie.id!) {
            self.movieCoreDataHelper.removeMovieWithId(movie.id!)
            sender.tintColor = UIColor.whiteColor()
        }
        else {
            var year:Int? = nil
            if let releaseDate = movie.releaseDate {
                year = releaseDate.year
            }
            self.movieCoreDataHelper.insertMovieItem(movie.id!, name: movie.title, year: year, posterPath: movie.posterPath, seen: false)
            sender.tintColor = UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        }
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
            
            if movie!.backdropPath != nil {
                let imageURL =  imageBaseURLW780.URLByAppendingPathComponent(movie!.backdropPath!)
                self.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                self.coverImageView.image = UIImage(named: "placeholder-dark")
            }
            
            (self.tableDataKeys, self.tableData) = movie!.tableData()
            self.tableView.reloadData()
            
            APIController.request(APIEndpoints.MovieTrailer(id)) { (data:AnyObject?, error:NSError?) in
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
          
        }
        
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
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieOverviewTableViewCell", forIndexPath: indexPath) as! OverviewTableViewCell
            
            cell.overviewLabel.text = self.tableData[indexPath.row]
            return cell
        }
        else if key == "genres".localized {
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieGenreTagTableViewCell", forIndexPath: indexPath) as! GenreTagTableViewCell
            self.setupTagListView(cell)
            return cell
 
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailTableViewCell", forIndexPath: indexPath) as! DetailTableViewCell

            cell.keyLabel.text = key
            cell.valueLabel.text = self.tableData[indexPath.row]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
