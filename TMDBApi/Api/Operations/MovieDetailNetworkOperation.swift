//
//  MovieDetailNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class MovieDetailNetworkOperation: JSONNetworkOperation {
   
    fileprivate let movieId: Int
    var movie: MovieItem?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    override func prepareRequest() -> TMDBHTTPRequest? {
        guard var request = super.prepareRequest() else {
            return nil
        }
        
        request.GET()
        request.JSON()
        request.addQueryParams(params: queryParams)
        return request
    }
    
    override func getEndpoint() -> String {
        return "/movie/{movie_id}"
    }
    
    override func url() -> String {
        let url = super.url()
        let pathParams = ["{movie_id}" : "\(movieId)"]
        let final = url.stringByReplacingPlaceholders(placeholders: pathParams)
        return final
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("Movie detail: \(json)")
            movie = MovieItem(json: json)
        }
    }
}
