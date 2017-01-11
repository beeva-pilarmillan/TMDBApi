//
//  TvShowSearchNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class TVShowSearchNetworkOperation: JSONNetworkOperation {
    
    fileprivate let textToSearch: String
    fileprivate let pageToSearch: Int?
    var page: Int = 0
    var totalPages: Int = 0
    var totalResults: Int = 0
    var searchResults: TVShowSearchModel?
    
    init(textToSearch: String, pageToSearchIn: Int? = nil) {
        self.textToSearch = textToSearch
        pageToSearch = pageToSearchIn
    }
    
    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        params.append(URLQueryItem(name: "query", value: textToSearch))
        
        if let page = pageToSearch {
            params.append(URLQueryItem(name: "page", value: String(page)))
        }
        
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
        return "/search/tv"
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("TV show search: \(json)")
            page = json["page"].intValue
            totalPages = json["total_pages"].intValue
            totalResults = json["total_results"].intValue
            searchResults = TVShowSearchModel.getTVShows(fromJSON: json)
        }
    }
}
