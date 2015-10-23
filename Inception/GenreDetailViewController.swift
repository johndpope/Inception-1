//
//  GenreDetailViewController.swift
//  Inception
//
//  Created by David Ehlen on 12.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class GenreDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movies:[Movie] = []
    var shows:[Show] = []
    var isShowGenre = false
    var genre:Genre?
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let genre = self.genre {
            self.title = genre.name
            
            if isShowGenre {
                self.activityIndicator.startAnimating()

                APIController.request(APIEndpoints.ShowsForGenre(genre.id!)) { (data:AnyObject?, error:NSError?) in
                    self.activityIndicator.stopAnimating()
                    if (error != nil) {
                         AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                    } else {
                        self.shows = JSONParser.parseShowResults(data)
                        self.collectionView.reloadData()
                    }
                }
            }
            else {
                self.activityIndicator.startAnimating()

                APIController.request(APIEndpoints.MoviesForGenre(genre.id!)) { (data:AnyObject?, error:NSError?) in
                    self.activityIndicator.stopAnimating()
                    if (error != nil) {
                         AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                    } else {
                        self.movies = JSONParser.parseMovieResults(data)
                        self.collectionView.reloadData()
                    }
                }
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
        if isShowGenre {
            return self.shows.count
        }
        else {
            return self.movies.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreDetailCollectionCell",
            forIndexPath: indexPath) as! CoverImageCollectionCell

        if isShowGenre {
            if let pp = self.shows[indexPath.row].posterPath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(pp)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
              cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
        }
        else {
            if let pp = self.movies[indexPath.row].posterPath {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(pp)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
               cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !isShowGenre {
            let movie = self.movies[indexPath.row]
            if movie.id != nil {
                let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                vc.id = movie.id!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else {
            let show = self.shows[indexPath.row]
            if show.id != nil {
                let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                vc.id = show.id!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    


}
