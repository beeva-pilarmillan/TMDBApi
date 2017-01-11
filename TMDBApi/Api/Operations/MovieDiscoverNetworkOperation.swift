//
//  MovieDiscoverNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class MovieDiscoverNetworkOperation: JSONNetworkOperation {

    fileprivate let pageToSearch: Int?
    
    var page: Int = 0
    var totalPages: Int = 0
    var totalResults: Int = 0
    var movies: MovieDiscoverModel?
    
    init(pagetToSearch: Int?) {
        self.pageToSearch = pagetToSearch
    }
    
    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        
        let additionalParams = [URLQueryItem(name: "sort_by", value: "popularity.desc"),
                                URLQueryItem(name: "include_adult", value: "\(false)"),
                                URLQueryItem(name: "include_video", value: "\(false)")]
        
        if let pageToSearch = pageToSearch {
            params.append(URLQueryItem(name: "page", value: "\(pageToSearch)"))
        }
        
        params.append(contentsOf: additionalParams)
        
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
        return "/discover/movie"
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("Movie discover finish: \(json)")
            page = json["page"].intValue
            totalPages = json["total_pages"].intValue
            totalResults = json["total_results"].intValue
            movies = MovieDiscoverModel.getMovies(fromJSON: json)
        }
    }
}
