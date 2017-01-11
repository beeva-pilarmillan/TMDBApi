//
//  TMDBHTTPResponse.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

struct TMDBResponse {
    let internalResponse: HTTPURLResponse
    let tmdbStatus: TMDBStatus?
    
    var success: Bool {
        return [200, 201].contains(internalResponse.statusCode)
    }
    
    var error: Error? {
        
        guard !success, let status = tmdbStatus else {
            return nil
        }

        return NSError(domain: "TMDBErrorDomain", code: status.code, userInfo: ["message": status.message])
    }
}

extension TMDBResponse {
    
    static func parse(json: JSON, response: HTTPURLResponse) -> TMDBResponse {
        
        let status = TMDBStatus.parse(json: json)
        return TMDBResponse(internalResponse: response, tmdbStatus: status)
    }
}
