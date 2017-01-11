//
//  FileNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class FileNetworkOperation: NetworkOperation {
    
    fileprivate let filePath: String
    
    override var type: TMDBHTTPTaskType? {
        return .Image
    }
    
    override var uriRoot: String {
        return apiConfiguration.imageServerHost
    }
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    
    override func prepareRequest() -> TMDBHTTPRequest? {
        guard let url = URL(string: url()) else {
            return nil
        }

        var request = TMDBHTTPRequest(url: url)
        request.GET()
        
        return request
    }
    
    override func getEndpoint() -> String {
        return filePath
    }
}
