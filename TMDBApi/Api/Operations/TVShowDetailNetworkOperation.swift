//
//  TVShowDetailNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class TVShowDetailNetworkOperation: JSONNetworkOperation {

    fileprivate let tvShowId: Int
    var tvShow: TvShowItem?
    
    init(tvShowId: Int) {
        self.tvShowId = tvShowId
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
        return "/tv/{tv_id}"
    }
    
    override func url() -> String {
        let url = super.url()
        let pathParams = ["{tv_id}" : "\(tvShowId)"]
        let final = url.stringByReplacingPlaceholders(placeholders: pathParams)
        return final
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("TV Show detail: \(json)")
            tvShow = TvShowItem(json: json)
        }
    }
}
