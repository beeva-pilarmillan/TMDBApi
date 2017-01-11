//
//  MovieRateNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class MovieRateNetworkOperation: JSONNetworkOperation {
    
    fileprivate let movieId: Int
    fileprivate let score: Double
    fileprivate let sessionId: String
    fileprivate var status: TMDBStatus?
    
    var isRateSuccessful: Bool {
        return status?.code == 1
    }
    
    override var addLanguageQueryParam: Bool {
        return false
    }
    
    init(movieId: Int, score: Double, sessionId: String) {
        self.movieId = movieId
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
        return "/movie/{movie_id}/rating"
    }
    
    override func url() -> String {
        let url = super.url()
        let pathParams = ["{movie_id}" : "\(movieId)"]
        let final = url.stringByReplacingPlaceholders(placeholders: pathParams)
        return final
    }
    
    override func finish() {
        
        if let json = self.parsedData as? JSON {
            print("Movie rating: \(json)")
            status = TMDBStatus.parse(json: json)
            
            if !isRateSuccessful, let status = status {
                error = NSError(domain: "TMDBMovieRateOperation", code: status.code, userInfo: ["message": status.message])
            }
        }
    }
}

private extension MovieRateNetworkOperation {
    
    func body() -> Data? {
        let body: JSON = [ "value" : score ]
        return try? body.rawData()
    }
}
