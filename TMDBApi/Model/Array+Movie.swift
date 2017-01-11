//
//  Array+Movie.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 6/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias MovieDiscoverModel = [MovieItem]
public typealias MoviePopularModel = [MovieItem]
public typealias MovieSearchModel = [MovieItem]
public typealias TVShowDiscoverModel = [TvShowItem]
public typealias TVShowPopularModel = [TvShowItem]
public typealias TVShowSearchModel = [TvShowItem]

extension Array {

    static func getMovies(fromJSON json: JSON) -> [MovieItem]? {
        guard let results = json["results"].array else {
            return nil
        }
        
        var movies: [MovieItem] = []
        
        for json in results {
            if let movie = MovieItem(json: json) {
                movies.append(movie)
            }
        }
        
        return (!movies.isEmpty) ? movies : nil
    }
    
    static func getTVShows(fromJSON json: JSON) -> [TvShowItem]? {
        guard let results = json["results"].array else {
            return nil
        }
        
        var tvShows: [TvShowItem] = []
        
        for json in results {
            if let tvShow = TvShowItem(json: json) {
                tvShows.append(tvShow)
            }
        }
        
        return (!tvShows.isEmpty) ? tvShows : nil
    }
}
