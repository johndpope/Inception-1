//
//  SecondViewController.swift
//  Inception
//
//  Created by David Ehlen on 19.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var movies:[MovieWatchlistItem] = []
    let coreDateHelper = MovieWatchlistCoreDataHelper()
    //TODO: implement shows
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "watchlist".localized
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.movies = coreDateHelper.moviesFromStore()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem() {
        //TODO: add new item
    }
    
    //MARK: UITableView Delegate & Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            coreDateHelper.removeMovie(self.movies[indexPath.row])
            self.movies = coreDateHelper.moviesFromStore()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieWatchlistTableViewCell", forIndexPath: indexPath) as! MovieWatchlistTableViewCell

        cell.delegate = self
        cell.nameLabel.text = ""
        cell.yearLabel.text = ""
        
        if let name = self.movies[indexPath.row].name {
            cell.nameLabel.text = name
        }
        
        if let year = self.movies[indexPath.row].year {
            cell.yearLabel.text = "\(year)"
        }
        
        if let imagePath = self.movies[indexPath.row].posterPath {
            let imageURL =  imageBaseURL.URLByAppendingPathComponent(imagePath)
            cell.coverImageView.loadAndFade(imageURL, placeholderImage: "placeholder-alpha")
        }
        else {
            cell.coverImageView.image = UIImage(named: "placeholder-dark")
        }
        
        if let seen = self.movies[indexPath.row].seen {
            if seen != cell.seenButton.selected {
                cell.seenButton.setSelected(Bool(seen),animated:true)
            }
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

