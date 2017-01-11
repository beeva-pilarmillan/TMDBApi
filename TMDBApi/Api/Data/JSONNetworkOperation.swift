//
//  JSONNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

class JSONNetworkOperation: NetworkOperation {
    
    override var type: TMDBHTTPTaskType? {
        return .Data
    }
    
    override var uriRoot: String {
        return apiConfiguration.serverHost
    }

    internal var addLanguageQueryParam: Bool {
        return true
    }
    
    internal var queryParams: [URLQueryItem] {
       
        var params = [URLQueryItem(name: "api_key", value: apiConfiguration.apiKey)]
        
        if addLanguageQueryParam {
            params.append(URLQueryItem(name: "language", value: "es-ES"))
        }
        
        return params
    }
    
    override func prepareResponse(parsedData: Any, response: HTTPURLResponse) -> TMDBResponse? {
        guard let json = parsedData as? JSON else {
            return nil
        }
        
        return TMDBResponse.parse(json: json, response: response)
    }
    
    override func getParser(data: Data) -> Any? {
        return JSONParser(data)
    }
}
