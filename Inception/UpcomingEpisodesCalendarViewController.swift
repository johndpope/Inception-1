//
//  UpcomingEpisodesCalendarViewController.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import JTCalendar

class UpcomingEpisodesCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: JTHorizontalCalendarView!
    
    var calendarManager = JTCalendarManager()
    var selectedDate = NSDate()
    
    struct UpcomingEntry {
        var description: String
        var name: String
        var date: NSDate
        
        init(description: String, name:String, date:NSDate){
            self.description = description
            self.name = name
            self.date = date
        }
    }
    
    var allUpcomingEntries:[UpcomingEntry] = []
    var tableEntries:[UpcomingEntry] = []
    var showCoreDataHelper = ShowWatchlistCoreDataHelper()
    var movieCoreDataHelper = MovieWatchlistCoreDataHelper()
    var personCoreDataHelper = PersonWatchlistCoreDataHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadAllData()
        self.setupCalendar()
        self.loadEntriesForDate(NSDate())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTheming()
        self.updateMonthText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTheming() {
        self.tableView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = ThemeManager.sharedInstance.currentTheme.barStyle
        self.navigationController?.navigationBar.translucent = ThemeManager.sharedInstance.currentTheme.navBarTranslucent
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func entryExists(name:String) -> Bool {
        let results = self.allUpcomingEntries.filter { $0.name == name }
        return results.isEmpty == false
    }
    
    func loadAllData() {
        let shows = self.showCoreDataHelper.showsFromStore()
        for show in shows {
            if let seasons = show.seasons {
                for season in seasons.sortedSeasonArray as [SeasonWatchlistItem] {
                    if let episodes = season.episodes  {
                        for episode in episodes.sortedEpisodesArray as [EpisodeWatchlistItem] {
                            if let epName = episode.name {
                                if let shName = show.name {
                                    if let epDate = episode.airDate {
                                        if let date = epDate.date {
                                            let upcomingEpisode = UpcomingEntry(description: epName, name: shName, date: date)
                                            self.allUpcomingEntries.append(upcomingEpisode)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let movies = self.movieCoreDataHelper.moviesFromStore()
        for movie in movies {
            if let releaseDate = movie.releaseDate {
                if let name = movie.name {
                    let upcomingMovie = UpcomingEntry(description:"", name: name, date:releaseDate)
                    self.allUpcomingEntries.append(upcomingMovie)
                }
            }
        }
        
        let persons = self.personCoreDataHelper.personsFromStore()
        for person in persons {
            if let credits = person.credits {
                for credit in (credits.sortedCreditsArray as [PersonCredit]) {
                    if let releaseDate = credit.releaseDate {
                        if let creditName = credit.name {
                            if let mediaType = credit.mediaType where mediaType == "movie" {
                                if !entryExists(creditName) {
                                    let upcomingEntry = UpcomingEntry(description: "", name: creditName, date: releaseDate)
                                    self.allUpcomingEntries.append(upcomingEntry)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadEntriesForDate(date:NSDate) {
        self.tableEntries.removeAll()
        for upcomingEpisode in self.allUpcomingEntries {
            if NSDate.isSameDay(date, date2: upcomingEpisode.date) {
                self.tableEntries.append(upcomingEpisode)
            }
        }
        self.tableView.reloadData()
    }
    
    func hasEntryForDate(date:NSDate) -> Bool {
        for upcomingEpisode in self.allUpcomingEntries {
            if NSDate.isSameDay(date, date2: upcomingEpisode.date) {
                return true
            }
        }
        return false
    }
    
    func numberOfEpisodesForDate(date:NSDate) -> Int {
        var count = 0
        for upcomingEpisode in self.allUpcomingEntries {
            if NSDate.isSameDay(date, date2: upcomingEpisode.date) {
                count += 1
            }
        }
        return count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableEntries.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! UpcomingEpisodesTableViewCell).episodeNameLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        (cell as! UpcomingEpisodesTableViewCell).showNameLabel.textColor = ThemeManager.sharedInstance.currentTheme.textColor
        (cell as! UpcomingEpisodesTableViewCell).dateLabel.textColor = ThemeManager.sharedInstance.currentTheme.darkerTextColor
        cell.contentView.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
        cell.backgroundColor = ThemeManager.sharedInstance.currentTheme.backgroundColor
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpcomingEpisodesTableViewCell", forIndexPath: indexPath) as! UpcomingEpisodesTableViewCell

        cell.episodeNameLabel.text = self.tableEntries[indexPath.row].description
        cell.showNameLabel.text = self.tableEntries[indexPath.row].name
        cell.dateLabel.text = self.tableEntries[indexPath.row].date.string
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
