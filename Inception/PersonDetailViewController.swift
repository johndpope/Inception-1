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
    
    @IBOutlet weak var infoView:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var personImageView:UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
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
                self.updateUI()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    func setupPersonImageView() {
        self.personImageView.layer.borderWidth = 1.0
        self.personImageView.layer.borderColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0).CGColor
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
                self.personImageView.loadAndFadeWithImage(imageURL,placeholderImage:self.personImageView.imageWithString(personName, color: UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0), circular: true))
            }
            else {
                self.personImageView.image = self.personImageView.imageWithString(personName, color: UIColor(red: 1.0, green: 222.0/255.0, blue: 96.0/255.0, alpha: 1.0), circular: true)
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
