//
//  MoviePopularNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class MoviePopularNetworkOperation: JSONNetworkOperation {

    var movies: MoviePopularModel?
    
    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        params.append(URLQueryItem(name: "page", value: "\(1)"))

        return params
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
        return "/movie/popular"
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("Movie popular finish: \(json)")
            movies = MoviePopularModel.getMovies(fromJSON: json)
        }
    }
}
