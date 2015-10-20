//
//  EpisodeGuideViewController.swift
//  Inception
//
//  Created by David Ehlen on 20.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SwiftyJSON

class EpisodeGuideViewController : UIViewController,SeasonNavigatorDelegate {
    var seasons:[Season]!
    var showId:Int!
    
    @IBOutlet weak var seasonNavigator:SeasonNavigatorScrollView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "showSeasons".localized
        seasonNavigator.seasonNavigatorDelegate = self
        seasonNavigator.setup(seasons.count)
        self.loadEpisodes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CacheFactory.clearAllCaches()
    }
    
    func loadEpisodes() {
        self.activityIndicator.startAnimating()
        let group = dispatch_group_create()

        for season in self.seasons {
            if let seasonNumber = season.seasonNumber {
                
                dispatch_group_enter(group)
                APIController.request(APIEndpoints.SeasonsForShow(self.showId, seasonNumber)) { (data:AnyObject?, error:NSError?) in
                    dispatch_group_leave(group)

                    if (error != nil) {
                        //TODO: error handling
                        print(error)
                    } else {
                        season.episodes = JSONParser.parseEpisodes(data)
                    }
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            //TODO: Update UI
        }
    }
    
    //MARK: SeasonNavigatorDelegate
    func didClickIndex(index:Int) {
        print("Did Click Index: #\(index)")
    }
}
