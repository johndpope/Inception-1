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
    
    struct UpcomingEpisode {
        var episodeName: String
        var showName: String
        var date: NSDate
        
        init(episodeName: String, showName:String, date:NSDate){
            self.episodeName = episodeName
            self.showName = showName
            self.date = date
        }
    }
    
    var allEpisodes:[UpcomingEpisode] = []
    var tableEntries:[UpcomingEpisode] = []
    var showCoreDataHelper = ShowWatchlistCoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadAllData()
        self.setupCalendar()
        self.loadEntriesForDate(NSDate())
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateMonthText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAllData() {
        let shows = self.showCoreDataHelper.showsFromStore()
        for show in shows {
            if let seasons = show.seasons {
                for season in seasons.array as! [SeasonWatchlistItem] {
                    if let episodes = season.episodes  {
                        for episode in episodes.array as! [EpisodeWatchlistItem] {
                            if let epName = episode.name {
                                if let shName = show.name {
                                    if let epDate = episode.airDate {
                                        if let date = epDate.date {
                                            let upcomingEpisode = UpcomingEpisode(episodeName: epName, showName: shName, date: date)
                                            self.allEpisodes.append(upcomingEpisode)
                                        }
                                    }
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
        for upcomingEpisode in self.allEpisodes {
            if NSDate.isSameDay(date, date2: upcomingEpisode.date) {
                self.tableEntries.append(upcomingEpisode)
            }
        }
        self.tableView.reloadData()
    }
    
    func hasEntryForDate(date:NSDate) -> Bool {
        for upcomingEpisode in self.allEpisodes {
            if NSDate.isSameDay(date, date2: upcomingEpisode.date) {
                return true
            }
        }
        return false
    }
    
    func numberOfEpisodesForDate(date:NSDate) -> Int {
        var count = 0
        for upcomingEpisode in self.allEpisodes {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpcomingEpisodesTableViewCell", forIndexPath: indexPath) as! UpcomingEpisodesTableViewCell

        cell.episodeNameLabel.text = self.tableEntries[indexPath.row].episodeName
        cell.showNameLabel.text = self.tableEntries[indexPath.row].showName
        cell.dateLabel.text = self.tableEntries[indexPath.row].date.string
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
