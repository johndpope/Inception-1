//
//  CountryReleasesTableViewController.swift
//  Inception
//
//  Created by David Ehlen on 08.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import Foundation

import UIKit

class CountryReleasesTableViewController: UITableViewController {
    var countryCodes:[String] = []
    var countryNames:[String] = []
    let storedCountryCode = SettingsFactory.objectForKey(SettingsFactory.SettingKey.ReleaseDateCountry) as! String
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "countrySelection".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTheming()
        self.setupCountryData()
        
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        self.tableView.reloadData()
    }
    
    func setupCountryData() {
        self.countryCodes = NSLocale.ISOCountryCodes()
        self.countryCodes.sortInPlace({ $0 < $1 })
        for code in self.countryCodes {
            self.countryNames.append(code.countryNameFromCode)
        }
        let selectedCode = SettingsFactory.objectForKey(SettingsFactory.SettingKey.ReleaseDateCountry) as! String
        self.selectedIndex = self.countryCodes.indexOf(selectedCode)!
    }
    
    func updateTheming() {
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
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
        return self.countryCodes.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "countryReleaseDateDescription".localized
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CountrySelectionTableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.countryNames[indexPath.row]
        
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
        SettingsFactory.setObjectForKey(SettingsFactory.SettingKey.ReleaseDateCountry, value: self.countryCodes[indexPath.row])
        
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}