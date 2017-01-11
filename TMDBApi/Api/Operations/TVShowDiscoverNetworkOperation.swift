//
//  TVShowDiscoverNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class TVShowDiscoverNetworkOperation: JSONNetworkOperation {

    fileprivate let pageToSearch: Int?
    
    var page: Int = 0
    var totalPages: Int = 0
    var totalResults: Int = 0
    var tvShows: TVShowDiscoverModel?

    init(pagetToSearch: Int?) {
        self.pageToSearch = pagetToSearch
    }

    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        
        let additionalParams = [URLQueryItem(name: "sort_by", value: "popularity.desc"),
                                URLQueryItem(name: "include_null_first_air_date", value: "\(false)")]
        
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
        return "/discover/tv"
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("TV Show discover finish: \(json)")
            page = json["page"].intValue
            totalPages = json["total_pages"].intValue
            totalResults = json["total_results"].intValue
            tvShows = TVShowDiscoverModel.getTVShows(fromJSON: json)
        }
    }
}
