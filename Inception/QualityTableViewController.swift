//
//  QualityTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 28.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class QualityTableViewController: UITableViewController {
    var showsImageQuality = false
    var imageQualities:[SettingsFactory.ImageQuality] = [SettingsFactory.ImageQuality.Compressed,SettingsFactory.ImageQuality.Original]
    var videoQualities:[SettingsFactory.VideoQuality] = [SettingsFactory.VideoQuality.HD,SettingsFactory.VideoQuality.Medium,SettingsFactory.VideoQuality.Small]
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if self.showsImageQuality {
            self.title = "imageQuality".localized
        }
        else {
            self.title = "videoQuality".localized
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.showsImageQuality {
           let storedQualityString = SettingsFactory.objectForKey(SettingsFactory.SettingKey.ImageQuality) as! String
            if let storedQuality = SettingsFactory.ImageQuality(rawValue: storedQualityString) {
                if let index = self.imageQualities.indexOf(storedQuality) {
                    self.selectedIndex = index
                }
            }
        }
        else {
            let storedQualityString = SettingsFactory.objectForKey(SettingsFactory.SettingKey.VideoQuality) as! String
            if let storedQuality = SettingsFactory.VideoQuality(rawValue: storedQualityString) {
                if let index = self.videoQualities.indexOf(storedQuality) {
                    self.selectedIndex = index
                }
            }
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showsImageQuality {
            return 2
        }
        else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "quality".localized
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QualityTableViewCell", forIndexPath: indexPath)
        if self.showsImageQuality {
            cell.textLabel?.text = SettingsFactory.localizedImageQuality(self.imageQualities[indexPath.row])
        }
        else {
            cell.textLabel?.text = SettingsFactory.localizedVideoQuality(self.videoQualities[indexPath.row])
        }
        if indexPath.row == self.selectedIndex {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if self.showsImageQuality {
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.ImageQuality, value: self.imageQualities[indexPath.row].rawValue)
        }
        else {
           SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.VideoQuality, value: self.videoQualities[indexPath.row].rawValue)
        }
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}
