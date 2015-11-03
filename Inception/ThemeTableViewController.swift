//
//  ThemeTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 02.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class ThemeTableViewController: UITableViewController {
    var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Theme"
        
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.updateTheming()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if SettingsFactory.objectForKey(SettingsFactory.SettingKey.Theme) as! String == SettingsFactory.ThemeOption.Dark.rawValue {
            self.selectedIndex = 0
        }
        else {
            self.selectedIndex = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTheming() {
        self.tabBarController?.tabBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        (UIApplication.sharedApplication().delegate as! AppDelegate).setTableViewSelectionColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ThemeTableViewCell", forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "dark".localized
        }
        else {
            cell.textLabel?.text = "light".localized
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
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.Theme, value: SettingsFactory.ThemeOption.Dark.rawValue)
        }
        else {
            SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.Theme, value: SettingsFactory.ThemeOption.Light.rawValue)
        }
        
        self.updateTheming()
        self.tableView.reloadData()
    }
}
