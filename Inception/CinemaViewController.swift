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
        if movies != nil {
            return movies!.count
        }
        return 0
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
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
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
