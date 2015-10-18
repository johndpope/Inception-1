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
    
    var movieGenres:[Genre] = JSONParser.parseMovieGenres()
    var showGenres:[Genre] = JSONParser.parseShowGenres()
    
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
         let cell = tableView.dequeueReusableCellWithIdentifier("GenreTableViewCell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.movieGenres[indexPath.row].name
        }
        else {
            cell.textLabel?.text = self.showGenres[indexPath.row].name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}