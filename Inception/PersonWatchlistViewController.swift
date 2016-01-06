//
//  PersonWatchlistViewController.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import UIKit

class PersonWatchlistViewController: UIViewController {
    
    var personWatchlistItem:PersonWatchlistItem?
    var personCoreDataHelper = PersonWatchlistCoreDataHelper()
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = personWatchlistItem?.name
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didLoadPersonCredits", name: "personCreditsDidLoad", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.updateTheming()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didLoadPersonCredits() {
        if let person = self.personWatchlistItem {
            self.personWatchlistItem = self.personCoreDataHelper.personWithId(person.id.integerValue)
            self.tableView.reloadData()
        }
    }
    
    func updateTheming() {
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CacheFactory.clearAllCaches()
    }
}

