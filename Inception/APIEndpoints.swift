//
//  APIEndpoints.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation

var baseURL: NSURL { return NSURL(string: "http://api.themoviedb.org/3")!}
var imageBaseURL: NSURL {
    let imageQualityString = SettingsFactory.objectForKey(SettingsFactory.SettingKey.ImageQuality) as! String
    if let imageQuality = SettingsFactory.ImageQuality(rawValue: imageQualityString) {
        switch imageQuality {
        case .Compressed : return NSURL(string: "https://image.tmdb.org/t/p/w185")!
        case .Original: return NSURL(string: "https://image.tmdb.org/t/p/original")!
        }
    }
    return NSURL(string: "https://image.tmdb.org/t/p/w185")!
}

var imageBaseURLW780: NSURL { return NSURL(string: "https://image.tmdb.org/t/p/w780")!}

enum APIEndpoints {
    case MultiSearch(String)
    case Movie(Int)
    case Show(Int)
    case Person(Int)
    case MovieTrailer(Int)
    case SimilarMovies(Int)
    case MovieCredits(Int)
    case PersonCredits(Int)
    case ShowTrailer(Int)
    case SimilarShows(Int)
    case ShowCredits(Int)
    case CinemaMovies
    case PopularMovies
    case PopularShows
    case TopRatedMovies
    case TopRatedShows
    case MoviesForGenre(Int)
    case ShowsForGenre(Int)
    case SeasonsForShow(Int, Int)
    case Releases(Int)
}