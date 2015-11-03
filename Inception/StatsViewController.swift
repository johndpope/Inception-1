//
//  ProfileViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import Charts

class StatsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var horizontalBarChart:HorizontalBarChartView!
    
    struct Stats{
        var key: String
        var value: String
        
        init(key: String, value: String){
            self.key = key
            self.value = value
        }
    }
    
    var movieData:[Stats] = []
    var showData:[Stats] = []

    let movieCoreDataHelper = MovieWatchlistCoreDataHelper()
    let showCoreDataHelper = ShowWatchlistCoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "stats".localized
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.setupChart()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadStats()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.horizontalBarChart.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadStats() {
        self.movieData.removeAll()
        self.showData.removeAll()
        
        let shows = showCoreDataHelper.showsFromStore()
        let movies = movieCoreDataHelper.moviesFromStore()
        self.movieData.append(Stats(key: "noSeenMovies".localized, value: "\(movies.count)"))
        self.showData.append(Stats(key: "noSeenShows".localized, value: "\(shows.count)"))
        
        var seenEpisodesCount = 0
        var showTimeSpent = 0
        
        for show in shows {
            if let seasons = show.seasons {
                for season in seasons.array as! [SeasonWatchlistItem]  {
                    if let episodes = season.episodes {
                        for episode in episodes.array as! [EpisodeWatchlistItem] {
                            if let seen = episode.seen {
                                if seen == true {
                                    seenEpisodesCount += 1
                                    if let episodeRuntime = show.episodeRuntime {
                                        showTimeSpent += Int(episodeRuntime)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.showData.append(Stats(key: "noSeenEpisodes".localized, value: "\(seenEpisodesCount)"))
        
        var movieTimeSpent = 0
        for movie in movies {
            if let runtime = movie.runtime {
                movieTimeSpent += Int(runtime)
            }
        }
        
        let totalTimeSpent = movieTimeSpent + showTimeSpent
        self.setChartData(["Total","shows".localized, "movies".localized], yValues: [totalTimeSpent,showTimeSpent, movieTimeSpent])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.movieData.count
        }
        else {
            return self.showData.count
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! StatsTableViewCell).keyLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        (cell as! StatsTableViewCell).valueLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatsTableViewCell", forIndexPath: indexPath) as! StatsTableViewCell
        if indexPath.section == 0 {
            cell.keyLabel.text = self.movieData[indexPath.row].key
            cell.valueLabel.text = self.movieData[indexPath.row].value

        }
        else {
            cell.keyLabel.text = self.showData[indexPath.row].key
            cell.valueLabel.text = self.showData[indexPath.row].value
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
