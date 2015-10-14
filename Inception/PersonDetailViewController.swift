//
//  PersonDetailViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var id:Int = 0
    var person:Person?
    var tableData:[String] = []
    var tableKeys:[String] = []
    var knownFor:[MultiSearchResult] = []
    
    @IBOutlet weak var infoView:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var personImageView:UIImageView!
    
    private var selectedSegmentIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.personImageView.layer.borderWidth = 1.0
        
        self.personImageView.layer.borderColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0).CGColor
        self.personImageView.layer.cornerRadius = self.personImageView.frame.size.width / 2
        self.personImageView.clipsToBounds = true

        
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.backgroundColor = UIColor.darkTextColor()
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        APIController.request(APIEndpoints.Person(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                self.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage")
                print(error)
            } else {
                self.person = JSONParser.parsePerson(data)
                self.updateUI()
            }
        }
    }
    
    func showAlert(localizeTitleKey:String, localizeMessageKey:String) {
        let alertController = UIAlertController(title: localizeTitleKey.localized, message: localizeMessageKey.localized, preferredStyle:.Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { (_) in
        }
        alertController.addAction(dismissAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        CacheFactory.clearAllCaches()
    }
    
    func updateUI() {
        if person != nil {
            if person!.name != nil {
                self.nameLabel.text = person!.name
            }
            
            if person!.profilePath != nil {
                let imageURL =  imageBaseURL.URLByAppendingPathComponent(person!.profilePath!)
                self.personImageView.loadAndFade(imageURL,placeholderImage:"placeholder-alpha")
            }
            else {
                self.personImageView.image = UIImage(named: "placeholder-dark")
            }
            
            if person!.placeOfBirth != nil && !person!.placeOfBirth!.isEmpty {
                self.tableData.append(person!.placeOfBirth!)
                self.tableKeys.append("placeofbirth".localized)
            }
           
            if self.person!.birthday != nil && !self.person!.birthday!.isEmpty {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date:NSDate = dateFormatter.dateFromString(person!.birthday!)!
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                self.tableData.append(dateFormatter.stringFromDate(date))
                self.tableKeys.append("birthday".localized)

            }
            
            if self.person!.deathday != nil && !self.person!.deathday!.isEmpty {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date:NSDate = dateFormatter.dateFromString(person!.deathday!)!
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                self.tableData.append(dateFormatter.stringFromDate(date))
                self.tableKeys.append("deathday".localized)

            }
            
            if self.person!.biography != nil && !self.person!.biography!.isEmpty {
                self.tableData.append(person!.biography!)
                self.tableKeys.append("biography".localized)
            }
            
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
                        self.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage")
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.selectedSegmentIndex == 0 {
          let cell = tableView.dequeueReusableCellWithIdentifier("PersonDetailCell", forIndexPath: indexPath) as! PersonDetailCell
        
            cell.textLbl.text = tableKeys[indexPath.row]
            cell.detailTextLbl.text = tableData[indexPath.row]
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("KnownForCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = self.knownFor[indexPath.row].name
            let imageURL =  imageBaseURL.URLByAppendingPathComponent(self.knownFor[indexPath.row].imagePath)
            cell.imageView?.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedSegmentIndex == 0 {
            return self.tableData.count
        }
        else {
            return self.knownFor.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedSegmentIndex == 1 {
            let element = self.knownFor[indexPath.row]
            if element.mediaType == "movie" {
                let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
                vc.id = element.id
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })

            }
            else {
                let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
                vc.id = element.id
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.pushViewController(vc, animated: true)
                })

            }
        }
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedSegmentIndex == 1 {
            let cell  = tableView.cellForRowAtIndexPath(indexPath)
            cell!.contentView.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
            cell!.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        }
        
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedSegmentIndex == 1 {
            let cell  = tableView.cellForRowAtIndexPath(indexPath)
            cell!.contentView.backgroundColor = .darkTextColor()
            cell!.backgroundColor = .darkTextColor()
        }
        
    }

}
