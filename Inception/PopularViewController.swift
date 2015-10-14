//
//  PopularViewController.swift
//  Inception
//
//  Created by David Ehlen on 07.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var movies:[Movie]?
    var shows:[Show]?
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController.request(APIEndpoints.PopularMovies) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                //TODO: error handling
                print(error)
            } else {
                //TODO: Methodenname passt nicht
                self.movies = JSONParser.similarMovies(data)
                self.collectionView.reloadData()
            }
        }
        
        APIController.request(APIEndpoints.PopularShows) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                //TODO: error handling
                print(error)
            } else {
                //TODO: Methodenname passt nicht
                self.shows = JSONParser.similarShows(data)
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
                headerView.label.text = "movies".localized
            }
            else {
                headerView.label.text = "shows".localized
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PopularCell",
            forIndexPath: indexPath) as! MovieCollectionCell
        if indexPath.section == 0 {
            let movie = self.movies![indexPath.row]
            if movie.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(movie.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
            }
        }
        else {
            let show = self.shows![indexPath.row]
            if show.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(show.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: "placeholder-dark")
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
        else {
            let show = self.shows![indexPath.row]
            if show.id != nil {
                let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                vc.id = show.id!
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
       
    }
    
}
