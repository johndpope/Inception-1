//
//  CinemaViewController.swift
//  Inception
//
//  Created by David Ehlen on 08.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class CinemaViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var movies:[Movie]?
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()

        APIController.request(APIEndpoints.CinemaMovies) { (data:AnyObject?, error:NSError?) in
            self.activityIndicator.stopAnimating()
            if (error != nil) {
                print(error)
            } else {
                self.movies = JSONParser.parseMovieResults(data)
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        }
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CinemaMoviesCollectionCell",
                forIndexPath: indexPath) as! CoverImageCollectionCell
            let movie = self.movies![indexPath.row]
            if movie.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(movie.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movie = self.movies![indexPath.row]
        if movie.id != nil {
            let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
            vc.id = movie.id!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
