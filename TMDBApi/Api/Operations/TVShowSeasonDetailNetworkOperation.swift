//
//  TVShowSeasonDetailNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class TVShowSeasonDetailNetworkOperation: JSONNetworkOperation {
    
    fileprivate let tvShowId: Int
    fileprivate let seasonNumber: Int
    var season: TVShowSeason?
    
    init(tvShowId: Int, seasonNumber: Int) {
        self.tvShowId = tvShowId
        self.seasonNumber = seasonNumber
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
        return "/tv/{tv_id}/season/{season_number}"
    }
    
    override func url() -> String {
        let url = super.url()
        let pathParams = ["{tv_id}": "\(tvShowId)", "{season_number}": "\(seasonNumber)"]
        let final = url.stringByReplacingPlaceholders(placeholders: pathParams)
        return final
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("TV Show Season detail: \(json)")
            season = TVShowSeason(json: json)
        }
    }
}
