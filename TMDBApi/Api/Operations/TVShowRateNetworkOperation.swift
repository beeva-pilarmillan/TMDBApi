//
//  TVShowRateNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class TVShowRateNetworkOperation: JSONNetworkOperation {
    
    fileprivate let tvShowId: Int
    fileprivate let score: Double
    fileprivate let sessionId: String
    var status: TMDBStatus?
    
    override var addLanguageQueryParam: Bool {
        return false
    }
    
    init(tvShowId: Int, score: Double, sessionId: String) {
        self.tvShowId = tvShowId
        self.score = score
        self.sessionId = sessionId
    }
    
    override var queryParams: [URLQueryItem] {
        
        var params = super.queryParams
        params.append(URLQueryItem(name: "guest_session_id", value: sessionId))
        return params
    }
    
    override func prepareRequest() -> TMDBHTTPRequest? {
        guard var request = super.prepareRequest() else {
            return nil
        }
        
        request.POST()
        request.JSON(body: body())
        request.addQueryParams(params: queryParams)
        return request
    }
    
    override func getEndpoint() -> String {
        return "/tv/{tv_id}/rating"
    }
    
    override func url() -> String {
        let url = super.url()
        let pathParams = ["{tv_id}" : "\(tvShowId)"]
        let final = url.stringByReplacingPlaceholders(placeholders: pathParams)
        return final
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("TV Show rating: \(json)")
            status = TMDBStatus.parse(json: json)
        }
    }
}

private extension TVShowRateNetworkOperation {
    
    func body() -> Data? {
        let body: JSON = [ "value" : score ]
        return try? body.rawData()
    }
}
