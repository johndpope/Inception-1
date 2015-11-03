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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.seasonNavigator.reloadData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CacheFactory.clearAllCaches()
    }
}
