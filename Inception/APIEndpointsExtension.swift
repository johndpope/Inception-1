//
//  APIEndpointsExtension.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
extension APIEndpoints : APIRoute {
    var path: String {
        switch self {
        case .MultiSearch(_): return "/search/multi"
        case .Movie(let movieId): return "/movie/\(movieId)"
        case .Show(let showId):return "/tv/\(showId)"
        case .Person(let personId):return "/person/\(personId)"
        case .MovieTrailer(let movieId) : return "/movie/\(movieId)/videos"
        case .SimilarMovies(let movieId) :return "/movie/\(movieId)/similar"
        case .MovieCredits(let movieId) : return "/movie/\(movieId)/credits"
        case .PersonCredits(let personId):return "/person/\(personId)/combined_credits"
        case .ShowTrailer(let showId) : return "/tv/\(showId)/videos"
        case .SimilarShows(let showId) : return "/tv/\(showId)/similar"
        case .ShowCredits(let showId) : return "/tv/\(showId)/credits"
        case .CinemaMovies : return "/movie/now_playing"
        case .PopularMovies : return "/movie/popular"
        case .PopularShows : return "/tv/popular"
        case .TopRatedMovies: return "/movie/top_rated"
        case .TopRatedShows: return "/tv/top_rated"
        case .MoviesForGenre(_) : return "/discover/movie"
        case .ShowsForGenre(_) : return "/discover/tv"
        case .SeasonsForShow(let showId, let seasonNumber) : return "/tv/\(showId)/season/\(seasonNumber)"
        case .Releases(let movieId): return "movie/\(movieId)/releases"
        }
    }
    
    var GETParameters:[String:AnyObject] {
        var params = ["api_key":APIKEY]
        
        switch self {
            case .MultiSearch(let searchString):
                params["query"] = searchString
            case .Movie(_):
                params["append_to_response"] = "releases"
                   case .MoviesForGenre(let genreId) :
                params["sort_by"] = "popularity.desc"
                params["with_genres"] = "\(genreId)"
            case .ShowsForGenre(let genreId) :
                params["sort_by"] = "popularity.desc"
                params["with_genres"] = "\(genreId)"
            default:()
        }
        return params
    }
}