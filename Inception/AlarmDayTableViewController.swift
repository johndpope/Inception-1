//
//  AlarmDayTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 29.12.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class AlarmDayTableViewController: UITableViewController {
    var selectedIndex:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "alarmday".localized
        
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if SettingsFactory.objectForKey(SettingsFactory.SettingKey.AlarmDay) as! String == "twodaysbefore" {
            self.selectedIndex = 0
        }
        else if SettingsFactory.objectForKey(SettingsFactory.SettingKey.AlarmDay) as! String == "daybefore" {
            self.selectedIndex = 1
        }
        else {
            self.selectedIndex = 2
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        let colorView = UIView()
        colorView.backgroundColor = ThemeManager.sharedInstance.currentTheme.tableViewSelectionColor
        cell.selectedBackgroundView = colorView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmDayTableViewCell", forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "twodaysbefore".localized
        }
        else if indexPath.row == 1{
            cell.textLabel?.text = "daybefore".localized
        }
        else {
            cell.textLabel?.text = "sameday".localized
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedIndex = indexPath.row
        
        if indexPath.row == 0 {
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.AlarmDay, value: "twodaysbefore")
        }
        else if indexPath.row == 1{
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.AlarmDay, value: "daybefore")
        }
        else {
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.AlarmDay, value: "sameday")
        }
        
        self.tableView.reloadData()
    }
}
