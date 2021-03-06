//
//  EpisodeGuideViewController.swift
//  Inception
//
//  Created by David Ehlen on 20.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SwiftyJSON

class EpisodeGuideViewController : UIViewController {
    var seasons:[Season]!
    var showId:Int!
    var selectedSeasonNumber = 1
    var selectedIndexPath:NSIndexPath?
    internal let kCellWidth:CGFloat = 50.0
    internal let kSpacingWidth:CGFloat = 10.0
    
    @IBOutlet weak var seasonNavigator:UICollectionView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "showSeasons".localized
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.loadEpisodes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTheming()
    }
    
    func updateTheming() {
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.seasonNavigator.backgroundColor = ThemeManager.sharedInstance.currentTheme.seasonNavigatorBackgroundColor
        self.activityIndicator.color = ThemeManager.sharedInstance.currentTheme.textColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CacheFactory.clearAllCaches()
    }
    
    func loadEpisodes() {
        self.activityIndicator.startAnimating()
        let group = dispatch_group_create()

        for season in self.seasons {
            if let seasonNumber = season.seasonNumber {
                if seasonNumber > 0 {
                    dispatch_group_enter(group)
                    APIController.request(APIEndpoints.SeasonsForShow(self.showId, seasonNumber)) { (data:AnyObject?, error:NSError?) in
                        dispatch_group_leave(group)
                        if (error != nil) {
                             AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                        } else {
                            season.episodes = JSONParser.parseEpisodes(data)
                        }
                    }
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
