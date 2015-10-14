//
//  CacheTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class CacheTableViewController: UITableViewController {
    var showsImageCache:Bool = false
    @IBOutlet weak var cacheCell:UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateCacheDetailLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCacheDetailLabel() {
        if self.showsImageCache {
            self.cacheCell.detailTextLabel?.text = CacheFactory.imageCacheDescription()
        }
        else {
            self.cacheCell.detailTextLabel?.text = CacheFactory.cacheDescription()
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1 {
            if showsImageCache {
                CacheFactory.clearImageCache()
            }
            else {
                CacheFactory.clearRequestCache()
            }
        }
        self.updateCacheDetailLabel()
    }
}
