//
//  MultisearchNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

class MultisearchNetworkOperation: JSONNetworkOperation {

    fileprivate let textToSearch: String
    fileprivate let pageToSearch: Int?
    var page: Int = 0
    var totalPages: Int = 0
    var totalResults: Int = 0
    var searchResults: MultiSearchModel?
    
    init(textToSearch: String, pageToSearchIn: Int? = nil) {
        self.textToSearch = textToSearch
        pageToSearch = pageToSearchIn
    }
    
    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        params.append(URLQueryItem(name: "include_adult", value: "\(false)"))
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
        return "/search/multi"
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("Multi search: \(json)")
            page = json["page"].intValue
            totalPages = json["total_pages"].intValue
            totalResults = json["total_results"].intValue
            searchResults = MultiSearchModel(json: json)
        }
    }
}
