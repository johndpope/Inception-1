//
//  MovieDetailTableViewController+TagListView.swift
//  Inception
//
//  Created by David Ehlen on 18.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SKTagView

extension MovieDetailTableViewController {
    func setupTagListView(cell:GenreTagTableViewCell) {
        cell.tagView.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width
        cell.tagView.padding   = UIEdgeInsetsMake(2, 5, 2, 5)
        cell.tagView.insets    = 5
        cell.tagView.lineSpace = 10
        cell.tagView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.tagView.removeAllTags()
        
        cell.tagView.didClickTagAtIndex = ({(index:UInt) in
            if let movie = self.movie {
                if let genres = movie.genres {
                    let vc : GenreDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GenreDetailViewController") as! GenreDetailViewController
                    vc.isShowGenre = false
                    vc.genre = genres[Int(index)]
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                }
            }
        })
        
        if let movie = self.movie {
            if let genres = movie.genres {
                for item in genres {
                    if let name = item.name {
                        let tag = SKTag(text:name)
                        tag.textColor = ThemeManager.sharedInstance.currentTheme.textColor
                        tag.fontSize = 14
                        tag.padding = UIEdgeInsetsMake(6, 5, 6, 5)
                        tag.bgColor = UIColor.clearColor()
                        tag.borderWidth = 1.0
                        tag.borderColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
                        tag.cornerRadius = 10
                        tag.enable = true
                        
                        cell.tagView.addTag(tag)
                    }
                }
            }
        }
    }
}
