//
//  InfoSettingsTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 24.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class InfoSettingsTableViewController: UITableViewController {
    @IBOutlet weak var versionLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = version
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1 {
            let email = "dehlen@me.com"
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
}
