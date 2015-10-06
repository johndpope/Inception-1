//
//  FirstViewController.swift
//  Inception
//
//  Created by David Ehlen on 19.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results:[MultiSearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "search".localized
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.backgroundColor = UIColor.darkTextColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* UITableView Delegate & Datasource */
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.darkTextColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
        
        let imageURL =  imageBaseURL.URLByAppendingPathComponent(self.results[indexPath.row].imagePath)
        cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
        cell.headingLabel.text = self.results[indexPath.row].name
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch self.results[indexPath.row].mediaType {
        case "movie":
            let vc : MovieDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailTableViewController") as! MovieDetailTableViewController
            vc.id = self.results[indexPath.row].id
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "tv":
            let vc : TVShowDetailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TVShowDetailTableViewController") as! TVShowDetailTableViewController
            vc.id = self.results[indexPath.row].id
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case "person":
            let vc : PersonDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("PersonDetailViewController") as! PersonDetailViewController
            vc.id = self.results[indexPath.row].id
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [UITableViewRowAction]? {
        let watchlistAction = UITableViewRowAction(style: .Normal, title: "addwatchlist".localized, handler: {(rowAction:UITableViewRowAction, indexPath:NSIndexPath) in
            print("Triggered")
            //TODO: add to watchlist
        })
        
        watchlistAction.backgroundColor = UIColor(red: 227.0/255.0, green: 187.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        
        return [watchlistAction]
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
        cell!.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)

    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .darkTextColor()
        cell!.backgroundColor = .darkTextColor()

    }
    
    /* UISearchBar Delegate */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.results.removeAll()
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            APIController.request(APIEndpoints.MultiSearch(searchText)) { (data:AnyObject?, error:NSError?) in
                    if (error != nil) {
                        self.showAlert("errorTitle",localizeMessageKey:"networkErrorMessage")
                        self.searchBar.resignFirstResponder()
                    } else {
                        self.results = JSONParser.mutliSearchResults(data)
                        self.tableView.reloadData()
                    }
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
}

