//
//  EpisodeGuideWatchlistViewController.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class EpisodeGuideWatchlistViewController: UIViewController {
    
    var showWatchlistItem:ShowWatchlistItem?
    var selectedSeasonNumber = 1
    var selectedIndexPath:NSIndexPath?
    var showCoreDataHelper = ShowWatchlistCoreDataHelper()
    
    internal let kCellWidth:CGFloat = 50.0
    internal let kSpacingWidth:CGFloat = 10.0
    
    @IBOutlet weak var seasonNavigator:UICollectionView!
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "showSeasons".localized
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLoadSeasonsAndEpisodes", name: "seasonsAndEpisodesDidLoad", object: nil)
        
        let longPressGestureRecognizer
        = UILongPressGestureRecognizer(target:self, action:"toggleSeasonSeenState:")
        longPressGestureRecognizer.delaysTouchesBegan = true
        self.seasonNavigator.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.seasonNavigator.reloadData()
        self.tableView.reloadData()
        self.updateTheming()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didLoadSeasonsAndEpisodes() {
        if let show = self.showWatchlistItem {
            if let id = show.id {
                self.showWatchlistItem = self.showCoreDataHelper.showWithId(Int(id))
                self.seasonNavigator.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
    func updateTheming() {
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.seasonNavigator.backgroundColor = ThemeManager.sharedInstance.currentTheme.seasonNavigatorBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CacheFactory.clearAllCaches()
    }
}
