//
//  EpisodeGuideViewController+UICollectionView.swift
//  Inception
//
//  Created by David Ehlen on 21.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

extension EpisodeGuideViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.seasons.seasonCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SeasonNavigatorCollectionViewCell",
            forIndexPath: indexPath) as! SeasonNavigatorCollectionViewCell
        cell.roundedView.backgroundColor = UIColor.clearColor()
        if self.selectedSeasonNumber == indexPath.row+1 {
            self.animateCellSelection(cell)
        }
        let seasonNumber = indexPath.row+1
        cell.titleLabel.text = "\(seasonNumber)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedSeasonNumber = indexPath.row+1
        self.seasonNavigator.reloadData()
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointZero, animated:true)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            let totalCellWidth:CGFloat =  kCellWidth * CGFloat(self.seasons.count)
            let viewWidth:CGFloat = self.seasonNavigator.bounds.size.width
            let totalSpacingWidth:CGFloat = kSpacingWidth * (CGFloat(self.seasons.count)-1)
            let leftInsets = (viewWidth - (totalCellWidth + totalSpacingWidth)) / 2
            let rightInsets = leftInsets
            
            return UIEdgeInsetsMake(0, max(leftInsets,kSpacingWidth), 0, max(rightInsets,kSpacingWidth))
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.seasonNavigator.collectionViewLayout.invalidateLayout()
    }

    func animateCellSelection(cell:SeasonNavigatorCollectionViewCell) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            cell.roundedView.backgroundColor = UIColor(red:1.0,green:222.0/255.0,blue:96.0/255.0, alpha:1.0)
            }, completion: nil)
    }
}
