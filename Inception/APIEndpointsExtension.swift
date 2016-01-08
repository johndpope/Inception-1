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
        }
    }
    
    var GETParameters:[String:AnyObject] {
        switch self {
        case .MultiSearch(let searchString): return ["query":searchString,"api_key":APIKEY]
        case .Movie(_): return ["api_key":APIKEY, "append_to_response":"releases"]
        case .Show(_): return ["api_key":APIKEY]
        case .Person(_): return ["api_key":APIKEY]
        case .MovieTrailer(_) : return ["api_key":APIKEY]
        case .SimilarMovies(_) : return ["api_key":APIKEY]
        case .MovieCredits(_) : return ["api_key":APIKEY]
        case .PersonCredits(_): return ["api_key":APIKEY]
        case .ShowTrailer(_) : return ["api_key":APIKEY]
        case .SimilarShows(_) : return ["api_key":APIKEY]
        case .ShowCredits(_) : return ["api_key":APIKEY]
        case .CinemaMovies : return ["api_key":APIKEY]
        case .PopularMovies : return ["api_key":APIKEY]
        case .PopularShows : return ["api_key":APIKEY]
        case .TopRatedMovies : return ["api_key":APIKEY]
        case .TopRatedShows : return ["api_key":APIKEY]
        case .MoviesForGenre(let genreId) : return ["api_key":APIKEY,"sort_by":"popularity.desc","with_genres":"\(genreId)"]
        case .ShowsForGenre(let genreId) : return ["api_key":APIKEY,"sort_by":"popularity.desc","with_genres":"\(genreId)"]
        case .SeasonsForShow(_, _) : return ["api_key": APIKEY]
        }
    }
    
    
}