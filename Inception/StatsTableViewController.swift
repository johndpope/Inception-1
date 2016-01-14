//
//  ProfileViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import Charts

class StatsTableViewController : UITableViewController {
    
    @IBOutlet weak var horizontalBarChart:HorizontalBarChartView!
    
    private let hourThreshold = 999
    private let dayThreshold = 59940 //999h
    
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
        self.movieData.append(Stats(key: "noTrackedMovies".localized, value: "\(movies.count)"))
        self.showData.append(Stats(key: "noTrackedShows".localized, value: "\(shows.count)"))
        
        var seenEpisodesCount = 0
        var showTimeSpent = 0
        
        for show in shows {
            if let seasons = show.seasons {
                for season in seasons.sortedSeasonArray as [SeasonWatchlistItem]  {
                    if let episodes = season.episodes {
                        for episode in episodes.sortedEpisodesArray as [EpisodeWatchlistItem] {
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
                if let seen = movie.seen {
                    if Bool(seen) {
                        movieTimeSpent += Int(runtime)
                    }
                }
            }
        }
        
        let totalTimeSpent = movieTimeSpent + showTimeSpent
        
        if totalTimeSpent > dayThreshold {
            self.setChartData(["Total","shows".localized, "movies".localized], yValues: convertToDays([totalTimeSpent,showTimeSpent, movieTimeSpent]), timeSpentLabel: "daysSpent".localized)
        }
        else if totalTimeSpent > hourThreshold {
            self.setChartData(["Total","shows".localized, "movies".localized], yValues: convertToHours([totalTimeSpent,showTimeSpent, movieTimeSpent]), timeSpentLabel: "hoursSpent".localized)
        }
        else {
            let yValuesInDoubles = [totalTimeSpent,showTimeSpent, movieTimeSpent].map({Double($0)})
            self.setChartData(["Total","shows".localized, "movies".localized], yValues: yValuesInDoubles, timeSpentLabel: "minutesSpent".localized)
        }
    }
    
    func convertToDays(yValues:[Int]) -> [Double] {
        var yValuesInDays:[Double] = []
        
        for value in yValues {
            yValuesInDays.append(Double(value)/60.0/24.0);
        }
        return yValuesInDays
    }
    
    func convertToHours(yValues:[Int]) -> [Double] {
        var yValuesInHours:[Double] = []
        
        for value in yValues {
            yValuesInHours.append(Double(value)/60.0);
        }
        return yValuesInHours
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.movieData.count
        }
        else {
            return self.showData.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "movies".localized
        }
        else {
            return "shows".localized
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        cell.detailTextLabel?.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatsTableViewCell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.movieData[indexPath.row].key
            cell.detailTextLabel?.text = self.movieData[indexPath.row].value

        }
        else {
            cell.textLabel?.text = self.showData[indexPath.row].key
            cell.detailTextLabel?.text = self.showData[indexPath.row].value
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
