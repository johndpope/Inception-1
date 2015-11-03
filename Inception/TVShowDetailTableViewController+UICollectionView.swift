//
//  TVShowDetailTableViewController+UICollectionView.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension TVShowDetailTableViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func removeCollectionViewFromFooter(collectionView:UICollectionView) {
        let collectionViewHeight = collectionView.frame.size.height
        collectionView.removeFromSuperview()
        let frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height-collectionViewHeight)
        self.footerView.frame = frame
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway/2
        tableView.contentInset = UIEdgeInsets(top:effectiveHeight, left:0, bottom:-collectionViewHeight, right:0)
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        
        if collectionView == self.personCreditsCollectionView {
            (cell as! CreditsCollectionCell).detailTextLabel.textColor = ThemeManager.sharedInstance.currentTheme.darkerTextColor
            (cell as! CreditsCollectionCell).textLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarShowsCollectionView {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SimilarShowsCell",
                forIndexPath: indexPath) as! CoverImageCollectionCell
            let similarShow = self.similarShows[indexPath.row]
            if similarShow.posterPath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(similarShow.posterPath!)
                cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            }
            else {
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
            }
            return cell
            
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVShowCreditsCollectionCell",
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
                cell.coverImageView.image = UIImage(named: ThemeManager.sharedInstance.currentTheme.placeholderImageString)
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
}
