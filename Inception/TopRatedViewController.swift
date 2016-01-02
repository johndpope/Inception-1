//
//  TopRatedViewController.swift
//  Inception
//
//  Created by David Ehlen on 07.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var movies:[Movie]?
    var shows:[Show]?
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        let group = dispatch_group_create()
        var hadError = false
        
        dispatch_group_enter(group)
        APIController.request(APIEndpoints.TopRatedMovies) { (data:AnyObject?, error:NSError?) in
            dispatch_group_leave(group)
            if (error != nil) {
                hadError = true
            } else {
                self.movies = JSONParser.parseMovieResults(data)
                self.collectionView.reloadData()
            }
        }

        dispatch_group_enter(group)
        APIController.request(APIEndpoints.TopRatedShows) { (data:AnyObject?, error:NSError?) in
            dispatch_group_leave(group)
            if (error != nil) {
                hadError = true
            } else {
                self.shows = JSONParser.parseShowResults(data)
                self.collectionView.reloadData()
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            if hadError {
                 AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.collectionView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.activityIndicator.color = ThemeManager.sharedInstance.currentTheme.textColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    
    //MARK: - UICollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if self.movies == nil {
                return 0
            }
            return self.movies!.count
        }
        else {
            if self.shows == nil {
                return 0
            }
            return self.shows!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "CollectionviewSectionHeader",
                forIndexPath: indexPath)
                as! CollectionviewSectionHeader
            if indexPath.section == 0 {
                headerView.label.text = "movies".localized.uppercaseString
            }
            else {
                headerView.label.text = "shows".localized.uppercaseString
            }
            return headerView
        default:
            //assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TopRatedCollectionCell",
            forIndexPath: indexPath) as! CoverImageCollectionCell
        if indexPath.section == 0 {
            let movie = self.movies![indexPath.row]
            if movie.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(movie.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
        }
        else {
            let show = self.shows![indexPath.row]
            if show.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(show.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let movie = self.movies![indexPath.row]
            if movie.id != nil {
                let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                vc.id = movie.id!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else {
            let show = self.shows![indexPath.row]
            if show.id != nil {
                let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                vc.id = show.id!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
}
