//
//  PersonDetailViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    var id:Int = 0
    var person:Person?
    var tableData:[String] = []
    var tableDataKeys:[String] = []
    var knownFor:[MultiSearchResult] = []
    internal var selectedSegmentIndex:Int = 0
    let personCoreDataHelper = PersonWatchlistCoreDataHelper()
    
    @IBOutlet weak var infoView:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var personImageView:UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    //TODO: add person to watchlist 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupPersonImageView()
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        self.activityIndicator.startAnimating()
        
        APIController.request(APIEndpoints.Person(id)) { (data:AnyObject?, error:NSError?) in
            self.activityIndicator.stopAnimating()
            if (error != nil) {
                AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                print(error)
            } else {
                self.person = JSONParser.parsePerson(data)
                self.setupBarButtonItem()
                self.updateUI()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTheming()
        self.updateBarButtonColor()
    }
    
    func setupBarButtonItem() {
        let image = UIImage(named: "watchlist")
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "updateWatchlist:")
        
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.updateBarButtonColor()
    }
    
    func updateBarButtonColor() {
        if self.navigationItem.rightBarButtonItem != nil {
            if self.personCoreDataHelper.hasPerson(self.person!.id!) {
                self.navigationItem.rightBarButtonItem!.tintColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
            }
            else {
                self.navigationItem.rightBarButtonItem!.tintColor = ThemeManager.sharedInstance.currentTheme.textColor
            }
        }
    }
    
    func updateWatchlist(sender:UIBarButtonItem) {
        let person = self.person!
        if self.personCoreDataHelper.hasPerson(person.id!) {
            self.personCoreDataHelper.removePersonWithId(person.id!)
            sender.tintColor = ThemeManager.sharedInstance.currentTheme.textColor
        }
        else {
            self.personCoreDataHelper.insertPersonItem(person.id!, name: person.name, profilePath: person.profilePath, credits:self.knownFor)
            sender.tintColor = ThemeManager.sharedInstance.currentTheme.primaryTintColor
        }
    }
    
    func updateTheming() {
        self.infoView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.nameLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        self.activityIndicator.color = ThemeManager.sharedInstance.currentTheme.textColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    func setupPersonImageView() {
        self.personImageView.layer.borderWidth = 1.0
        self.personImageView.layer.borderColor = ThemeManager.sharedInstance.currentTheme.tableViewSelectionColor.CGColor
        self.personImageView.layer.cornerRadius = self.personImageView.frame.size.width / 2
        self.personImageView.clipsToBounds = true
    }
    
    func updateUI() {
        if person != nil {
            var personName = ""
            if person!.name != nil {
                self.nameLabel.text = person!.name!
                personName = person!.name!
            }
            
            if person!.profilePath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(person!.profilePath!)
                self.personImageView.loadAndFadeWithImage(imageURL,placeholderImage:self.personImageView.imageWithString(personName, color: ThemeManager.sharedInstance.currentTheme.primaryTintColor, circular: true))
            }
            else {
                self.personImageView.image = self.personImageView.imageWithString(personName, color: ThemeManager.sharedInstance.currentTheme.primaryTintColor, circular: true)
            }
            
            (self.tableDataKeys, self.tableData) = person!.tableData()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func changeViews(sender:UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 1 {
            self.tableView.reloadData()
            
            if self.knownFor.count == 0 {
                APIController.request(APIEndpoints.PersonCredits(id)) { (data:AnyObject?, error:NSError?) in
                    if (error != nil) {
                        AlertFactory.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage", from:self)
                    } else {
                        self.knownFor = JSONParser.parseCombinedCredits(data)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else {
            self.tableView.reloadData()
        }
    }
}
