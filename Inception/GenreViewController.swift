//
//  GenreViewController.swift
//  Inception
//
//  Created by David Ehlen on 12.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class GenreViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var movieGenres:[Genre] = [Genre(name: "Action", id: 28),
    Genre(name: "Adventure", id: 12),
    Genre(name: "Animation", id: 16),
    Genre(name: "Comedy", id: 35),
    Genre(name: "Crime", id: 80),
    Genre(name: "Documentary", id: 99),
    Genre(name: "Drama", id: 18),
    Genre(name: "Family", id: 10751),
    Genre(name: "Fantasy", id: 14),
    Genre(name: "Foreign", id: 10769),
    Genre(name: "History", id: 36),
    Genre(name: "Horror", id: 27),
    Genre(name: "Music", id: 10402),
    Genre(name: "Mystery", id: 9648),
    Genre(name: "Romance", id: 10749),
    Genre(name: "Science Fiction", id: 878),
    Genre(name: "TV Movie", id: 10770),
    Genre(name: "Thriller", id: 53),
    Genre(name: "War", id: 10752),
    Genre(name: "Western", id: 37)]
    
    var showGenres:[Genre] = [
        Genre(name: "Action & Adventure", id: 10759),
        Genre(name: "Animation", id: 16),
        Genre(name: "Comedy", id: 35),
        Genre(name: "Documentary", id: 99),
        Genre(name: "Drama", id: 18),
        Genre(name: "Education", id:10761),
        Genre(name: "Family", id: 10751),
        Genre(name: "Kids", id: 10762),
        Genre(name: "Mystery", id: 9648),
        Genre(name: "News", id:10763),
        Genre(name: "Reality", id:10764),
        Genre(name: "Sci-Fi & Fantasy", id: 10765),
        Genre(name: "Soap", id: 10766),
        Genre(name: "Talk", id: 10767),
        Genre(name: "War & Politics", id: 10768),
        Genre(name: "Western", id: 37)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.movieGenres.count
        }
        else {
            return self.showGenres.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "movies".localized
        }
        else {
            return "shows".localized
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.movieGenres[indexPath.row].name
        }
        else {
            cell.textLabel?.text = self.showGenres[indexPath.row].name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var genre:Genre?
        if indexPath.section == 0 {
            genre = self.movieGenres[indexPath.row]
        }
        else {
            genre = self.showGenres[indexPath.row]
        }
        
        let vc : GenreDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("GenreDetailViewController") as! GenreDetailViewController
        vc.isShowGenre = indexPath.section == 1
        vc.genre = genre
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.pushViewController(vc, animated: true)
        })
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
    
    
    
}