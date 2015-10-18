//
//  MovieDetailTableViewController+UICollectionView.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension MovieDetailTableViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
                forIndexPath: indexPath) as! CoverImageCollectionCell
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCreditsCollectionCell",
                forIndexPath: indexPath) as! CreditsCollectionCell
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
                self.navigationController?.pushViewController(vc, animated: true)
                
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
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    func removeCollectionViewFromFooter(collectionView:UICollectionView) {
        let collectionViewHeight = collectionView.frame.size.height
        collectionView.removeFromSuperview()
        let frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height-collectionViewHeight)
        self.footerView.frame = frame
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top:effectiveHeight, left:0, bottom:-collectionViewHeight, right:0)
    }
}
