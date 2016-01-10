//
//  NotificationScheduler.swift
//  Inception
//
//  Created by David Ehlen on 29.12.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class NotificationScheduler {
    
    class func scheduleLocalNotifications() {
        if !NSCalendar.currentCalendar().isDateInToday(SettingsFactory.objectForKey(SettingsFactory.SettingKey.DidShowNotificationsToday) as! NSDate) {
            let showCoreDataHelper = ShowWatchlistCoreDataHelper()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            if SettingsFactory.boolForKey(SettingsFactory.SettingKey.Notifications) == true {
                let shows = showCoreDataHelper.showsFromStore()
                for show in shows {
                    if let seasonsSet = show.seasons {
                        for seasons in seasonsSet.sortedSeasonArray as [SeasonWatchlistItem] {
                            if let episodesSet = seasons.episodes {
                                for episode in episodesSet.sortedEpisodesArray as [EpisodeWatchlistItem] {
                                    if let airDate = episode.airDate {
                                        if airDate.isInFutureOrToday {
                                            let localNotification = UILocalNotification()
                                            localNotification.fireDate = airDate.dateWithTime
                                            if let showName = show.name {
                                                localNotification.alertBody = "aNewEpisode" + " \(showName) " + "airs".localized + " " + airDate.relativeNotificationDate + "."
                                            }
                                            else {
                                                localNotification.alertBody = "thereIsANewEpisode".localized
                                            }
                                            localNotification.timeZone = NSTimeZone.defaultTimeZone()
                                            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                                            
                                            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                let movieCoreDataHelper = MovieWatchlistCoreDataHelper()
                let movies = movieCoreDataHelper.moviesFromStore()
                for movie in movies {
                    if let releaseDate = movie.releaseDate {
                        if let name = movie.name {
                            if releaseDate.isInFutureOrToday {
                                let localNotification = UILocalNotification()
                                localNotification.fireDate = releaseDate.dateWithTime
                                localNotification.alertBody = "theMovie" + " \(name) " + "airsInCinema".localized + " " + releaseDate.relativeNotificationDate + "."
                                localNotification.timeZone = NSTimeZone.defaultTimeZone()
                                localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                                
                                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                                
                            }
                        }
                    }
                }
                
                let personCoreDataHelper = PersonWatchlistCoreDataHelper()
                let persons = personCoreDataHelper.personsFromStore()
                for person in persons {
                    if let credits = person.credits {
                        for credit in (credits.sortedCreditsArray as [PersonCredit]) {
                            if let releaseDate = credit.releaseDate {
                                if let creditName = credit.name {
                                    if let mediaType = credit.mediaType where mediaType == "movie" {
                                        if releaseDate.isInFutureOrToday {
                                            let localNotification = UILocalNotification()
                                            localNotification.fireDate = releaseDate.dateWithTime
                                            localNotification.alertBody = "theMovie" + " \(creditName) " + "airsInCinema".localized + " " + releaseDate.relativeNotificationDate + "."
                                            localNotification.timeZone = NSTimeZone.defaultTimeZone()
                                            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                                            
                                            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
}